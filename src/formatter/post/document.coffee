# Headings
# =================================================


# Post rules
#
# @type {Object<Transformer>} rules to set output text in token
module.exports =

  # Add title to document element from first heading
  title:
    format: ['md', 'text', 'roff', 'adoc']
    type: 'document'
    nesting: 1
    fn: (num, token) ->
      token.content = token.content.replace /^\n|\n$/, ''