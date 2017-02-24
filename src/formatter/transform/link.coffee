# Link
# =================================================


# Transformer rules
#
# @type {Object<Transformer>} rules to set output text in token
module.exports =

  html:
    format: 'html'
    type: 'link'
    fn: (num, token) ->
      nl = if @setup.compress then '' else '\n'
      switch token.nesting
        when 1
          token.out = "<a href=\"#{token.href}\""
          token.out += " title=\"#{token.title}\"" if token.title
          token.out += ">"
        when -1
          token.out = "</a>#{nl}"

  other:
    format: ['md', 'text']
    type: 'link'
    fn: (num, token) ->
      if token.nesting is 1
        token.out = '['
      else
        [_, start] = @tokens.findStart num, token
        if start.reference
          token.out = "][#{start.reference}]"
        else
          [_, start] = @tokens.findStart num, token
          uri = if start.href.match /[()]/g then "<#{start.href}>" else start.href
          token.out = "](#{uri}"
          token.out += " \"#{start.title.replace /(")/g, '\\$1'}\"" if start.title
          token.out += ')'
