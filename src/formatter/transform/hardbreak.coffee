# Hard Break
# =================================================


# Transformer rules
#
# @type {Object<Transformer>} rules to set output text in token
module.exports =

  markdown:
    format: 'md'
    type: 'hardbreak'
    fn: (num, token) ->
      token.out = "\\\n"

  text:
    format: 'text'
    type: 'hardbreak'
    fn: (num, token) ->
      token.out = "\n"

  html:
    format: 'html'
    type: 'hardbreak'
    fn: (num, token) ->
      token.out = "\n"

  roff:
    format: 'roff'
    type: 'hardbreak'
    fn: (num, token) ->
      token.out = "\n"
