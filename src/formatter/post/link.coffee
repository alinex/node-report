# Link
# =================================================


# Transformer rules
#
# @type {Object<Transformer>} rules to set output text in token
module.exports =

  other:
    format: ['md', 'text']
    type: 'link'
    fn: (num, token) ->
      uri = if token.href.match /[()]/g then "<#{token.href}>" else token.href
#      uri = token.href.replace /([()])/g, '\\$1'
      token.out = '['
      token.collect += "](#{uri}"
      token.collect += " \"#{token.title}\"" if token.title
      token.collect += ')'
