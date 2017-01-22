# Text Phrases
# =================================================

# Transformer rules
#
# @type {Object<Transformer>} rules to transform text into tokens
module.exports =

  character:
    type: 'text'
    state: ['m-inline']
    data:
      text: true
    fn: (num, token) ->
      token.data.text = token.data.text.replace /\n$/, ''
      return if token.parent?.type is 'preformatted'
      token.data.text = token.data.text
      .replace /([^\\])\n/g, "$1 " # remove newlines if not escaped
      .replace /([^\\])?\\\n/g, "$1\n" # remove escape characters before newlines
      .replace /([^\\])?\\([\\!\"#$%&'()*+,\-./:;<=>?@[\]^_`{|}~])/g, '$1$2' # remove mask
      .replace /[\t ]+/g, ' ' # multiple spaces
