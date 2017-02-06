# Thematic Break
# =================================================

util = require 'alinex-util'


# Transformer rules
#
# @type {Object<Transformer>} rules to set output text in token
module.exports =

  markdown:
    format: 'md'
    type: 'thematic_break'
    fn: (num, token) ->
      token.out = "#{util.string.repeat '*', @setup.width}"

  text:
    format: 'text'
    type: 'thematic_break'
    fn: (num, token) ->
      token.out = "#{util.string.repeat '─', @setup.width}"

  html:
    format: 'html'
    type: 'thematic_break'
    fn: (num, token) ->
      nl = if @setup.compress then '' else '\n'
      token.out = "<hr />#{nl}"

  roff:
    format: 'roff'
    type: 'thematic_break'
    fn: (num, token) ->
      token.out = ".HR\n"
