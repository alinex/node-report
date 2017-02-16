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
      # mask special markdown (but as few as possible to make it more readable)
      .replace /^(#{1,6}\ )/g, "\\$1" # prevent atx heading
      .replace /([_*~=`^])(?=\w|[*_~=`^]|$)/g, "\\$1" # prevent inline formatting
      .replace /^(\s{0,3}\d+)([.)] )/, "$1\\$2" # prevent ordered lists
      .replace /^(\s{0,3})([-*] )/, "$1\\$2" # prevent bullet list
      .replace /^(\s{0,3})>/, "$1\\>" # prevent blockquote
      .replace /<([^>]*)>/g, "\\<$1>" # prevent html
      .replace /^(\s{0,3})([=-]|[-~]{3})/, "$1\\$2" # prevent setext heading and thematic break
#      .replace /([[])/g, "\\$1" # prevent automatic link

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
