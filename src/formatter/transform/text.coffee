# Text Phrases
# =================================================

util = require 'alinex-util'
config = require 'alinex-config'
# typograph modules
Textr = require 'textr'
apostrophes = require 'typographic-apostrophes'
apostrophesForPlurals = require 'typographic-apostrophes-for-possessive-plurals'
arrows = require 'typographic-arrows'
copyright = require 'typographic-copyright'
currency = require 'typographic-currency'
ellipses = require 'typographic-ellipses'
emDashes = require 'typographic-em-dashes'
enDashes = require 'typographic-en-dashes'
mathSymbols = require 'typographic-math-symbols'
quotes = require 'typographic-quotes'
registeredTrademark = require 'typographic-registered-trademark'
singleSpaces = require 'typographic-single-spaces'
trademark = require 'typographic-trademark'


TYPO_LANG =
  en: 'en-us'


typo = (text, tokens) ->
  conf = config.get '/report/typograph'
  textr = Textr()
  textr.use apostrophes if conf.apostrophes
  textr.use quotes if conf.quotes
  textr.use apostrophesForPlurals if conf.apostrophesForPlurals
  textr.use arrows if conf.arrows
  textr.use copyright if conf.copyright
  textr.use currency.default if conf.currency
  textr.use ellipses if conf.ellipses
  textr.use emDashes if conf.emDashes
  textr.use enDashes if conf.enDashes
  textr.use mathSymbols if conf.mathSymbols
  textr.use registeredTrademark if conf.registeredTrademark
  textr.use singleSpaces if conf.singleSpaces
  textr.use trademark if conf.trademark
  lang = tokens.get(0).html?.lang ? 'en'
  textr text,
    locale:
      TYPO_LANG[lang] ? lang


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
      .replace /\\(?=[^\n]|$)/g, '\\\\'
      # mask special markdown (but as few as possible to make it more readable)
      .replace /\ /g, '&nbsp;' # non breaking space
      .replace /^(#{1,6}\ )/g, "\\$1" # prevent atx heading
      .replace /([_*~=`^])(?=\w|[*_~=`^]|$)/g, "\\$1" # prevent inline formatting
      .replace /^(\s{0,3}\d+)([.)] )/, "$1\\$2" # prevent ordered lists
      .replace /^(\s{0,3})([-*] )/, "$1\\$2" # prevent bullet list
      .replace /^(\s{0,3})>/, "$1\\>" # prevent blockquote
      .replace /<([^>]*)>/g, "\\<$1>" # prevent html
      .replace /^(\s{0,3})([=-]|[-~]{3})/, "$1\\$2" # prevent setext heading and thematic break
      .replace /([\[\]])/g, "\\$1" # prevent automatic link

  html:
    format: 'html'
    type: 'text'
    fn: (num, token) ->
      token.out = token.content
      return if token.parent.type is 'code'
      unless token.parent.type is 'preformatted'
        token.out = typo token.out, @tokens
      token.out = util.string.htmlEncode token.out
      return if token.parent.type is 'preformatted'
      token.out = token.out
      .replace /\n/g, '<br />\n'
      .replace /\u00a0/g, '&nbsp;'

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
      token.out = typo token.content, @tokens
