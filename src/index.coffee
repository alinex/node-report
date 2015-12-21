# Report generation
# =================================================
# This package will give you an easy and robust way to access mysql databases.

# Node Modules
# -------------------------------------------------

debug = require('debug')('report')
chalk = require 'chalk'
fs = require 'fs'
path = require 'path'
# include more alinex modules
{string} = require 'alinex-util'
async = require 'alinex-async'


HTML_STYLES =
  default: "#{__dirname}/../var/src/style/default.css"

# Helper methods
# -------------------------------------------------

block = (text, start, indent, width, pre = false) ->
  indent = '\n' + indent
  text = text.trim().replace /([^\\\s])[ \r\t]*\n[ \r\t]*(\S)/g, '$1 $2' unless pre
  text = '\n' + start + text.replace(/\n/g, indent) + '\n'
  string.wordwrap text, width, indent, 2

# ### Convert object to markdown table
table = (obj, col, sort) ->
  return '' unless Object.keys(obj).length
  # transform object
  if typeof obj is 'object' and not Array.isArray obj
    n = []
    for name, val of obj
      if typeof val is 'object'
        if Array.isArray(val) and val.length < 10
          n.push [name, val.join ', ']
        else
          for k, v of val
            n.push ["#{name}.#{k}", v]
      else
        n.push [name, val]
    obj = n
  # transform column definition
  if col
    if Array.isArray col
      unless Array.isArray col[0]
        col = [
          Object.keys obj[0]
          col
        ]
      n = {}
      for name, num in col[0]
        break unless val = col[1][num]
        n[name] = {title: val}
      col = n
    else if typeof col[Object.keys(col)[0]] isnt 'object'
      n = {}
      n[name] = {title: title} for name, title of col
      col = n
  else
    col = {}
    col[name] = {title: name} for name of obj[0]
  # transform sort order
  if typeof sort is 'string'
    n = {}
    n[sort] = 'asc'
    sort = n
  else if Array.isArray sort
    n = {}
    n[key] = 'asc' for key in sort
    sort = n
  # transform values
  obj = obj.map (row) ->
    n = {}
    n[name] = val.toString() for name, val of row
    n
  # calculate column width
  for key of col
    col[key].width = col[key].title.toString().length
    for row in obj
      continue unless row[key]?
      col[key].width = row[key].length if row[key].length > col[key].width
      col[key].align ?= 'left'
  # sort rows
  if sort
    obj = obj.slice()
    obj.sort (a, b) ->
      for name, order of sort
        res = a[name].localeCompare b[name]
        res = res * -1 if order is 'desc'
        return res if res
      0
  # write header
  text = '\n| ' + (
    Object.keys(col).map (e) ->
      pad = switch col[e].align[0]
        when 'r' then 'l'
        when 'l' then 'r'
        else 'c'
      string["#{pad}pad"] col[e].title, col[e].width
    .join ' | '
  ) + ' |'
  # write line
  text += '\n|' + (
    Object.keys(col).map (e) ->
      switch col[e].align
        when 'right'
          " #{string.repeat '-', col[e].width}:"
        when 'left'
          ":#{string.repeat '-', col[e].width} "
        when 'center'
          ":#{string.repeat '-', col[e].width}:"
    .join '|'
  ) + '|'
  # write rows
  for row in obj
    text += '\n| ' + (
      Object.keys(col).map (e) ->
        pad = switch col[e].align[0]
          when 'r' then 'l'
          when 'l' then 'r'
          else 'c'
        val = row[e]
        if typeof val isnt 'string'
          val = util.inspect(val).replace /\s+/g, ' '
        string["#{pad}pad"] val, col[e].width
      .join ' | '
    ) + ' |'
  text + '\n'


# Report class
# -------------------------------------------------

