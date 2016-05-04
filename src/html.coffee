# Report generation
# =================================================
# This package will give you an easy and robust way to access mysql databases.

# Node Modules
# -------------------------------------------------
fs = require 'fs'
path = require 'path'
fs = require 'alinex-fs'
mime = require 'mime'
inlineCss = require 'inline-css'
# markdown
md = require('markdown-it')
hljs = require 'highlight.js'
mdContainer = require 'markdown-it-container'
mdTitle = require 'markdown-it-title' #extracting title from source (first heading)
mdSub = require 'markdown-it-sub' # subscript support
mdSup = require 'markdown-it-sup' # superscript support
mdMark = require 'markdown-it-mark' # add text as "marked"
mdEmoji = require 'markdown-it-emoji' # add graphical emojis
mdFontawesome = require 'markdown-it-fontawesome'
mdDeflist = require 'markdown-it-deflist' # definition lists
mdAbbr = require 'markdown-it-abbr' # abbreviations (auto added)
mdFootnote = require 'markdown-it-footnote' # footnotes (auto linked)
mdCheckbox = require 'markdown-it-checkbox'
mdDecorate = require 'markdown-it-decorate' # add css classes
mdToc = require 'markdown-it-toc-and-anchor'
twemoji = require 'twemoji'


# Configuration
# -------------------------------------------------
HTML_STYLES =
  default: "#{__dirname}/../var/src/style/default.css"

trans =
  content:
    en: 'Content'
    de: 'Inhalt'
  lang:
    js:
      en: 'JavaScript Code'
    coffee:
      en: 'CoffeeScript Code'
    bash:
      en: 'Bash Code'
    sql:
      en: 'SQL Code'
  boxes:
    info:
      en: 'Info'
    warning:
      en: 'Warning'
      de: 'Warnung'
    alert:
      en: 'Attention'
      de: 'Achtung'


# Convert into HTML
# -------------------------------------------------
module.exports = (report, setup, cb) ->
  if typeof setup is 'function'
    cb = setup
    setup = null
  # create html
  md = initHtml()
  data = {}
  content = report.toString()
  # make local files inline
  # replace local images with base64
  content = content.replace ///
    (                 # before:
      !\[.*?\]        #   image alt text
      \(              #   opening url
    )file://(         # file:
      [^ ]*?          #   image source
    )(                # after:
      (?: ".*?")?     #   title text
      \)              #   closing url
    )
    ///, (_, b, f, a) ->
    f = path.resolve __dirname, '../', f
    data = new Buffer(fs.readFileSync f).toString 'base64'
    "#{b}data:#{mime.lookup f};base64,#{data}#{a}"
  # transform to html
  md.render(content, data)
  content = optimizeHtml md.render(content, data), setup?.locale
  title = setup?.title ? data.title ? 'Report'
  style = setup?.style ? 'default'
  # get css
  css = switch
    when style in Object.keys HTML_STYLES
      css = fs.readFileSync HTML_STYLES[style], 'utf8'
      "<style>#{css}</style>"
    when style.match /^https?:\/\//
      "<link rel=\"stylesheet\" href=\"#{style}\" />"
    else
      css = fs.readFileSync style, 'utf8'
      "<style>#{css}</style>"
  # complete html
  html = """
  <!DOCTYPE html>
  <html lang="#{if setup?.locale then setup.locale[0..1] else 'en'}">
    <head>
      <title>#{title}</title>
      <meta charset="UTF-8" />
      <link rel="stylesheet" href="https://cdn.jsdelivr.net/highlight.js/\
      8.5.0/styles/solarized_light.min.css" />
      <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/\
      4.5.0/css/font-awesome.min.css" />
      #{css}
    </head>
    <body>#{content}</body>
  </html>
  """
  return html unless cb
  cb null, html unless setup?.inlineCss
  # make css inline
  inlineCss html,
    url: 'index.html'
  .then (html) ->
    cb null, html


# Helper methods
# -------------------------------------------------

# ### initialize markdown to html converter
md2html = null
initHtml = -> #async.once ->
  return md2html if md2html
  # setup markdown it
  md2html = md
    html: true
    linkify: true
    typographer: true
    xhtmlOut: true
    langPrefix: 'language '
    highlight: (str, lang) ->
      if lang and hljs.getLanguage lang
        try
          return hljs.highlight(lang, str).value
      try
        return hljs.highlightAuto(str).value
      return '' # use external default escaping
  .use mdTitle #extracting title from source (first heading)
  .use mdSub # subscript support
  .use mdSup # superscript support
  .use mdContainer, 'detail' # special boxes
  .use mdContainer, 'info' # special boxes
  .use mdContainer, 'warning' # special boxes
  .use mdContainer, 'alert' # special boxes
  .use mdMark # add text as "marked"
  .use mdEmoji # add graphical emojis
  .use mdFontawesome
  .use mdDeflist # definition lists
  .use mdAbbr # abbreviations (auto added)
  .use mdFootnote # footnotes (auto linked)
  .use mdCheckbox, {divWrap: true, divClass: 'cb'}
  .use mdDecorate # add css classes
  .use mdToc.default, # possibility to add TOC
    tocClassName: 'table-of-contents'
    tocFirstLevel: 2
    anchorLink: false
  # set base to allow also access from local page display
  twemoji.base = 'https://twemoji.maxcdn.com/'
  md2html.renderer.rules.emoji = (token, idx) ->
    twemoji.parse token[idx].content
  md2html

text = (tag, locale, tr = trans) ->
  parts = tag.split /\./
  return text parts[1..].join('.'), locale, tr[parts[0]] unless parts.length is 1
  tr[tag][locale] ? tr[tag][locale[0..1]] ? tr[tag].en

optimizeHtml = (html, locale = 'en') ->
  re = [
    [
      /<p>\n(<ul class="table-of-contents">)([\s\S]*?<\/ul>)\n<\/p>/g
      "$1<header>#{text 'content', locale}</header>$2"
    ]
  ]
  # code
  for tag of trans.lang
    re.push [
      new RegExp '(<code class="language ' + tag + '">)', 'g'
      "$1<header>#{text tag, locale, trans.lang}</header>"
    ]
  # boxes
  for tag of trans.boxes
    re.push [
      new RegExp '(<div class="' + tag + '">)', 'g'
      "$1<header>#{text tag, locale, trans.boxes}</header>"
    ]
  # replacement
  for [s, r] in re
    html = html.replace s, r
  # return result
  html
