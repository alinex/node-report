# Fixed
# =================================================


chalk = require 'chalk'


# Transformer rules
#
# @type {Object<Transformer>} rules to set output text in token
module.exports =

  text:
    format: 'text'
    type: 'fixed'
    fn: (num, token) ->
      return unless @setup.ansi_escape
      chalk = new chalk.constructor {enabled: true}
      marker = chalk.cyan('?').split /\?/
      token.out = if token.nesting is 1 then marker[0] else marker[1]

  html:
    format: 'html'
    type: 'fixed'
    fn: (num, token) ->
      token.out = switch token.nesting
        when 1 then "<code#{@htmlAttribs token}>"
        when -1 then "</code>"
        else "<code></code>"

  roff:
    format: 'roff'
    type: 'fixed'
    fn: (num, token) ->
      token.out = switch token.nesting
        when 1 then ".P\n.RS 2\n.nf\n"
        when -1 then ".fi\n.RE\n"
