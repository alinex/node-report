# Headings
# =================================================


# Transformer rules
#
# @type {Object<Transformer>} rules to set output text in token
module.exports =

  markdown:
    format: ['md', 'text']
    type: 'blockquote'
    fn: (num, token) ->
      prev = @tokens.get num - 1
      token.collect = token.collect
      .replace /^\n|\n$/g, ''
      .replace /\n/g, '\n> '
      token.collect = "> #{token.collect}\n"
      token.collect = "\n#{token.collect}" unless prev.hidden
