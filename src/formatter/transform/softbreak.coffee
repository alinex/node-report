# Soft Break
# =================================================


# Transformer rules
#
# @type {Object<Transformer>} rules to set output text in token
module.exports =

  markdown:
    format: 'md'
    type: 'softbreak'
    fn: (num, token) ->
      token.out = "\n"

  text:
    format: 'text'
    type: 'softbreak'
    fn: (num, token) ->
      token.out = "\n"

  html:
    format: 'html'
    type: 'softbreak'
    fn: (num, token) ->
      token.out = "\n"

  roff:
    format: 'roff'
    type: 'softbreak'
    fn: (num, token) ->
      token.out = "\n"
