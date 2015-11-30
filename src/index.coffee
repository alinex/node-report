# Report generation
# =================================================
# This package will give you an easy and robust way to access mysql databases.

# Node Modules
# -------------------------------------------------

debug = require('debug')('report')
chalk = require 'chalk'
# include more alinex modules
{string} = require 'alinex-util'

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
  @tt: (text) -> "`#{text}`"
  @link: (text, url) ->
  @img: (text, source) ->
  @footnote: (text) ->

  # ### paragraphs
  @p: (text, width) -> "\n#{string.wordwrap text, width ? @width}\n"
  @hr: -> "\n---\n"
  @quote: (text, depth = 1, width) ->
    indent = "\n#{string.repeat '> ', depth}"
    text = indent + text.replace('\n', indent) + '\n'
    string.wordwrap text, width ? @width

  # ### lists
  @ul: (list, width) ->
    '\n' + list.map (e) ->
      "- #{string.wordwrap e, (width ? @width) - 2}\n"
    .join '\n'
  @ol: (list, width) ->
    num = 0
    '\n' + list.map (e) ->
      "#{++num}. #{string.wordwrap e, (width ? @width) - 3}\n"
    .join '\n'
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
    @md = ''
    @abbrv = ''
    @foot = ''

  # ### headings
  h1: (text) ->
    @md += Report.h1 text, @width
    this
  h2: (text) ->
    @md += Report.h2 text, @width
    this
  h3: (text) ->
    @md += Report.h3 text, @width
    this
  h4: (text) ->
    @md += Report.h4 text, @width
    this
  h5: (text) ->
    @md += Report.h5 text, @width
    this
  h6: (text) ->
    @md += Report.h6 text, @width
    this

  # ### paragraphs
  p: (text) ->
    @md += Report.p text, @width
    this
  hr: ->
    @md += Report.hr text, @width
    this
  quote: (text, depth) ->
    @md += Report.quote text, depth, @width
    this


  # Extract report
  # -------------------------------------------------

  # ### as markdown text
  toString: -> @md.replace(/\s+/, '') + @abbrv + @foot

  # ### as html
  toHtml: ->


# Export class
# -------------------------------------------------
module.exports = Report
