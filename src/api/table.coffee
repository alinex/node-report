###
Table
=================================================
###


# Node Modules
# -------------------------------------------------
Report = require '../index'
Table = require 'alinex-table'
util = require 'alinex-util'


# Helper
# -------------------------------------------------

# Correct and check position of marker in TokenList.
#
# @throw {Error} if current position is impossible
position = ->
  for autoclose in ['paragraph', 'heading', 'preformatted', 'code']
    @tokens.setAfterClosing autoclose if @tokens.in autoclose

# Check position of marker in TokenList.
#
# @throw {Error} if current position is impossible
positionRow = ->
  unless @tokens.in 'table'
    throw new Error "A table row have to be inserted in the table."

###
Builder API
----------------------------------------------------
###

###
Convert object to markdown table.

@param {Array<Array>|Object|boolean} obj table data as {@link alinex-table} object or array
@param {Array} [col] the column title names
@param {String|Array} [sort] set specific sort for the table data
@param {Boolean} [markdown] set to `true` if inline markdown should be parsed
@return {Report} instance itself for command concatenation
###
Report.prototype.table = (data, col, sort, markdown) ->
  if typeof data is 'boolean'
    if data
      unless col
        throw new Error "Could not create table step by step without column definition"
      @table [], col
      @tokens.set @tokens.pos - 2
    else
      @tokens.setAfterClosing 'table'
  # table instance
  if data instanceof Table
    table = data
    markdown = col
    data = table.data[1..]
    col = []
    for name, i in table.data[0]
      res = table.getMeta null, i
      res.title ?= name
      col.push res
  return '' unless Object.keys(data).length
  data = util.clone data
  this
  # transform object
  if typeof data is 'object' and not Array.isArray data
    n = [(col ? ['Name', 'Value'])]
    col = null
    for name, val of data
      if typeof val is 'object'
        if Array.isArray(val) and val.length < 10
          n.push [name, val.join ', ']
        else
          for k, v of val
            n.push ["#{name}.#{k}", v]
      else
        n.push [name, val]
    data = n.map (r) ->
      r.map (c) ->
        if typeof c is 'string' then c.replace /\s*\n\s*/g, ' ' else c
  # transform column definition
  if col
    if Array.isArray(col)
      unless Array.isArray col[0]
        col = [
          Object.keys data[0]
          col
        ]
      n = {}
      for name, num in col[0]
        break unless val = col[1][num]
        n[name] = if typeof val is 'object' then val else {title: val}
      col = n
    else if typeof col[Object.keys(col)[0]] isnt 'object'
      n = {}
      n[name] = {title: title} for name, title of col
      col = n
  else
    if Array.isArray data[0]
      col = data.shift()
    else
      col = {}
      col[name] = {title: name} for name of data[0]
  # transform col array to object
  if Array.isArray col
    c = {}
    for field, i in col
      c[i] = if typeof field is 'object' then field else {title: field}
    col = c
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
  data = data.map (row) ->
    if Array.isArray row
      row.map (col) -> col?.toString() ? ''
    else
      for key of row
        row[key] = row[key]?.toString() ? ''
      row
#  # mask values if needed
#  if mask
#    data = data.map (row) ->
#      if Array.isArray row
#        row.map (col) -> Report.mask col
#      else
#        for key of row
#          row[key] = Report.mask row[key]
#        row
#  # calculate column width
#  for key of col
#    col[key].width = col[key].title?.toString().length ? 0
#    for row in data
#      continue unless row[key]?
#      col[key].width = row[key].length if row[key].length > col[key].width
#      col[key].align ?= 'left'
  # sort rows
  if sort
    data = data.slice()
    data.sort (a, b) ->
      for name, order of sort
        res = a[name].localeCompare b[name]
        res = res * -1 if order is 'desc'
        return res if res
  # add table tokens
  position.call this
  @tokens.insert [
    type: 'table'
    nesting: 1
  ,
    type: 'thead'
    nesting: 1
  ]
  @row col, markdown, true
  @tokens.insert [
    type: 'thead'
    nesting: -1
  ,
    type: 'tbody'
    nesting: 1
  ]
  # add all rows
  for row in data
    rdata = Object.keys(col).map (e) -> row[e]
    @row rdata, markdown
  @tokens.insert [
    type: 'tbody'
    nesting: -1
  ,
    type: 'table'
    nesting: -1
  ]
  this

###
Convert object to markdown table.

@param {Array<Array>|Object|boolean} obj table data as {@link alinex-table} object or array
@param {Array} [col] the column title names
@param {String|Array} [sort] set specific sort for the table data
@param {Boolean} [mask] set to `true` if the values should be masked to not
interpret them as markdown
@return {Report} instance itself for command concatenation
###
Report.prototype.row = (row, markdown, header) ->
  positionRow.call this
  # open row
  @tokens.insert
    type: 'tr'
    nesting: 1
  # add cells
  if header
    for _, cell of row
      @tokens.insert [
        type: 'th'
        nesting: 1
        align: cell.align ? 'left'
      ,
        type: 'text'
        content: cell.title
      ,
        type: 'th'
        nesting: -1
      ]
  else
    for cell in row
      text = [
        type: 'text'
        content: cell.toString()
      ]
      if markdown
        inline = new Report()
        inline.markdown cell.toString()
        text = inline.tokens.data[2..-3] # strip document and paragraph
      @tokens.insert [
        type: 'td'
        nesting: 1
      ].concat text, [
        type: 'td'
        nesting: -1
      ]
  # close row
  @tokens.insert
    type: 'tr'
    nesting: -1
  this



###
Markdown Input/Output
----------------------------------------------------
[Tables](https://help.github.com/articles/organizing-information-with-tables/)



Other Output
----------------------------------------------------


Examples
----------------------------------------------------
Examples will come soon...
###
