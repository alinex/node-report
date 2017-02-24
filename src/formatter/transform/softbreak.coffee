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
      token.out = if @setup.keep_soft_breaks then '\n' else ' '

  text:
    format: 'text'
    type: 'softbreak'
    fn: (num, token) ->
      token.out = "\n"

  html:
    format: 'html'
    type: 'softbreak'
    fn: (num, token) ->
      token.out = if @setup.keep_breaks and not @tokens.in ['preformatted', 'code', 'fixed'], token
        '<br />'
      else
        '\n'

  roff:
    format: 'roff'
    type: 'softbreak'
    fn: (num, token) ->
      token.out = "\n"
