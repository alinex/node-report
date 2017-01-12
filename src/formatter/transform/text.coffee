# Text Phrases
# =================================================

util = require 'alinex-util'


# Transformer rules
#
# @type {Object<Transformer>} rules to set output text in token
module.exports =

  markdown:
    format: 'md'
    type: 'text'
    fn: (num, token) ->
      token.out = token.data.text
      .replace /^(#+\ )/, "\\$1"    # mask to not be interpreted as heading
      .replace /\\(?=[^\n])/g, '\\\\'
      .replace /([*_~=`^])(?=\w|[*_~=`^]|$)/g, "\\$1" # mask special markdown
#      .replace /([!"#$%&'()*+,-./:;<=>?@[\]^_`{|}~])/g, "\\$1" # mask all

  html:
    format: 'html'
    type: 'text'
    fn: (num, token) ->
      token.out = util.string.htmlEncode token.data.text
      .replace /\n/g, '<br />\n'

  roff:
    format: 'roff'
    type: 'text'
    fn: (num, token) ->
      token.out = token.data.text
      .replace /\n/g, '\n.br\n'

  asciidoc:
    format: 'adoc'
    type: 'text'
    fn: (num, token) ->
      token.out = token.data.text
      .replace /\n/g, ' +\n'

  other:
    format: ['text', 'latex', 'rtf']
    type: 'text'
    fn: (num, token) ->
      token.out = token.data.text
