# Text Phrases
# =================================================


# Transformer rules
#
# @type {Object<Transformer>} rules to set output text in token
module.exports =

  markdown:
    format: ['md', 'text', 'html', 'roff', 'latex', 'rtf']
    type: 'text'
    fn: (num, token) -> token.out = token.data.text
