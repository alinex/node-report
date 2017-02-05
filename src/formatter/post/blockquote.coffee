# Headings
# =================================================


# Transformer rules
#
# @type {Object<Transformer>} rules to set output text in token
module.exports =

  markdown:
    format: ['md', 'text']
    type: 'blockquote'
    nesting: 1
    fn: (num, token) ->
      token.collect = "\n> #{token.collect.trim().replace /\n/g, '\n> '}\n"
