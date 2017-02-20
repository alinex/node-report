# Headings
# =================================================


# Transformer rules
#
# @type {Object<Transformer>} rules to set output text in token
module.exports =

  html:
    format: 'html'
    type: 'raw'
    fn: (num, token) ->
      return unless token.format is 'html'
      nl = if @setup.compress then '' else '\n'
      token.out = "#{nl}#{token.content}#{nl}"

  md:
    format: 'md'
    type: 'raw'
    fn: (num, token) ->
      if token.format is 'html'
        token.out = token.content
      else
        token.out = "<!-- raw #{token.format}\n#{token.content}\n-->"
      token.out = "\n#{token.out}\n" if token.block
