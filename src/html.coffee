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
memoize = require 'memoizee'
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
mdAttrs = require 'markdown-it-attrs' # alternative attributes
mdToc = require 'markdown-it-toc-and-anchor'
twemoji = require 'twemoji'
# load own plugins
pluginExecute = require './plugin/execute'
pluginFontawesome = require './plugin/fontawesome'


# Configuration
# -------------------------------------------------
langAlias =
  coffee: 'coffeescript'
  js: 'javascript'
  jsx: 'javascript'
  rb: 'ruby'
  py: 'python'
  pl: 'perl'
  c: 'cc'
  h: 'cc'
  'c++': 'cpp'
  'h++': 'cpp'
  'hpp': 'cpp'
  csharp: 'cs'
  gemspec: 'ruby'
  podspec: 'ruby'
  thor: 'ruby'
  irb: 'ruby'
  sh: 'bash'
  zsh: 'bash'
  yml: 'yaml'
  md: 'markdown'
  styl: 'stylus'

trans =
  content:
    en: 'Content'
    de: 'Inhalt'
  index:
    en: 'Index'
  lang:
    coffeescript:
      en: 'CoffeeScript Code'
    iced:
      en: 'IcedCoffeeScript Code'
    javascript:
      en: 'JavaScript Code'
    ruby:
      en: 'Ruby Code'
    python:
      en: 'Python Code'
    perl:
      en: 'Perl Script'
    cpp:
      en: 'C++ Code'
    cc:
      en: 'C Code'
    cs:
      en: 'C# Code'
    java:
      en: 'Java Code'
    jsp:
      en: 'Java Server Pages'
    groovy:
      en: 'Groovy Code'
    php:
      en: 'PHP Code'
    bash:
      en: 'Shell Script'
    makefile:
      en: 'Makefile'
    sql:
      en: 'SQL Code'
    handlebars:
      en: 'Handlebars Template'
    jade:
      en: 'Jade Template'
    css:
      en: 'Cascading Stylesheet'
    stylus:
      en: 'Stylus Stylesheets'
    scss:
      en: 'Sassy CSS'
    less:
      en: 'Less Stylesheets'
    cson:
      en: 'CSON Data'
    json:
      en: 'JSON Data'
    yaml:
      en: 'YAML Data'
    markdown:
      en: 'Markdown Document'
  boxes:
    detail:
      en: 'Details'
    info:
      en: 'Info'
    warning:
      en: 'Warning'
      de: 'Warnung'
    alert:
      en: 'Attention'
      de: 'Achtung'
  tabs:
    max:
      en: 'Maximize box to show full content'
    scroll:
      en: 'Open in default view with possible scroll bars'
    min:
      en: 'Close box content'
    switch:
      en: 'Switch tab'


lastTabID = 0
lastTabGroup = 0
tabActions =
  max: '<i class="fa fa-window-maximize" aria-hidden="true"></i>'
  scroll: '<i class="fa fa-window-restore" aria-hidden="true"></i>'
  min: '<i class="fa fa-window-minimize" aria-hidden="true"></i>'


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
    # replace newlines before html tags
    content = content.replace /\n<!--/g, '<!--'
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
        font-awesome/4.7.0/css/font-awesome.min.css" />"""
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
    html = hbs util.extend util.clone(setup.context ? {}),
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
  debug "use style #{style} for html conversion" if debug.enabled
  config.typeSearch 'template', (err, map) ->
    file = map["report/#{style}.css"]
    css = if file
      debug chalk.grey "using css from #{file}" if debug.enabled
#      if match = file.match /\/(node-[-a-z]+)\/var\/src\/template\/report/
#        if fs.existsSync "#{__dirname}/../src"
#          """<style type="text/css">#{fs.readFileSync file, 'utf8'}</style>"""
#        else
#          """<link rel="stylesheet" type="text/css" href="\
#          https://cdn.rawgit.com/alinex/#{match[1]}/\
#          master/var/src/template/report/#{style}.css" />"""
#      else
      """<style type="text/css">#{fs.readFileSync file, 'utf8'}</style>"""
    else
      if style.match /^https?:\/\//
        """<link rel="stylesheet" type="text/css" href="#{style}" />"""
      else
        """<style type="text/css">#{fs.readFileSync style, 'utf8'}</style>"""
    # load hbs
    file = map["report/#{style}.hbs"]
    debug chalk.grey "using html template from #{file}" if debug.enabled
    readCached = memoize (file) -> fs.readFileSync file, 'utf8'
    hbs = readCached file
    # includes
    while hbs.match /\{\{include\s+(.*?)\s*\}\}/
      hbs = hbs.replace /\{\{include\s+(.*?)\s*\}\}/g, (_, link) ->
        file = map["report/#{link}.hbs"]
        debug chalk.grey "including #{file}" if debug.enabled
        try
          readCached file
        catch error
          console.error "Warning: #{error.message}"
          link
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
  .use mdContainer, 'detail',
    render: containerRender
  .use mdContainer, 'info',
    render: containerRender
  .use mdContainer, 'warning',
    render: containerRender
  .use mdContainer, 'alert',
    render: containerRender
  .use mdMark # add text as "marked"
  .use mdEmoji # add graphical emojis
  .use pluginFontawesome
  .use mdDeflist # definition lists
  .use mdAbbr # abbreviations (auto added)
  .use mdFootnote # footnotes (auto linked)
  .use mdCheckbox, {divWrap: true, divClass: 'cb'}
  .use mdDecorate # add css classes
  .use mdAttrs # additional attributes
  .use mdToc.default, # possibility to add TOC
    tocClassName: 'table-of-contents'
    tocFirstLevel: 2
    anchorLink: false
  # set base to allow also access from local page display
  twemoji.base = 'https://twemoji.maxcdn.com/'
  md2html.renderer.rules.emoji = (token, idx) ->
    twemoji.parse token[idx].content
  md2html

