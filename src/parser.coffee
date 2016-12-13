console.log '>>>', 'PARSER', '<<<<'


debug = require('debug') 'report:parser'
util = require 'alinex-util'
fs = require 'fs'
path = require 'path'


debug "Initializing..."

# load element definitions
elements = {}
list = fs.readdirSync "#{__dirname}/element"
list.sort()
for file in list
  elements[path.basename file, path.extname file] = require "./element/#{file}"
console.log 'Elements:', elements

# collect possible states
states = []
for key, lib of elements
  continue unless lib.lexer
  for name, rule of lib.lexer
    for state in rule.state
      states.push state unless state in states
console.log 'States:', states

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
console.log 'Lexer:', lexer

console.log '##############################################'



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

class Parser

  constructor: (@input, @state) ->
    @index = 0
    @tokens = []
    @level = 0
    @state ?= if @input.match /<body/ then 'html' else 'md'


  parse: (chars = @input) ->
    while chars.length
      debug "Parsing #{@index} #{util.string.shorten chars.replace /\n/g, '\\n'} as #{@state}"
      done = false
      for rule in lexer[@state]
        continue unless @state in rule.state
        console.log "#{@index} ?", rule
        if m = rule.re.exec chars
          console.log "#{@index} m", m
          if skip = rule.fn?.call this, m
            chars = chars.substr skip
            done = true
      unless done
        throw new Error "Not parseable maybe missing a rule at line #{@pos()}"
    this

  add: (t) ->
    @level += t.nesting if t.nesting < 0
    t.nesting ?= 0
    t.level = @level
    t.index ?= @index
    t.pos = @pos()
    @tokens.push t
    debug "Adding #{util.inspect(t).replace /\n */g, ' '}"
    if t.state
      @state = t.state
    @level += t.nesting if t.nesting > 0

  pos: ->
    part = @input.substr 0, @index
    line = part.match(/\n/g) ? 0
    col = @index - part.lastIndexOf('\n') - 1
    "#{line}:#{col}"


# @param `String` text to be parsed
# @param `String` format to parse from
# @return `Array<Token>` token list with:
module.exports = parse = (text, format = 'md') ->
  ##### auto decide format by detection
  parser = new Parser text, format
  console.log parser
  console.log '-----------------------------------------------------'
  parser.parse()
  .tokens

out = parse '# Text **15** Number 6'
console.log '-----------------------------------------------------'
console.log out
