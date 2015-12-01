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

  @code: (text, lang) ->
    if lang
      return "\n``` #{lang}\n#{text.trim()}\n```\n"
    indent = '\n    '
    indent + text.replace('\n', indent) + '\n'

  @table: (col, obj) ->
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
