###
Definition
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
Convert object to markdown definition list.

@param {Object|boolean} data as map of definitions
@return {Report} instance itself for command concatenation
###
Report.prototype.definition = (input) ->
  if typeof input is 'boolean'
    if input
      position.call this
      # open new tag
      @tokens.insert [
        type: 'dl'
        nesting: 1
      ,
        type: 'dl'
        nesting: -1
      ], null, 1
    else
      @tokens.setAfterClosing 'dl'
  else
    position.call this
    # complete with content
    @tokens.insert
      type: 'dl'
      nesting: 1
    for k, v of input
      @dt k
      @dd v
    @tokens.insert
      type: 'dl'
      nesting: -1
  this

###
Convert object to markdown definition list.

@param {Object|boolean} data as map of definitions
@return {Report} instance itself for command concatenation
###
Report.prototype.dl = (input) -> @definition input

###
Convert object to markdown definition title.

@param {Object|boolean} data as map of definitions
@return {Report} instance itself for command concatenation
###
Report.prototype.dt = (input) ->
  if typeof input is 'boolean'
    if input
      position.call this
      # open new tag
      @tokens.insert [
        type: 'dt'
        nesting: 1
      ,
        type: 'dt'
        nesting: -1
      ], null, 1
    else
      @tokens.setAfterClosing 'dt'
  else
    position.call this
    # complete with content
    @tokens.insert [
      type: 'dt'
      nesting: 1
    ,
      type: 'text'
      content: input
    ,
      type: 'dt'
      nesting: -1
    ]
  this

###
Convert object to markdown definition entry.

@param {Object|boolean} data as map of definitions
@return {Report} instance itself for command concatenation
###
Report.prototype.dd = (input) ->
  if typeof input is 'boolean'
    if input
      position.call this
      # open new tag
      @tokens.insert [
        type: 'dd'
        nesting: 1
      ,
        type: 'dd'
        nesting: -1
      ], null, 1
    else
      @tokens.setAfterClosing 'dd'
  else
    position.call this
    # complete with content
    @tokens.insert
      type: 'dd'
      nesting: 1
    @p input
    @tokens.insert
      type: 'dd'
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
