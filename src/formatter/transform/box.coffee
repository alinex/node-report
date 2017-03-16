# Blockquote
# =================================================


# Transformer rules
#
# @type {Object<Transformer>} rules to set output text in token
module.exports =

  container_indent:
    format: 'text'
    type: 'container'
    nesting: 1
    fn: (num, token) ->
      token.indent = (token.parent.indent ? 0) + 4

  box_indent:
    format: 'text'
    type: 'box'
    nesting: 1
    fn: (num, token) ->
      token.indent = token.parent.indent
