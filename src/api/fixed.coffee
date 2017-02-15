###
Fixed Code Style
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
Add inline text formated as typewriter.

@param {String|Boolean} input with content of text or true to open tag and
false to close tag if content is added manually.
@return {Report} instance itself for command concatenation
###
Report.prototype.fixed = (input) ->
  if typeof input is 'boolean'
    if input
      position.call this
      # open new tag
      @tokens.insert [
        type: 'fixed'
        nesting: 1
      ,
        type: 'fixed'
        nesting: -1
      ], null, 1
    else
      @tokens.setAfterClosing 'fixed'
  else
    return unless input
    position.call this
    # complete with content
    @tokens.insert
      type: 'fixed'
      nesting: 1
    @text input
    @tokens.insert
      type: 'fixed'
      nesting: -1
  this

###
Add inline text formated as typewriter.

@param {String|Boolean} input with content of text or true to open tag and
false to close tag if content is added manually.
@return {Report} instance itself for command concatenation
###
Report.prototype.tt = (input) -> @fixed input

###
Markdown Input/Output
----------------------------------------------------


Other Output
----------------------------------------------------


Examples
----------------------------------------------------
Examples will come soon...
###
