# Text Phrases
# =================================================

util = require 'alinex-util'


# Transformer rules
#
# @type {Object<Transformer>} rules to set output text in token
module.exports =

  markdown:
    format: ['md']
    type: 'text'
    fn: (num, token) ->
      token.out = token.data.text
      .replace /^(#+\ )/, "\\$1"    # mask to not be interpreted as heading
      .replace /([*_~=`^])(?=\w|[*_~=`^]|$)/g, "\\$1" # mask special markdown

  html:
    format: ['html']
    type: 'text'
    fn: (num, token) ->
      token.out = util.string.htmlEncode token.data.text

  other:
    format: ['text', 'roff', 'latex', 'rtf']
    type: 'text'
    fn: (num, token) ->
      token.out = token.data.text
