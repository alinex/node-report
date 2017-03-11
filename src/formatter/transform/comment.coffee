# Comment
# =================================================


# Transformer rules
#
# @type {Object<Transformer>} rules to set output text in token
module.exports =

  md:
    format: 'md'
    type: 'comment'
    fn: (num, token) ->
      token.out = "<!-- #{token.content} -->"
      token.out = "\n#{token.out}\n" if token.block

  html:
    format: 'html'
    type: 'comment'
    fn: (num, token) ->
      token.out = "<!-- #{token.content} -->"
      unless @setup.compress
        token.out = "\n#{token.out}\n" if token.block
