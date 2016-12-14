# Parser
# =================================================


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
# - level
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

  # Run parsing a chunk of the input.
  #
  # @param {String} [chars] the part to be parsed now (may be called from lexer function recursivly)
  parse: (chars = @input) ->
    while chars.length
      if debug.enabled
        ds = util.inspect chars.substr(0, 30).replace /\n/g, '\\n'
        debugData "parse index:#{@index} #{ds} as #{@state}" if debugData.enabled
      done = false
      for rule in lexer[@state]
        continue unless @state in rule.state
        if m = rule.re.exec chars
          if skip = rule.fn?.call this, m
            chars = chars.substr skip
            done = true
      unless done
        throw new Error "Not parseable maybe missing a rule at line #{@pos()}"
    this

  # Add a token to the internal list.
  #
  # @param {Array<Token>} t `Token` object to be added
  add: (t) ->
    @level += t.nesting if t.nesting < 0
    t.nesting ?= 0
    t.level = @level
    t.index ?= @index
    t.pos = @pos()
    @tokens.push t
    debugData "add token #{util.inspect(t).replace /\n */g, ' '}" if debugData.enabled
    if t.state
      @state = t.state
    @level += t.nesting if t.nesting > 0

  # Get the current position in file.
  #
  # @return {String} line and column position
  pos: ->
    part = @input.substr 0, @index
    line = part.match(/\n/g) ? 0
    col = @index - part.lastIndexOf('\n') - 1
    "#{line}:#{col}"



# Parse a text into `Token` list.
#
# @param `String` text to be parsed
# @param `String` [format] to parse from (default: 'md')
# @return `Array<Token>` token list
module.exports = parse = (text, format = 'md') ->
  debug "Run parser in state #{format}" if debug.enabled
  parser = new Parser text, format
  parser.parse()
  debug "Done parsing" if debug.enabled
  parser.tokens

out = parse '# Text **15** Number 6'
console.log '######################################################'
console.log out