class Report

  @width: 80

  # Static Methods
  # -------------------------------------------------

  # ### headings
  @h1: (text, width) ->
    """\n\n#{text}
    #{string.repeat '=', width ? @width}\n"""
  @h2: (text, width) ->
    """\n\n#{text}
    #{string.repeat '-', width ? @width}\n"""
  @h3: (text, width) -> "\n### #{text}\n"
  @h4: (text, width) -> "\n#### #{text}\n"
  @h5: (text, width) -> "\n##### #{text}\n"
  @h6: (text, width) -> "\n###### #{text}\n"

  # ### inline
  @b: (text) -> "__#{text}__"
  @i: (text) -> "_#{text}_"
  @del: (text) -> "~~#{text}~~"
  @tt: (text) -> "`#{text}`"
  @sub: (text) -> "~#{text}~"
  @sup: (text) -> "^#{text}^"
  @mark: (text) -> "==#{text}=="
  @br: -> '\\\n'
  @a: (text, url, title) ->
    "[#{text}](#{url}#{if title then ' "'+title+'"' else ''})"
  @img: (text, url, title) ->
    "![#{text}](#{url}#{if title then ' "'+title+'"' else ''})"

  # ### Multi element
  @footnote: (id, text) ->
    ["[^#{id}]", "\n[^#{id}]: #{text}\n"]

  # ### paragraphs
  @p: (text, width) -> block text, '', '', width ? @width
  @quote: (text, depth = 1, width) ->
    indent = string.repeat '> ', depth
    block text, indent, indent, width ? @width
  @code: (text, lang, width) ->
    if lang
      return "\n``` #{lang}\n#{text.trim()}\n```\n"
    indent = '    '
    block text, indent, indent, width ? @width, true
  @box: (text, type, width) ->
    unless type in ['detail', 'info', 'warning', 'alert']
      throw new Error "Unknown box type #{type} for report"
    return @p text unless type
    return "\n::: #{type}\n#{text.trim()}\n:::\n"
    indent = ''
    block text, indent, indent, width ? @width
  @hr: -> "\n---\n"

  # ### lists
  # maybe use '\\\n' at the end of line for breaks
  @ul: (list, sort, width) ->
    if sort?
      list = list[0..]
      list.sort()
      list.reverse() unless sort
    '\n' + list.map (text) =>
      if Array.isArray text
        text = @ul text, width
        return '  ' + text.trim().replace '\n', '\n  '
      block(text, '- ', '  ', width ? @width).trim()
    .join('\n') + '\n'
  @ol: (list, sort, width) ->
    if sort?
      list = list[0..]
      list.sort()
      list.reverse() unless sort
    length = list.length.toString().length + 2
    indent = string.repeat ' ', length
    num = 0
    '\n' + list.map (text) =>
      if Array.isArray text
        text = @ol text, width
        return indent + text.trim().replace '\n', '\n' + indent
      start = string.rpad "#{++num}.", length
      block(text, start, indent, width ? @width).trim()
    .join('\n') + '\n'
  @dl: (obj, sort, width) ->
    list = Object.keys obj
    if sort?
      list = list[0..]
      list.sort()
      list.reverse() unless sort
    text = ''
    for name in list
      content = obj[name].trim().split(/\n\n/).map (e) ->
        ": #{string.wordwrap e, width ? @width, '\n'}"
      .join '\n\n'
      text += "\n#{name}\n\n#{content}\n"
    text
  @check: (map) ->
    text = ''
    for name, val of map
      text += "\n[#{if val then 'x' else ' '}] #{name}"
    text + '\n'

  # ### specials
  @table: table
  @abbr: (abbr, text) -> "\n*[#{abbr}]: #{text.trim()}"
  @toc: -> '\n@[toc]\n'


  # Create instance
  # -------------------------------------------------
  constructor: (setup) ->
    @width = setup?.width ? 80
    @log = setup?.log
    # content elements
    @body = setup?.source ? ''
    @parts =
      abbr: []
      footnote: []
    @state =
      footnote: 0

  # Add elements
  # -------------------------------------------------

  # ### direct markdown addition
  raw: (text) ->
    @log text if @log
    @body += text
    this

  # ### add contents of other report instance
  add: (report) ->
    @log report.body if @log
    @body += report.body
    for key of @parts
      @parts[key] = @parts[key].concat report.parts[key]
    this

  # ### headings
  h1: (text) -> @raw Report.h1 text, @width
  h2: (text) -> @raw Report.h2 text, @width
  h3: (text) -> @raw Report.h3 text, @width
  h4: (text) -> @raw Report.h4 text, @width
  h5: (text) -> @raw Report.h5 text, @width
  h6: (text) -> @raw Report.h6 text, @width

  # ### paragraphs
  p: (text) -> @raw Report.p text, @width
  hr: -> @raw Report.hr()
  quote: (text, depth) -> @raw Report.quote text, depth, @width
  code: (text, lang) -> @raw Report.code text, lang, @width
  box: (text, type) -> @raw Report.box text, type, @width

  # ### lists
  ul: (list, sort) -> @raw Report.ul list, sort, @width
  ol: (list, sort) -> @raw Report.ol list, sort, @width
  dl: (obj, sort) -> @raw Report.dl obj, sort, @width
  check: (map) -> @raw Report.check map

  table: (obj, col, sort) -> @raw Report.table obj, col, sort

  footnote: (text, id) ->
    id ?= ++@state.footnote
    @parts.footnote.push "[^#{id}]: #{text.trim()}"
    return "[^#{id}]"

  abbr: (abbr, text) -> @raw Report.abbr abbr, text
  toc: -> @raw Report.toc()

  # Extract report
  # -------------------------------------------------

  # ### as markdown text
  toString: ->
    text = @body.replace /\s+/, ''
    for key in ['abbr', 'footnote']
      continue unless @parts[key].length
      text += "\n#{@parts[key].join '\n'}\n"
    text

   # ### as simplified text
  toText: ->
    @toString().replace ///
    \n@\[toc\]\n
    ///g, ''

  # ### as colorful console text
  toConsole: ->
    text = @toText()
    text = text.replace /\*\*(.*?)\*\*/g, chalk.bold '$1'
    text = text.replace /__(.*?)__/g, chalk.bold '$1'

  # ### as html
  toHtml: (setup) ->
    # create html
    md = @initHtml()
    data = {}
    content = md.render @toString(), data
    content = content.replace /<p>\n(<ul class="table-of-contents">[\s\S]*?<\/ul>)\n<\/p>/g, '$1'
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
    # return complete html
    """
    <!DOCTYPE html>
    <html>
      <head>
        <title>#{title}</title>
        <meta charset="UTF-8" />
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/highlight.js/\
        8.5.0/styles/solarized_light.min.css" />
        #{css}
      </head>
      <body>#{content}</body>
    </html>
    """

  initHtml: async.once ->
    # setup markdown it
    hljs = require 'highlight.js'
    container = require 'markdown-it-container'
    md = require('markdown-it')
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
    .use(require 'markdown-it-title') #extracting title from source (first heading)
    .use(require 'markdown-it-sub') # subscript support
    .use(require 'markdown-it-sup') # superscript support
    .use(container, 'detail') # special boxes
    .use(container, 'info') # special boxes
    .use(container, 'warning') # special boxes
    .use(container, 'alert') # special boxes
    .use(require 'markdown-it-mark') # add text as "marked"
    .use(require 'markdown-it-emoji') # add graphical emojis
    .use(require 'markdown-it-deflist') # definition lists
    .use(require 'markdown-it-abbr') # abbreviations (auto added)
    .use(require 'markdown-it-footnote') # footnotes (auto linked)
    .use(require('markdown-it-checkbox'), {divWrap: true, divClass: 'cb'})
    .use require('markdown-it-toc-and-anchor'), # possibility to add TOC
      tocClassName: 'table-of-contents'
      tocFirstLevel: 2
      anchorLink: false
#    .use(require 'markdown-it-anchor') # adding heading anchors
#    .use(require 'markdown-it-table-of-contents') # possibility to add TOC
    twemoji = require('twemoji')
    # set base to allow also access from local page display
    twemoji.base = 'https://twemoji.maxcdn.com/'
    md.renderer.rules.emoji = (token, idx) ->
      twemoji.parse token[idx].content
    md

# Export class
# -------------------------------------------------
module.exports = Report
