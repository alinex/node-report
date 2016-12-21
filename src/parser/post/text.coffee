# Text Phrases
# =================================================

# Transformer rules
#
# @type {Object<Transformer>} rules to transform text into tokens
module.exports =

  masked:
    type: 'text'
    state: ['m-inline', 'mh-inline', 'cache']
    fn: (num, token) ->
      token.data.text = token.data.text.replace /\\#/g, '#'
