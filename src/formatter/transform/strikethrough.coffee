# Strikethrough
# =================================================


chalk = require 'chalk'


# Transformer rules
#
# @type {Object<Transformer>} rules to set output text in token
module.exports =

  html:
    format: 'html'
    type: 'strikethrough'
    fn: (num, token) ->
      token.out = switch token.nesting
        when 1 then "<s>"
        when -1 then "</s>"
        else "<s></s>"

  md:
    format: ['md']
    type: 'strikethrough'
    fn: (num, token) ->
      token.out = '~~'

  other:
    format: ['text']
    type: 'strikethrough'
    fn: (num, token) ->
      if @setup.ansi_escape
        chalk = new chalk.constructor {enabled: true}
        marker = chalk.gray.strikethrough('?').split /\?/
        token.out = if token.nesting is 1 then marker[0] else marker[1]
      else
        token.out = if token.nesting is 1 then '(' else ')'
