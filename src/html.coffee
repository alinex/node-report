# Report generation
# =================================================
# This package will give you an easy and robust way to access mysql databases.

# Node Modules
# -------------------------------------------------
debug = require('debug') 'report:htnl'
chalk = require 'chalk'
path = require 'path'
mime = require 'mime'
inlineCss = require 'inline-css'
CleanCSS = require 'clean-css'
handlebars = require 'handlebars'
# alinex plugins
fs = require 'alinex-fs'
util = require 'alinex-util'
config = require 'alinex-config'
require('alinex-handlebars').register handlebars
# markdown
markdownit = require 'markdown-it'
hljs = require 'highlight.js'
mdContainer = require 'markdown-it-container'
mdTitle = require 'markdown-it-title' #extracting title from source (first heading)
mdSub = require 'markdown-it-sub' # subscript support
mdSup = require 'markdown-it-sup' # superscript support
mdMark = require 'markdown-it-mark' # add text as "marked"
mdEmoji = require 'markdown-it-emoji' # add graphical emojis
mdDeflist = require 'markdown-it-deflist' # definition lists
mdAbbr = require 'markdown-it-abbr' # abbreviations (auto added)
mdFootnote = require 'markdown-it-footnote' # footnotes (auto linked)
mdCheckbox = require 'markdown-it-checkbox'
mdDecorate = require 'markdown-it-decorate' # add css classes
mdToc = require 'markdown-it-toc-and-anchor'
twemoji = require 'twemoji'
# load own plugins
pluginExecute = require './plugin/execute'
pluginFontawesome = require './plugin/fontawesome'


# Configuration
# -------------------------------------------------
trans =
  content:
    en: 'Content'
    de: 'Inhalt'
  lang:
    bash:
      en: 'Bash Script Code'
    coffee:
      en: 'CoffeeScript Code'
    js:
      en: 'JavaScript Code'
    sh:
      en: 'Shell Script Code'
    sql:
      en: 'SQL Code'
    handlebars:
      en: 'Handlebars template'
    json:
      en: 'JSON Data'
    yaml:
      en: 'YAML Data'
    markdown:
      en: 'Markdown Document'
  boxes:
    info:
      en: 'Info'
    warning:
      en: 'Warning'
      de: 'Warnung'
    alert:
      en: 'Attention'
      de: 'Achtung'

VERSION = null # will be set on init


# Convert into HTML
# -------------------------------------------------
module.exports = (report, setup = {}, cb) ->
  if typeof setup is 'function'
    cb = setup
    setup = {}
  setupStyle setup, (err, css, hbs) ->
    return cb err if err
    setup.style ?= 'default'
    # create html
    md = initHtml()
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
      bin = new Buffer(fs.readFileSync f).toString 'base64'
      "#{b}data:#{mime.lookup f};base64,#{bin}#{a}"
    # transform to html
    data = util.clone setup
    innerHtml = md.render content, data
    content = optimizeHtml innerHtml, setup?.locale
    title = setup?.title ? data.title ? 'Report'
    tags = util.clone report.parts.header
    js = data.js?.join '\n'
    # add used libraries
    tags.push css
    # code highlighting
    if content.match /\sclass="hljs-/
      tags.unshift """<link rel="stylesheet" href="https://cdn.jsdelivr.net/\
        highlight.js/8.5.0/styles/solarized_light.min.css" />"""
    # font awesome
    if content.match /\sclass="fa\s/
      tags.unshift """<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/\
        font-awesome/4.6.3/css/font-awesome.min.css" />"""
    unless setup.noJS
      addLibs tags, js
    if js?.match /mermaid\.initialize/
      tags.push """<style type="text/css">div#page {display:block}</style>"""
    # add page style with collected css
    localeCss = data.css?.join('\n') ? ''
    if localeCss
      localeCss = new CleanCSS().minify(localeCss).styles
      tags.push """<style type="text/css">#{css}</style>"""
    # complete html
    html = hbs util.expand util.clone(setup.context ? {}),
      locale: setup.locale?[0..1] ? 'en'
      title: title
      header: util.array.unique tags
      content: content
    return html unless cb
    return cb null, html unless setup?.inlineCss
    # make css inline
    inlineCss html,
      url: 'index.html'
    .then (html) ->
      cb null, html


