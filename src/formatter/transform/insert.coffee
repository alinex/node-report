# Mark
# =================================================


chalk = require 'chalk'


# Transformer rules
#
# @type {Object<Transformer>} rules to set output text in token
module.exports =

  md:
    format: 'md'
    type: 'insert'
    fn: (num, token) -> token.out = "++"

  text:
    format: 'text'
    type: 'insert'
    fn: (num, token) ->
      return unless @setup.ansi_escape
      chalk = new chalk.constructor {enabled: true}
      marker = chalk.underline('?').split /\?/
      token.out = if token.nesting is 1 then marker[0] else marker[1]

  html:
    format: 'html'
    type: 'insert'
    fn: (num, token) ->
      token.out = switch token.nesting
        when 1 then "<ins#{@htmlAttribs token}>"
        when -1 then "</ins>"
        else "<ins></ins>"
