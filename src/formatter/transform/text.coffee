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
      token.out = token.content
      return if token.parent.type in ['preformatted', 'code', 'fixed']
      token.out = token.out
      .replace /\\(?=[^\n])/g, '\\\\'
      # mask special markdown
      .replace /^(#{1,6}\ )/, "\\$1"
      .replace /([*_~=`^])(?=\w|[*_~=`^]|$)/g, "\\$1"
      .replace /^([-*>])/, "\\$1"
#      .replace /([!"#$%&'()*+,-./:;<=>?@[\]^_`{|}~])/g, "\\$1" # mask all

  html:
    format: 'html'
    type: 'text'
    fn: (num, token) ->
      token.out = util.string.htmlEncode token.content
      return if token.parent.type is 'preformatted'
      token.out = token.out
      .replace /\n/g, '<br />\n'
      .replace /\u00a0/g, '&nobr;'

  roff:
    format: 'roff'
    type: 'text'
    fn: (num, token) ->
      token.out = token.content
#      .replace /\n/g, '\n.br\n'

  asciidoc:
    format: 'adoc'
    type: 'text'
    fn: (num, token) ->
      token.out = token.content
      .replace /\n/g, ' +\n'

  other:
    format: ['text', 'latex', 'rtf']
    type: 'text'
    fn: (num, token) ->
      token.out = token.content
