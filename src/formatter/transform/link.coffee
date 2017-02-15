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
