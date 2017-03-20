###
*Mark
=================================================
###


# Node Modules
# -------------------------------------------------
Report = require '../index'


###
Builder API
----------------------------------------------------
###


# Correct and check position of marker in TokenList.
#
# @throw {Error} if current position is impossible
position = ->
  unless @tokens.in ['paragraph']
    throw Error "Could only use `text()` in inline area"

###
Add inline text formated as mark.

@param {String|Boolean} input with content of text or true to open tag and
false to close tag if content is added manually.
@return {Report} instance itself for command concatenation
###
Report.prototype.mark = (input) ->
  if typeof input is 'boolean'
    if input
      position.call this
      # open new tag
      @tokens.insert [
        type: 'mark'
        nesting: 1
      ,
        type: 'mark'
        nesting: -1
      ], null, 1
    else
      @tokens.setAfterClosing 'mark'
  else
    position.call this
    return unless input
    # complete with content
    @tokens.insert
      type: 'mark'
      nesting: 1
    @text input
    @tokens.insert
      type: 'mark'
      nesting: -1
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
