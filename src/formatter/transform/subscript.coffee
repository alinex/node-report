# Mark
# =================================================


chalk = require 'chalk'


# Transformer rules
#
# @type {Object<Transformer>} rules to set output text in token
module.exports =

  md:
    format: 'md'
    type: 'subscript'
    fn: (num, token) -> token.out = "~"

  html:
    format: 'html'
    type: 'subscript'
    fn: (num, token) ->
      token.out = switch token.nesting
        when 1 then "<sub#{@htmlAttribs token}>"
        when -1 then "</sub>"
        else "<sub></sub>"
