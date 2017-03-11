# Style settings
# =================================================


# Transformer rules
#
# @type {Object<Transformer>} rules to set output text in token
module.exports =

  md:
    format: 'md'
    type: 'style'
    fn: (num, token) ->
      if token.format is 'html'
        token.out = "<!-- {#{token.content}} -->"
      else
        token.out = "<!-- @#{token.format} {#{token.content}} -->"
      token.out = "\n#{token.out}\n" if token.block
