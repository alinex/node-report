###
Superscript
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
Add inline text formated as superscript.

@param {String|Boolean} input with content of text or true to open tag and
false to close tag if content is added manually.
@return {Report} instance itself for command concatenation
###
Report.prototype.superscript = (input) ->
  if typeof input is 'boolean'
    if input
      position.call this
      # open new tag
      @tokens.insert [
        type: 'superscript'
        nesting: 1
      ,
        type: 'superscript'
        nesting: -1
      ], null, 1
    else
      @tokens.setAfterClosing 'superscript'
  else
    position.call this
    return unless input
    # complete with content
    @tokens.insert
      type: 'superscript'
      nesting: 1
    @text input
    @tokens.insert
      type: 'superscript'
      nesting: -1
  this

###
Add inline text formated as superscript.

@param {String|Boolean} input with content of text or true to open tag and
false to close tag if content is added manually.
@return {Report} instance itself for command concatenation
###
Report.prototype.sup = (input) -> @superscript input


###
Markdown Input/Output
----------------------------------------------------


Other Output
----------------------------------------------------


Examples
----------------------------------------------------
Examples will come soon...
###
