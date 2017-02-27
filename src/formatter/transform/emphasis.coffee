# Emphasis
# =================================================


chalk = require 'chalk'


# Transformer rules
#
# @type {Object<Transformer>} rules to set output text in token
module.exports =

  strong_md:
    format: 'md'
    type: 'strong'
    fn: (num, token) -> token.out = token.marker + token.marker

  strong_text:
    format: 'text'
    type: 'strong'
    fn: (num, token) ->
      return unless @setup.ansi_escape
      chalk = new chalk.constructor {enabled: true}
      marker = chalk.bold('?').split /\?/
      token.out = if token.nesting is 1 then marker[0] else marker[1]

  strong_html:
    format: 'html'
    type: 'strong'
    fn: (num, token) ->
      token.out = if token.nesting is 1 then '<strong>' else '</strong>'

  strong_roff:
    format: 'roff'
    type: 'strong'
    fn: (num, token) ->
      token.out = if token.nesting is 1 then '\\fB' else '\\fR'

  emphasis_md:
    format: 'md'
    type: 'emphasis'
    fn: (num, token) -> token.out = token.marker

  emphasis_text:
    format: 'text'
    type: 'emphasis'
    fn: (num, token) ->
      return unless @setup.ansi_escape
      chalk = new chalk.constructor {enabled: true}
      marker = chalk.italic('?').split /\?/
      token.out = if token.nesting is 1 then marker[0] else marker[1]

  emphasis_html:
    format: 'html'
    type: 'emphasis'
    fn: (num, token) ->
      token.out = if token.nesting is 1 then '<em>' else '</em>'
