# Image
# =================================================


# Transformer rules
#
# @type {Object<Transformer>} rules to set output text in token
module.exports =

  html:
    format: 'html'
    type: 'image'
    fn: (num, token) ->
      switch token.nesting
        when 1
          token.out = "<img src=\"#{token.src}\""
          token.out += " title=\"#{token.title}\"" if token.title
          token.out += " />"

  other:
    format: ['md', 'text']
    type: 'image'
    fn: (num, token) ->
      if token.nesting is 1
        token.out = '!['
      else
        [_, start] = @tokens.findStart num, token
        uri = if start.src.match /[()]/g then "<#{start.src}>" else start.src
        token.out = "](#{uri}"
        token.out += " \"#{start.title.replace /(")/g, '\\$1'}\"" if start.title
        token.out += ')'
