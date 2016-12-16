# Parser
# =================================================
#  This may parse multiple text formats.

# Markdown parsing is based on http://spec.commonmark.org/




# Node Modules
# -------------------------------------------------
debug = require('debug') 'report:parser'
debugData = require('debug') 'report:parser:data'
fs = require 'fs'
path = require 'path'
# alinex modules
util = require 'alinex-util'


# Config
# -------------------------------------------------

# List of replacement rules to cleanup text for better parsing.
#
# @type {Array<Array>} list of replacements
CLEANUP = [
  [/\r\n|\r|\u2424/g, '\n'] # replcae carriage return and unicode newlines
  [/\t/g, '    ']           # replace tabs with four spaces
  [/\u00a0/g, ' ']          # replace other whitechar with space
  [/\u0000/g, '\ufffd']     # replace \0 as non visible replacement char
]


# Setup
# -------------------------------------------------
debug "Initializing..."
# load element definitions
elements = {}
list = fs.readdirSync "#{__dirname}/element"
list.sort()
for file in list
  elements[path.basename file, path.extname file] = require "./element/#{file}"
debugData "possible elements:", Object.keys elements if debugData.enabled
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
      rule.name = key + if rule.name then ":#{rule.name}" else ''
      lexer[state] ?= []
      lexer[state].push rule
if debugData.enabled
  for k, v of lexer
    for e in v
      debugData "lexer rule for #{k}:", e.name, e.re



# Rule:
# - element
# - name
# - state - where is the rule allowed
# - re
# - fn

# Tokens:
# - type
# - nesting - 1 open, 0 atomic, -1 close
# - autoclose
# - level
# - parent
# - data
# - index - position from input
# - pos
# - state - that is allowed within


# Parser
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
    @state ?= if @input.match /<body/ then 'html' else 'md'
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
# @param `String` [format] to parse from (default: 'md')
# @return `Array<Token>` token list
module.exports = (text, format = 'md') ->
  debug "Run parser in state #{format}" if debug.enabled
  for rule in CLEANUP
    text = text.replace rule[0], rule[1]
  parser = new Parser text, format
  parser.parse()
  debug "Done parsing" if debug.enabled
  parser.end()
