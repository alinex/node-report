# Text Phrases
# =================================================

# Transformer rules
#
# @type {Object<Transformer>} rules to transform text into tokens
module.exports =

  character:
    type: 'text'
    state: ['m-inline', 'mh-inline']
    data:
      text: true
    fn: (num, token) ->
      token.data.text = token.data.text
      .replace /\\([\\!\"#$%&'()*+,\-./:;<=>?@[\]^_`{|}~])/g, '$1'    # remove mask
      .replace /\ufffd/g, ''  # remove not displayable character
      .replace /(?:\t|\ \ )[\t\ ]*\n/g, '\n' # line break
      .replace /(\S)(?:\t|\ \ )[\t\ ]*$/, '$1' # right trim last line
