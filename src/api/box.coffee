###
Box
=================================================
###


# Node Modules
# -------------------------------------------------
Report = require '../index'
util = require 'alinex-util'


# Helper
# -------------------------------------------------

# Correct and check position of marker in TokenList.
#
# @throw {Error} if current position is impossible
position = ->
  for autoclose in ['paragraph', 'heading', 'preformatted', 'code', 'box']
    @tokens.setAfterClosing autoclose if @tokens.in autoclose


###
Builder API
----------------------------------------------------
###

###
Create container for boxes.

@param {String|boolean} input open/close or content for box
@return {Report} instance itself for command concatenation    console.log '1111'

###
Report.prototype.container = (input, type, title) ->
  if typeof input is 'boolean'
    if input
      position.call this
      # open new tag
      @tokens.insert [
        type: 'container'
        nesting: 1
      ,
        type: 'container'
        nesting: -1
      ], null, 1
    else
      @tokens.setAfterClosing 'container'
  else
    position.call this
    # complete with content
    @tokens.insert
      type: 'container'
      nesting: 1
    @box input, type, title
    @tokens.insert
      type: 'container'
      nesting: -1
  this

###
Create box.

@param {String|boolean} input open/close or content for box
@return {Report} instance itself for command concatenation
###
Report.prototype.box = (input, type, title) ->
  if typeof input is 'boolean'
    if input
      position.call this
      @container true unless @tokens.token in ['container']
      # open new tag
      @tokens.insert [
        type: 'box'
        box: type ? 'detail'
        title: title ? util.string.ucFirst type ? 'detail'
        nesting: 1
      ,
        type: 'box'
        nesting: -1
      ], null, 1
    else
      @tokens.setAfterClosing 'box'
  else
    position.call this
    # complete with content
    autoOpenContainer = false
    unless @tokens.in ['container']
      autoOpenContainer = true
      @container true
    @tokens.insert
      type: 'box'
      box: type ? 'detail'
      title: title ? util.string.ucFirst type ? 'detail'
      nesting: 1
    @paragraph input
    @tokens.insert
      type: 'box'
      nesting: -1
    @container false if autoOpenContainer
  this


###
Markdown Input/Output
----------------------------------------------------



Other Output
----------------------------------------------------


Examples
----------------------------------------------------
Examples will come soon...
###
