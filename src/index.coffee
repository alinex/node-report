# Report generation
# =================================================
# This package will give you an easy and robust way to access mysql databases.

# Node Modules
# -------------------------------------------------

debug = require('debug')('report')
chalk = require 'chalk'
# include more alinex modules
{string} = require 'alinex-util'

# Helper methods
# -------------------------------------------------

block = (text, start, indent, width) ->
  indent = '\n' + indent
  text = '\n' + start + text.replace(/\n/g, indent) + '\n'
  string.wordwrap text, width, indent

# ### Convert object to markdown table
table = (obj, col, sort) ->
  return '' unless Object.keys(obj).length
  # transform object
  if typeof obj is 'object' and not Array.isArray obj
    n = []
    n.push [name, val] for name, val of obj
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
        string["#{pad}pad"] row[e], col[e].width
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
  @link: (text, url) ->
  @img: (text, source) ->
  @footnote: (text) ->

  # ### paragraphs
  @p: (text, width) -> "\n#{string.wordwrap text, width ? @width}\n"
  @hr: -> "\n---\n"
  @quote: (text, depth = 1, width) ->
    indent = string.repeat '> ', depth
    block text, indent, indent, width ? @width
  @code: (text, lang) ->
    if lang
      return "\n``` #{lang}\n#{text.trim()}\n```\n"
    indent = '    '
    block text, indent, indent, width ? @width

  # ### lists
  # maybe use '\\\n' at the end of line for breaks
  @ul: (list, width) ->
    '\n' + list.map (text) ->
      block(text, '- ', '  ', width ? @width).trim()
    .join('\n') + '\n'
  @ol: (list, width) ->
    length = list.length.toString().length + 2
    indent = string.repeat ' ', length
    num = 0
    '\n' + list.map (text) ->
      start = string.rpad "#{++num}.", length
      block(text, start, indent, width ? @width).trim()
    .join('\n') + '\n'
  @dl: (obj, width) ->

  # ### specials
  @table: table
  @abbrv: (obj, width) ->



  # Create instance
  # -------------------------------------------------
  constructor: (setup) ->
    @width = setup?.width ? 80
    @log = setup?.log
    # content elements
    @body = ''
    @abbrv = ''
    @foot = ''

  # Add elements
  # -------------------------------------------------

  # ### direct markdown addition
  raw: (text) ->
    @log text if @log
    @body += text
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

  # ### lists
  ul: (list) -> @raw Report.ul list, @width
  ol: (list) -> @raw Report.ol list, @width
  dl: (obj) -> @raw Report.dl obj, @width

  table: (obj, col, sort) -> @raw Report.table obj, col, sort


  # Extract report
  # -------------------------------------------------

  # ### as markdown text
  toString: -> @body.replace(/\s+/, '') + @abbrv + @foot

  # ### as html
  toHtml: ->


# Export class
# -------------------------------------------------
module.exports = Report
