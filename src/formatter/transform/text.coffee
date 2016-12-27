# Text Phrases
# =================================================


# Transformer rules
#
# @type {Object<Transformer>} rules to set output text in token
module.exports =

  markdown:
    format: 'md'
    type: 'text'
    fn: (num, token) -> token.out = token.data.text

  text:
    format: 'text'
    type: 'text'
    fn: (num, token) -> token.out = token.data.text

  html:
    format: 'html'
    type: 'text'
    fn: (num, token) -> token.out = token.data.text

  roff:
    format: 'roff'
    type: 'text'
    fn: (num, token) -> token.out = token.data.text
    
