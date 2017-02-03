# List Item
# =================================================


# Post rules
#
# @type {Object<Transformer>} rules to set output text in token
module.exports =

  # Add title to document element from first heading
  text:
    type: 'item'
    format: ['md', 'text', 'roff']
    nesting: 1
    fn: (num, token) ->
      token.content = token.content.trim().replace /\n/g, '\n  ' # indent text

  # Add title to document element from first heading
  html:
    type: 'item'
    format: 'html'
    nesting: 1
    fn: (num, token) ->
      token.content = token.content.trim()
