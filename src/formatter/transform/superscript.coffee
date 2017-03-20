# Superscript
# =================================================


chalk = require 'chalk'


# Transformer rules
#
# @type {Object<Transformer>} rules to set output text in token
module.exports =

  md:
    format: 'md'
    type: 'superscript'
    fn: (num, token) -> token.out = "^"

  html:
    format: 'html'
    type: 'superscript'
    fn: (num, token) ->
      token.out = switch token.nesting
        when 1 then "<sup#{@htmlAttribs token}>"
        when -1 then "</sup>"
        else "<sup></sup>"