# Frame HTML content with lib adding
# -------------------------------------------------
# Method for html+js to image conversion
module.exports.frame = (html, js, check) ->
  tags = []
  addLibs tags, "#{js}\n#{check}"
  js = unless js then '' else """<script type="text/javascript"><!--\n#{js}\n//--></script>"""
  config.typeSearch 'template', (err, map) ->
    file = map["template/report/default.css"]
    """
    <!DOCTYPE html>
    <html>
      <head>
        <meta charset="UTF-8" />
        <style type="text/css">#{fs.readFileSync file, 'utf8'}</style>
        #{tags.join '\n'}
        #{js}
      </head>
      <body><div id="page">#{html}</div></body>
    </html>
    """


# Helper methods
# -------------------------------------------------
setupStyle = (setup, cb) ->
  style = setup?.style ? 'default'
  # create output
  debug "use style #{style} for html conversion"
  config.typeSearch 'template', (err, map) ->
    file = map["report/#{style}.css"]
    css = if file
      debug chalk.grey "using css from #{file}"
      if ~file.indexOf '/var/src/template/report'
        if fs.existsSync "#{__dirname}/../src"
          """<style type="text/css">#{fs.readFileSync file, 'utf8'}</style>"""
        else
          """<link rel="stylesheet" type="text/css" href="\
          https://cdn.rawgit.com/alinex/node-report/\
          v#{VERSION}/var/src/template/report/#{style}.css" />"""
      else
        """<style type="text/css">#{fs.readFileSync file, 'utf8'}</style>"""
    else
      if style.match /^https?:\/\//
        """<link rel="stylesheet" type="text/css" href="#{style}" />"""
      else
        """<style type="text/css">#{fs.readFileSync style, 'utf8'}</style>"""
    file = map["report/#{style}.hbs"]
    debug chalk.grey "using html template from #{file}"
    hbs = fs.readFileSync file, 'utf8'
    cb null, css, handlebars.compile hbs

addLibs = (tags, js) ->
  # optimized tables
  if js?.match /\.DataTable\(/
    tags.unshift """
      <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/\
      1.10.12/css/jquery.dataTables.css" />"""
    tags.push """
      <script type="text/javascript" src="https://code.jquery.com/\
      jquery-1.12.3.js"></script>"""
    tags.push """
      <script type="text/javascript" charset="utf8" src="https://cdn.datatables.net/\
      1.10.12/js/jquery.dataTables.js"></script>"""
  # ad jui chart libs
  if js?.match /jui\./
    tags.push """
      <script type="text/javascript" src="https://code.jquery.com/\
      jquery-1.12.3.js"></script>"""
    tags.push """<script src="https://cdn.rawgit.com/juijs/jui-chart/\
      v2.0.4/lib/core.min.js"></script>"""
    tags.push """<script src="https://cdn.rawgit.com/juijs/jui-chart/\
      v2.0.4/dist/chart.min.js"></script>"""
  # add only jquery
  if js?.match /\$\(/
    tags.push """
      <script src="https://code.jquery.com/jquery-1.12.4.min.js"
      integrity="sha256-ZosEbRLbNQzLpnKIkEdrPv7lOy9C27hHQ+Xp8a4MxAQ="
      crossorigin="anonymous"></script>"""
  # mermaid
  if js?.match /mermaid\.initialize/
    tags.push """
      <script src="https://code.jquery.com/jquery-1.12.4.min.js"
      integrity="sha256-ZosEbRLbNQzLpnKIkEdrPv7lOy9C27hHQ+Xp8a4MxAQ="
      crossorigin="anonymous"></script>"""
    tags.push """
      <script type="text/javascript" src="https://cdn.rawgit.com/knsv/mermaid/\
      6.0.0/dist/mermaidAPI.min.js"></script>"""
    tags.push """
      <link rel="stylesheet" type="text/css" href="https://cdn.rawgit.com/knsv/mermaid/\
      6.0.0/dist/mermaid.forest.css" />"""
    tags.push """
      <script type="text/javascript">mermaidAPI.initialize({startOnLoad:true});</script>"""


# ### initialize markdown to html converter
md2html = null
initHtml = -> #async.once ->
  return md2html if md2html
  # get report version
  pack = JSON.parse fs.readFileSync "#{path.dirname __dirname}/package.json", 'utf8'
  VERSION = pack.version
  # setup markdown it
  md2html = markdownit
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
  .use pluginExecute # graphical visualizations
  .use mdTitle #extracting title from source (first heading)
  .use mdSub # subscript support
  .use mdSup # superscript support
  .use mdContainer, 'detail' # special boxes
  .use mdContainer, 'info' # special boxes
  .use mdContainer, 'warning' # special boxes
  .use mdContainer, 'alert' # special boxes
  .use mdMark # add text as "marked"
  .use mdEmoji # add graphical emojis
  .use pluginFontawesome
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
