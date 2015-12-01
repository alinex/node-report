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
# obj = list of row-map; col = map of settings; sort = map (key: 'asc'||'desc')
# obj = list of array;   col = array;           sort = list
# obj = map;             col = map;             sort = key
# col: title, align, width
table = (obj, col, sort), ->
  return '' unless Object.keys(obj).length
  # transform sort order
  if typeof sort is 'string'
    n = {}
    n[sort] = 'asc'
    sort = n
  else if Array.isArray sort
    n = {}
    n[key] = 'asc' for key in sort
    sort = n
  # transform column definition
  if Array.isArray col
    n = {}
    n[num] = {title: val, width: val.length} for num, val of col
    col = n
  # col = map
  # no col


  # transform object


  # sort rows


  # calculate column width


  # write header


  # write line


  # write rows


  # check columns
  unless col
    col = {}
    if Array.isArray obj
      head = obj.shift()
      col[k] = {title: k} for k in head
    else
      col[k] = {title: k} for k in Object.keys obj
  # calculate table width
  def.width = key.length for key, def in col
  if Array.isArray obj
    for row in obj
      for val in row
        def.width = val.length if val.length > def.width
  else



  result = ''
  unless Array.isArray obj
    # single object
    keys = Object.keys obj
    # get length of heading
    maxlen = []
    for n in keys
      maxlen[0] = n.length if maxlen[0] < n.length
      maxlen[1] = obj[n].length if maxlen[1] < obj[n].length
    # create table
    result = "| #{string.rpad 'Name', maxlen[0]} | #{string.lpad 'Value', maxlen[1]} |\n"
    result = "| #{string.repeat '-', maxlen[0]} | #{string.repeat '-', maxlen[1]} |\n"
    for n, v in obj
      result = "| #{string.rpad n, maxlen[0]} | #{string.lpad formatValue(v), maxlen[1]} |\n"
  else if obj.length
    # List of objects
    keys = Object.keys obj[0]
    # get length of heading
    maxlen = {}
    for n in keys
      maxlen[n] = n.length
    for e in obj
      for n in keys
        maxlen[n] = e[n].length if maxlen[n] < e[n].length
    # create table
    row = keys.map (n) ->
      string.lpad string.ucFirst(n), maxlen[n]
    result = "| #{row.join ' | '} |\n"
    row = keys.map (n) ->
      string.repeat '-', maxlen[n] - 1
    result += "| #{row.join ': | '}: |\n"
    for e in obj
      row = keys.map (n) ->
        string.lpad formatValue(e[n]), maxlen[n]
      result += "| #{row.join ' | '} |\n"
  # return result
  result

# Report class
# -------------------------------------------------

class Report

  @width: 80

  # Static Methods
  # -------------------------------------------------

  # ### headings
  @h1: (text, width) ->
    """\n\n#{string.wordwrap text, width ? @width}
    #{string.repeat '=', width ? @width}\n"""
  @h2: (text, width) ->
    """\n\n#{string.wordwrap text, width ? @width}
    #{string.repeat '-', width ? @width}\n"""
  @h3: (text, width) -> "\n### #{string.wordwrap text, (width ? @width) - 3}\n"
  @h4: (text, width) -> "\n#### #{string.wordwrap text, (width ? @width) - 4}\n"
  @h5: (text, width) -> "\n##### #{string.wordwrap text, (width ? @width) - 5}\n"
  @h6: (text, width) -> "\n###### #{string.wordwrap text, (width ? @width) - 6}\n"

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
    @body = ''
    @abbrv = ''
    @foot = ''

  # ### headings
  h1: (text) ->
    @body += Report.h1 text, @width
    this
  h2: (text) ->
    @body += Report.h2 text, @width
    this
  h3: (text) ->
    @body += Report.h3 text, @width
    this
  h4: (text) ->
    @body += Report.h4 text, @width
    this
  h5: (text) ->
    @body += Report.h5 text, @width
    this
  h6: (text) ->
    @body += Report.h6 text, @width
    this

  # ### paragraphs
  p: (text) ->
    @body += Report.p text, @width
    this
  hr: ->
    @body += Report.hr text, @width
    this
  quote: (text, depth) ->
    @body += Report.quote text, depth, @width
    this
  code: (text, lang) ->
    @body += Report.code text, lang
    this

  # ### lists
  ul: (list) ->
    @body += Report.ul list, @width
    this
  ol: (list) ->
    @body += Report.ol list, @width
    this
  dl: (obj) ->
    @body += Report.dl obj, @width
    this

  # Extract report
  # -------------------------------------------------

  # ### as markdown text
  toString: -> @body.replace(/\s+/, '') + @abbrv + @foot

  # ### as html
  toHtml: ->


# Export class
# -------------------------------------------------
module.exports = Report
