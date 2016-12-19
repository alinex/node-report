# Parser
# =================================================
# This may parse multiple text formats into token lists. This is done using the
# plugable structure with the concrete commands from each elements definition module.
#
# ### Lexer
#
# The parsing is done by first substituting some problematic characters and then
# running the result through the partly recursive lexer. In this steps the text is
# processed in a linear way character by character against a list of regular expressions
# of the possible elements. To decide which elements are possible at the current
# position a state is defined, which may change for sub parts. The state consists
# mostly of two parts: `<domain>-<area>` the possible domains are: `m` for markdown,
# `mh` for markdown with html and `h` for html. Within the rules the new state may
# be set to `-<name>` meaning that the domain before will be kept.
#
# Each element may contain multiple named lexer rules under the `lexer` object with
# the following data:
# - `String` - `element` name of this element (automatically set)
# - `String` - `name` of this rule (automatically set)
# - `Array<String>` - `state` all the possible states in which this rule is allowed
# - `RegExp` - `re` to check if this rule should be applied
# - `Function(Match)` - `fn` to run if the rule matched.
#   Here you may call `add()`, change the index position run sub `parse()` and lastly
#   return the number of characters which werde done and can be skipped for the
#   next run.
#
# ### Tokens
#
# The resulting token list may contain any of the defined elements. And are stored
# in an array as object:
# - `String` - `type` name of the element
# - `Integer` - `nesting` type: `1` = open, `0` = atomic, `-1` = close
# - `Integer` - `level` depth of structure
# - `Object` - `parent` reference
# - `Mixed` - `data` content of this element
# - `String` - `index` position from input
# - `String` - `pos` current position in input text
# - `String` - `state` that is allowed within the current element

# Markdown parsing is based on http://spec.commonmark.org/


# Node Modules
# -------------------------------------------------
debug = require('debug') 'report:parser'
debugData = require('debug') 'report:parser:data'
fs = require 'fs'
path = require 'path'
# alinex modules
util = require 'alinex-util'


# Setup
# -------------------------------------------------
debug "Initializing..."

# @param {String} type to load
# @return {Object<Module>} the loaded modules
libs = (type) ->
  list = fs.readdirSync "#{__dirname}/#{type}"
  list.sort()
  map = {}
  for file in list
    continue unless path.extname(file) in ['.js', '.coffee']
    map[path.basename file, path.extname file] = require "./#{type}/#{file}"
  map

# Load helper
preLibs = libs 'pre'
debugData "possible pre optimizations:", Object.keys preLibs if debugData.enabled
transLibs = libs 'transform'
debugData "possible transformer:", Object.keys transLibs if debugData.enabled
preLibs = libs 'post'
debugData "possible post optimizations:", Object.keys preLibs if debugData.enabled

# collect possible states
states = []
for key, lib of elements
  continue unless lib.lexer
  for name, rule of lib.lexer
    for state in rule.state
      states.push state unless state in states
debugData "possible states:", states if debugData.enabled
# collect rules for each state
lexer = {}
for key, lib of elements
  continue unless lib.lexer
  for name, rule of lib.lexer
    for state in rule.state
      rule.element = key
      rule.name = key + if name then ":#{name}" else ''
      lexer[state] ?= []
      lexer[state].push rule
if debugData.enabled
  for k, v of lexer
    for e in v
      debugData "lexer rule for #{k}:", e.name, e.re


# Parser Class
# -------------------------------------------------
class Parser

  # Create a new parser object.
  #
  # @param {String} input text to be parsed
  # @param {String} [state] used initialy for the lexer
  constructor: (@input, @state) ->
    @index = 0
    @tokens = []
    @level = 0
    @state ?= if @input.match /<body/ then 'h-block' else 'm-block'
    @states = [@state]

  # Run parsing a chunk of the input.
  #
  # @param {String} [chars] the part to be parsed now (may be called from lexer function recursivly)
  parse: (chars = @input) ->
    while chars.length
      if debug.enabled
        ds = util.inspect chars.substr(0, 30).replace /\n/g, '\\n'
        debugData "parse index:#{@index} #{ds} as #{@state}" if debugData.enabled
      done = false
      # try rules for state
      for rule in lexer[@state]
        continue unless @state in rule.state
        if m = rule.re.exec chars
          if skip = rule.fn?.call this, m
            chars = chars.substr skip
            done = true
      # check for problems
      unless done
        throw new Error "Not parseable maybe missing a rule at line #{@pos()}"
    this

  # Add a token to the internal list.
  #
  # @param {Array<Token>} t `Token` object to be added
  add: (t) ->
    prev = if @tokens[@tokens.length - 1] then @tokens[@tokens.length - 1] else null
    if t.nesting < 0
      @state = @states.pop()
      @level--
    t.nesting ?= 0
    t.level = @level
    t.parent = switch
      when prev?.nesting is 1 then prev
      when t.nesting is -1
        if prev.level > @level then prev.parent.parent
        else prev.parent
      else prev?.parent ? null
    t.state = @state.split(/-/)[0] + t.state if t.state?[0] is '-'
    t.index ?= @index
    t.pos = @pos()
    @tokens.push t
    debugData "add token #{util.inspect(t).replace /\n */g, ' '}" if debugData.enabled
    if t.nesting > 0
      @state = t.state if t.state
      @states.push @state
      @level++

  # Check if tags could be autoclosed to come into defined state.
  #
  # @param {String} state to reach by autoclosing
  # @return {Boolean} `true` if state could be reached by autoclose
  autoclose: (state) ->
    state = @state.split(/-/)[0] + state if state[0] is '-'
    token = @tokens[@tokens.length -1]
    list = []
    while token = token.parent
      return false unless token
      list.push token
      break if token.state is state
    # close tags
    for token in list
      t = util.clone token
      t.nesting = -1
      t.index = @index
      delete t.state
      @level = t.level
      @state = @states.pop()
      @tokens.push t
      if debugData.enabled
        debugData "auto close token #{util.inspect(t).replace /\n */g, ' '}"

  # Get the current position in file.
  #
  # @return {String} line and column position
  pos: ->
    part = @input.substr 0, @index
    line = part.match(/\n/g) ? 0
    col = @index - part.lastIndexOf('\n') - 1
    "#{line}:#{col}"

  # End the parsing and check the result.
  #
  # @return {Array<Token>} list of parsed tokens
  end: ->
    # check if parsing started
    throw new Error "Nothing parsed" unless @tokens.length
    # check for correct structure
    if @level
      unless @autoclose @states[0]
        throw new Error "Not all elements closed correctly (ending in level #{@level})"
    # return token list
    @tokens



# Parse a text into `Token` list.
#
# @param `String` text to be parsed
# @param `String` [format] to parse from (default: 'm')
# @return `Array<Token>` token list
module.exports = (text, format = 'm-block') ->
  debug "Run parser in state #{format}" if debug.enabled
  for rule in CLEANUP
    text = text.replace rule[0], rule[1]
  parser = new Parser text, format
  parser.parse()
  debug "Done parsing" if debug.enabled
  parser.end()
