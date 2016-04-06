# Report generation
# =================================================
# This package will give you an easy and robust way to access mysql databases.

# Node Modules
# -------------------------------------------------
chalk = require 'chalk'
util = require 'util'
# include more alinex modules
{string, object} = require 'alinex-util'


# Helper methods
# -------------------------------------------------

block = (text, start, indent, width, pre = false) ->
  indent = '\n' + indent
  text = text.trim().replace /([^\\\s])[ \r\t]*\n[ \r\t]*(\S)/g, '$1\n$2' unless pre
  text = '\n' + start + text.replace(/\n/g, indent) + '\n'
  string.wordwrap text, width, indent, 2

# ### Convert object to markdown table
table = (obj, col, sort, mask) ->
  return '' unless Object.keys(obj).length
  obj = object.clone obj
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
    obj = n.map (r) ->
      r.map (c) ->
        if typeof c is 'string' then c.replace /\s*\n\s*/g, ' ' else c
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
    if Array.isArray row
      row.map (col) -> col?.toString() ? ''
    else
      for key of row
        row[key] = row[key]?.toString() ? ''
      row
  # mask values if needed
  if mask
    obj = obj.map (row) ->
      if Array.isArray row
        row.map (col) -> Report.mask col
      else
        for key of row
          row[key] = Report.mask row[key]
        row
  # calculate column width
  for key of col
    col[key].width = col[key].title?.toString().length ? 0
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
      pad = switch col[e].align?[0]
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
        pad = switch col[e].align?[0]
          when 'r' then 'l'
          when 'l' then 'r'
          else 'c'
        val = row[e]
        if typeof val is 'undefined'
          val = ''
        else if typeof val isnt 'string'
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

  @mask: (text) ->
    text?.toString().replace /([*_~^`])/g, '\\$1'
  # ### headings
  @h1: (text, width) ->
    """\n\n#{text}
    #{string.repeat '=', width ? @width}\n"""
  @h2: (text, width) ->
    """\n\n#{text}
    #{string.repeat '-', width ? @width}\n"""
  @h3: (text) -> "\n### #{text}\n"
  @h4: (text) -> "\n#### #{text}\n"
  @h5: (text) -> "\n##### #{text}\n"
  @h6: (text) -> "\n###### #{text}\n"

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
      text = block(text, '- ', '  ', width ? @width).trim()
      text
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
  @style: (style) -> "<!-- {#{style}} -->"


  # Create instance
  # -------------------------------------------------
  constructor: (setup) ->
    @width = setup?.width ? 80
    @log = setup?.log
    # content elements
    @body = ''
    @body += setup.source if setup?.source
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

  table: (obj, col, sort, mask) -> @raw Report.table obj, col, sort, mask

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
    text = @body
    for key in ['abbr', 'footnote']
      continue unless @parts[key].length
      text += "\n#{@parts[key].join '\n'}\n"
    text

   # ### as simplified text
  toText: ->
    text = @toString()
    # remove some parts
    text = text.replace ///
    (
      (^|\n)          # start or after new line
      @\[toc\]\n      # table of contents
    |
      <!--[\s\S]*?--> # decorator rules
    |
      \\(?=\n)        # backslash at end of line
    )
    ///g, ''
    .trim()
    # demask markdown syntax and add spaces
    if text.match /\\([*_~^`])/
      demask = /\\([*_~^`])/g
      text = string.toList(text).map (line) ->
        # demask in table
        if line.match /^\|/
          line.split('\|').map (cell) ->
            if found = cell.match demask
              cell.replace(demask, "$1") + string.repeat ' ', found.length
            else
              cell
          .join '|'
        # normal demask
        else
          line.replace demask, "$1"
      .join '\n'
    # replace images with descriptions
    text = text.replace ///
    !\[(.*?)\]       # image alt text
    \(
      ([^ ]*?)        # image source
      (?: "(.*?)")?   # title text
    \)
    ///g, '[IMAGE $1]'

  # ### as colorful console text
  toConsole: ->
    text = @toString()
    # remove some parts
    text = text.replace ///
    (
      (^|\n)          # start or after new line
      @\[toc\]\n      # table of contents
    |
      <!--[\s\S]*?--> # decorator rules
    |
      \\(?=\n)        # backslash at end of line
    )
    ///g, ''
    .trim()
    # interpret markdown
    text = '\n\n' + text + '\n\n'
    # replace headings
    text = text.replace /(^|\n\n)([^\n]+)\n(====+)\n/g, (heading, start, text, line) ->
      "#{start}#{chalk.bold text}\n#{line.replace /=/g, '═'}\n"
    text = text.replace /(^|\n\n)([^\n]+)\n(----+)\n/g, (heading, start, text, line) ->
      "#{start}#{chalk.bold text}\n#{line.replace /-/g, '─'}\n"
    text = text.replace /(^|\n\n)###+ ([^\n]+)(?=\n\n)/g, (heading, start, text) ->
      "#{start}#{chalk.bold.underline text}"
    # hr
    text = text.replace /\n\n---+\n/g, =>
      "\n\n#{string.repeat '─', @width}\n"
    # typographic
    replace =
      '©': /\(c\)/gi
      '®': /\(r\)/gi
      '™': /\(tm\)/gi
      '§': /\(p\)/gi
      '±': /\+-/g
      '😋': /:yum:/g
      '😉': /;\)|:wink:/g
      '😃': /:-\)|:laughing:/g
      '😢': /:-\(|:cry:/g
      '😦': /:-O/g
      '😎': /8-\)/g
      '\n✘': /\n\[x\]/g # alternatives: ☑
      '\n□': /\n\[ \]/g
    for sign, re of replace
      text = text.replace re, sign
    # marked text
    text = text.replace /(^|[^\\])\*\*(.*?)\*\*/g, '$1' + chalk.bold '$2'
    text = text.replace /(^|[^\\])__(.*?)__/g, '$1' + chalk.bold '$2'
    text = text.replace /(^|[^\\])\*(.*?)\*/g, '$1' + chalk.italic '$2'
    text = text.replace /(^|[^\\])_(.*?)_/g, '$1' + chalk.italic '$2'
    text = text.replace /(^|[^\\])`(.*?)`/g, '$1' + chalk.dim.inverse '$2'
    text = text.replace /(^|[^\\])==([\S\s]*?)==/g, '$1' + chalk.yellow.inverse '$2'
    text = text.replace /(^|[^\\])~~([\S\s]*?)~~/g, '$1' + chalk.strikethrough '$2'
    # replace code
    text = text.replace /\n\n``` (\w+)\s*?\n([\s\S]*?)\n```\s*?\n/g, (all, lang, code) =>
      "\n\n#{chalk.yellow lang}:#{block code, '    ', '    ', @width, true}"
    # replace table with ascii art table
    text = text.replace /\n\n\|[\s\S]*?\|\n\n/g, (table) ->
      lines = table.trim().split /\n/
      head = lines[0].split /\|/
      # header
      line = '┌'
      line += string.repeat('─', col.length) + '┬' for col in head[1..head.length-2]
      ascii = chalk.grey line[0..line.length-2] + '┐'
      ascii += chalk.grey '\n│'
      ascii += chalk.bold(col) + chalk.grey('│') for col in head[1..head.length-2]
      line = '\n├'
      line += string.repeat('─', col.length) + '┼' for col in head[1..head.length-2]
      ascii += chalk.grey line[0..line.length-2] + '┤'
      # lines
      for l in lines[2..]
        cols = l.split /\|/
        ascii += chalk.grey '\n│'
        ascii += col + chalk.grey('│') for col in cols[1..cols.length-2]
      # footer
      line = '\n└'
      line += string.repeat('─', col.length) + '┴' for col in head[1..head.length-2]
      ascii += chalk.grey line[0..line.length-2] + '┘'
      "\n\n#{ascii}\n\n"
    # demask markdown syntax and add spaces
    if text.match /(^|[^\\])\\([*_~^`\\])/
      demask = /(^|[^\\])\\([*_~^`\\])/g
      text = string.toList(text).map (line) ->
        # demask in table
        if line.match /^│/
          line.split('│').map (cell) ->
            if found = cell.match demask
              cell.replace(demask, "$1$2") + string.repeat ' ', found.length
            else
              cell
          .join '│'
        # normal demask
        else
          line.replace demask, "$1$2"
      .join '\n'
    # replace images with descriptions
    text = text.replace ///
    !\[(.*?)\]       # image alt text
    \(
      ([^ ]*?)        # image source
      (?: "(.*?)")?   # title text
    \)
    ///g, '[IMAGE $1]'
    # boxes
    text = text.replace /\n\n::: (\w+)\s*?\n([\s\S]*?)\n:::\s*?/g, (all, type, text) ->
      # get max length
      maxlen = 0
      for line in text.split /\n/
        len = stripAnsi(line).length
        maxlen = len if len > maxlen
      maxlen += 2
      color = {
        detail: 'gray'
        info: 'green'
        warning: 'yellow'
        alert: 'red'
      }[type] ? 'gray'
      text = text.split(/\n/).map (e) ->
        "#{chalk[color] '║'}#{e}#{string.repeat ' ', maxlen-stripAnsi(e).length}#{chalk[color] '║'}"
      """\n\n#{chalk[color] '╔' + string.repeat('═', maxlen) + '╗'}
      #{text.join '\n'}
      #{chalk[color] '╚' + string.repeat('═', maxlen) + '╝'}"""
    text.trim()

  # ### as html
  html = null
  toHtml: (options, cb) ->
    html = require './html' unless html
    html this, options, cb

  # ### as pdf
  toPdf: (options, cb) ->
    if typeof options is 'function'
      cb = options
      options = {}
    options ?= {}
    options.format ?= 'A4'
    options.border ?=
      top: "1cm"
      right: "1cm"
      bottom: "1cm"
      left: "2cm"
    options.type ?= "pdf"           # allowed file types: png, jpeg, pdf
    pdf = require 'html-pdf'
    pdf.create(@toHtml(), options).toBuffer cb

  # ### as image (png/jpeg)
  toImage: (options, cb) ->
    if typeof options is 'function'
      cb = options
      options = {}
    options ?= {}
    options.type ?= "png"           # allowed file types: png, jpeg, pdf
    options.quality ?= 75           # only used for types png & jpeg
    pdf = require 'html-pdf'
    pdf.create(@toHtml(), options).toBuffer cb


# Export class
# -------------------------------------------------
module.exports = Report


# Helper methods
# -------------------------------------------------

# ### strip ansi color codes
stripAnsi = (text) ->
  text.replace  /[\u001b\u009b][[()#;?]*(?:[0-9]{1,4}(?:;[0-9]{0,4})*)?[0-9A-ORZcf-nqry=><]/g, ''