containerAlias =
  error: 'alert'
containerRender = (tokens, idx) ->
  return if tokens[idx].nesting is 1 # opening tag
    m = tokens[idx].info.trim().match /^(\S*?)(?:\s+(.*))?$/
    type = m[1].toLowerCase()
    attrs =
      class: if containerAlias[type] then containerAlias[type] else type
    for e in tokens[idx].attrs ? []
      if attrs[e[0]]?
        attrs[e[0]] += " #{e[1]}"
      else
        attrs[e[0]] = e[1]
    attrs = Object.keys(attrs).map (k) ->
      " #{k}=\"#{attrs[k]}\""
    .join ''
    h = "<tab#{attrs}>"
    h += "<header>#{m[2]}</header>" if m[2]?.length
    "#{h}\n"
  else # closing tag
    '</tab>\n'

text = (tag, locale, tr = trans) ->
  parts = tag.split /\./
  return text parts[1..].join('.'), locale, tr[parts[0]] unless parts.length is 1
  tr[tag][locale] ? tr[tag][locale[0..1]] ? tr[tag].en

optimizeHtml = (html, locale = 'en') ->
  re = [
    [ # table-of-contents: add box header
      /<p>\n(<ul class="table-of-contents">)([\s\S]*?<\/ul>)\n<\/p>/g
      "$1<header>#{text 'content', locale}</header>$2"
    ]
  ,
    [ # table-of-contents: add index title
      /(<ul class="table-of-contents")>/g
      "$1 aria-hidden=\"true\"><header>#{text 'index', locale}</header>"
    ]
  ,
    [ # move style settings from code to parent pre
      /<pre><code( style="[^"]*")/g
      '<pre$1><code'
    ]
  ,
    [ # break code tags into lines
      /(<pre.*?)><code (class="language .*?")>([\s\S]*?)<\/code><\/pre>/g
      (_, pre, css, content) ->
        content = content.replace /^\s*\n|\n\s*$/, ''
        .replace /(<span.*?>)([\s\S]*?)<\/span>/g, (_, span, text) ->
          span + text.replace(/\n/g, "</span>\n#{span}") + '</span>'
        .replace /\n/g, '</code>\n<code>'
        "#{pre} #{css}><code>#{content}</code></pre>"
    ]
  ,
    [ # code: fix decorator problem for code elements
      /<pre ((?:(?!<pre)[\s\S])+<\/pre>)\n<!-- {code: (.*?)} -->/g
      "<pre $2 $1"
    ]
  ,
    [ # box: wrap tab in tabs collection
      /(<tab[\s\S]+?<\/tab>)/g
      "<tabs>$1</tabs>"
    ]
  ,
    [ # box: merge multiple tabs together
      /<\/tabs>\s*<tabs>/g
      ""
    ]
  ,
    [ # box: convert boxes to tabs
      /<tabs>([\s\S]*?)<\/tabs>/g
      (_, html) ->
        # parse tabs
        tabRE = /<tab ([^>]+)>(?:<header>(.*?)<\/header>)?([\s\S]+?)<\/tab>/g
        attrsRE = /\s*(\w+)=\"([^\"]*?)\"/g
        tabs = []
        tabs.push match while match = tabRE.exec html
        size = 'scroll'
        # parse attributes
        tabs = tabs.map (e) ->
          map = {}
          while match = attrsRE.exec e[1]
            map[match[1]] = match[2]
            size = match[2] if match[1] is 'size'
          e[1] = map
          e
        # create html
        tabGroup = ++lastTabGroup
        html = "<div class=\"tabs\">\n"
        # add tab switches
        tabNum = 0
        for e, n in tabs
          type = e[1].class.replace /[ ].*/, ''
          e[2] ?= text type, locale, trans.boxes
          tabID = ++lastTabID
          checked = if tabNum then '' else ' checked=\"\"'
          html += "<input type=\"radio\" name=\"tabs#{tabGroup}\"
          class=\"tab tab#{++tabNum}\" id=\"tab#{tabID}\"#{checked}>\
          <label for=\"tab#{tabID}\" class=\"#{e[1].class ? ''}\"
          title=\"#{text 'switch', locale, trans.tabs}\">#{e[2]}</label>\n"
        # add size links
        checked = {}
        for k, n of tabActions
          checked = if size is k then ' checked=""' else ''
          html += "<input type=\"radio\" name=\"tabs-size#{tabGroup}\"
          class=\"tabs-size tabs-size-#{k}\" id=\"tabs-size-#{k}#{tabGroup}\"#{checked}>\
          <label for=\"tabs-size-#{k}#{tabGroup}\"
          title=\"#{text k, locale, trans.tabs}\">#{n}</label>\n"
        # add html content
        tabNum = 0
        for e, n in tabs
          html += "<div class=\"tab-content tab-content#{++tabNum}\">#{e[3]}</div>\n"
        # return complete
        html + "</div>"
    ]
  ]
  # code
  for tag of trans.lang
    re.push [
      new RegExp '(<pre [^>]*?class="language ' + tag + '">)', 'g'
      "$1<header>#{text tag, locale, trans.lang}</header>"
    ]
  for tag, alias of langAlias
    re.push [
      new RegExp '(<pre [^>]*?)class="language ' + tag.replace(/([+])/, '\\\\%1') + '">', 'g'
      "$1class=\"language #{alias}\"><header>#{text alias, locale, trans.lang}</header>"
    ]
  # replacement
  for [s, r] in re
    html = html.replace s, r
  # return result
  html
