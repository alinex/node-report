###
Table
=================================================
###


# Node Modules
# -------------------------------------------------
Report = require '../index'


# Helper
# -------------------------------------------------

# Correct and check position of marker in TokenList.
#
# @throw {Error} if current position is impossible
position = ->
  for autoclose in ['paragraph', 'heading', 'preformatted', 'code']
    @tokens.setAfterClosing autoclose if @tokens.in autoclose

###
Builder API
----------------------------------------------------
###

###
Add a text table.

@param {String|Boolean} input with content of table or true to open tag and
false to close tag if content is added manually.#
@param {Boolean} hidden set to `true to set hidden flag used for tight lists`
@return {Report} instance itself for command concatenation
###
Report.prototype.table = (input, hidden) ->
  if typeof input is 'boolean'
    if input
      position.call this
      # open new tag
      @tokens.insert [
        type: 'table'
        nesting: 1
      ,
        type: 'table'
        nesting: -1
      ], null, 1
    else
      @tokens.setAfterClosing 'table'
  else
    position.call this
    # complete with content
    @tokens.insert
      type: 'table'
      nesting: 1
      hidden: hidden
    @text input
    @tokens.insert
      type: 'table'
      nesting: -1
      hidden: hidden
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
