# Headings
# =================================================


# Post rules
#
# @type {Object<Transformer>} rules to set output text in token
module.exports =

  # Add title to document element from first heading
  title:
    type: 'preformatted'
    format: ['md', 'text']
    fn: (num, token) ->
      token.collect = '    ' + token.collect.replace /\n/g, "\n    " # indent text
