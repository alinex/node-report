# Thematic Break
# =================================================

chalk = require 'chalk'
util = require 'alinex-util'


# Transformer rules
#
# @type {Object<Transformer>} rules to set output text in token
module.exports =

  markdown:
    format: 'md'
    type: 'thematic_break'
    fn: (num, token) ->
      token.out = "\n#{util.string.repeat '*', @setup.width}\n"

  text:
    format: 'text'
    type: 'thematic_break'
    fn: (num, token) ->
      chalk = new chalk.constructor {enabled: @setup.ansi_escape ? false}
      token.out = "\n#{chalk.gray util.string.repeat '─', @setup.width}\n"

  html:
    format: 'html'
    type: 'thematic_break'
    fn: (num, token) ->
      nl = if @setup.compress then '' else '\n'
      token.out = "<hr#{@htmlAttribs token} />#{nl}"

  roff:
    format: 'roff'
    type: 'thematic_break'
    fn: (num, token) ->
      token.out = ".HR\n"
