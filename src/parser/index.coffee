# Parser
# =================================================
# This may parse multiple text formats into token lists. This is done using the
# plugable structure with the concrete commands within.
#
# The parsing is done in three steps:
# 1. pre optimize some problematic characters in source for the defined domain
# 2. transform text into token list
# 3. post format the transformer list
#
#
# ### Resulting Tokens
#
# The resulting token list may contain any of the defined elements. And are stored
# in an array as object:
# - `String` - `type` name of the element
# - `Integer` - `nesting` type: `1` = open, `0` = atomic, `-1` = close
# - `Integer` - `level` depth of structure
# - `Object` - `parent` reference
# - `Object` - `data` content of this element
# - `String` - `index` position from input
# - `String` - `pos` current position in input text
# - `String` - `state` that is allowed within the current element
# - `Boolean` - `closed` is set to true on blank line to stop continuing it


# Node Modules
# -------------------------------------------------
debug = require('debug') 'report:parser'
debugData = require('debug') 'report:parser:data'
debugRule = require('debug') 'report:parser:rule'
chalk = require 'chalk'
fs = require 'fs'
path = require 'path'
# alinex modules
util = require 'alinex-util'


# Setup
# -------------------------------------------------
debug "Initializing..."

# @type {Object<String>} start state for domain
START =
  m: 'm-block'
  mh: 'mh-block'
  h: 'h-doc'

# @param {String} type to load
# @return {Object<Module>} the loaded modules
libs = (type) ->
  list = fs.readdirSync "#{__dirname}/#{type}"
  list.sort()
  map = {}
  for file in list
    continue unless path.extname(file) in ['.js', '.coffee']
    name = path.basename(file, path.extname file).replace /^\d+_/, ''
    map[name] = require "./#{type}/#{file}"
  map

# Load helper
preLibs = libs 'pre'
debugRule "possible pre optimizations:", Object.keys preLibs if debugRule.enabled
transLibs = libs 'transform'
debugRule "possible transformer:", Object.keys transLibs if debugRule.enabled
postLibs = libs 'post'
debugRule "possible post optimizations:", Object.keys preLibs if debugRule.enabled
# collect possible states
states = []
for key, lib of transLibs
  for name, rule of lib
    for state in rule.state
      states.push state unless state in states
debugRule "possible states:", util.inspect(states).replace /\n +/g, ' ' if debugRule.enabled
# collect rules for each state
lexer = {}
for key, lib of transLibs
  for name, rule of lib
    rule.name = "#{key}:#{name}"
    for state in rule.state
      lexer[state] ?= []
      lexer[state].push rule
if debugRule.enabled
  for k, v of lexer
    for e in v
      debugRule "lexer rule for #{k}:", e.name, chalk.grey e.re


# Parser Class
# -------------------------------------------------
class Parser

  # Auto detect state for text.
  #
  # @param {String} [text] to autodetect start state (defaults to @input)
  # @return {String} start state or null if not possible
  @detect: (text) ->
    return null unless text
    if text.match /<body/ then 'h-block' else 'm-block'

  # Create a new parser object.
  #
  # @param {String} input text to be parsed
  # @param {String} [state] or domain used initialy for the lexer
  constructor: (@input = '', @state) ->
    @state ?= Parser.detect @input
    @state = START[@state] if START[@state]
    @domain = @state.split(/-/)[0]
    # initial parsing data
    @index = 0
    @tokens = []
    @level = 0
    @states = [@state]

  # Parse a text into `Token` list or add them to the exisitng one if called
  # again.
  #
  # @param {String} text to be parsed (defaults to @input)
  # @return {Parser} for command concatenation
  parse: (text) ->
    if text then @input += text else text = @input
    debug "pre optimizations for domain #{@domain}" if debug.enabled
    for name, rule of preLibs
      continue unless rule[@domain]
      old = text if debugRule
      text = rule[@domain] text
      debugRule "changed by rule #{name}" if debugRule and old isnt text
    debug "start transformation in state #{@state}" if debug.enabled
    start = @tokens.length
    @lexer text
    end = @tokens.length - 1
    if start <= end
      debug "post optimization"
      for name, lib of postLibs
        for sub, rule of lib
          for token, num in @tokens
            continue if token.type isnt rule.type
            continue if rule.state and not token.state in rule.state
            debugRule "call rule #{name}:#{sub} for token ##{num}" if debugRule
            rule.fn.call this, num, token

  # Run parsing a chunk of the input.
  #
  # @param {String} [chars] the part to be parsed now (may be called from lexer function recursivly)
  lexer: (chars) ->
    while chars.length
      if debugData.enabled
        ds = util.inspect chars.substr 0, 30
        debugData "parse index:#{@index} #{chalk.grey ds} in state #{@state}"
      done = false
      # try rules for state
      console.log @state
      for rule in lexer[@state]
        continue unless @state in rule.state
        debugRule "check rule #{rule.name}: #{chalk.grey rule.re}" if debugRule
        if m = rule.re.exec chars
          if skip = rule.fn?.call this, m
            chars = chars.substr skip
            done = true
            break
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
      @states.pop()
      @state = @states[@states.length - 1]
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
    debugData "add token #{chalk.grey util.inspect(t).replace /\n */g, ' '}" if debugData.enabled
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
    line = part.match(/\n/g)?.length ? 0
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
    debug "Done parsing" if debug.enabled
    # return token list
    @tokens



# Make class available from the outside
module.exports = Parser
