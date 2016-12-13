console.log '>>>', 'PARSER', '<<<<'


debug = require('debug') 'report:parser'
util = require 'alinex-util'

# Tokens:
# - type
# - nesting - 1 open, 0 atomic, -1 close
# - level
# - data
# - index - position from input


elements =
  markdown: [
    'heading'
  ]


class Parser

  constructor: (@format) ->
    @tokens = []
    @rules = []
    @state = 0
    @input = null
    @index = 0
    for e in elements[@format]
      lib = require "./element/#{e}"
      if rule = lib.lexer[@format]
        rule.name = e
        @rules.push rule

  parse: (@input) ->
    if debug.enabled
      debug "Parsing #{util.string.shorten @input.replace /\n/g, '\\n'} as #{@format}"
    chars = @input
    level = 0
    try
      while chars.length
        console.log "#{@index} I", chars.replace /(.)\n[\s\S]*/, '$1'
        done = false
        for rule in @rules
          console.log "#{@index} ?", rule
          if m = rule.re.exec chars
            console.log "#{@index} m", m
            if token = rule.token?.call this, m
              token = [token] unless Array.isArray token
              for t in token
                level += t.nesting if t.nesting < 0
                t.type ?= rule.name
                t.nesting ?= 0
                t.level = level
                t.index ?= @index
                @tokens.push t
                level += t.nesting if t.nesting > 0
                console.log "#{@index} =", t
            strip = rule.strip?(m) ? m[0].length
            if strip
              chars = chars.substr strip
              @index += strip
              done = true
        throw new Error "Not parseable maybe missing a rule" unless done
    catch error
      error.index ?= 0
      error.index += @index
      part = @input.substr 0, error.index
      lines = part.match(/\n/g) ? 0
      chars = error.index - part.lastIndexOf('\n') - 1
      error.message = error.message.replace /\ at\ line\ \d+:\d+$/, ''
      error.message += " at line #{lines}:#{chars}"
      throw error
    this



# @param `String` format to parse from
# @param `String` text to be parsed
# @return `Array<Token>` token list with:
module.exports = parse = (format, text) ->
  parser = new Parser format
  console.log parser
  console.log '-----------------------------------------------------'
  parser.parse text
  .tokens

out = parse 'markdown', '# Text **15** Number 6'
console.log '-----------------------------------------------------'
console.log out
