###
Emphasis and Strong Emphasis Style
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
Add inline text formated as strikethrough.

@param {String|Boolean} input with content of text or true to open tag and
false to close tag if content is added manually.
@return {Report} instance itself for command concatenation
###
Report.prototype.strikethrough = (input) ->
  if typeof input is 'boolean'
    if input
      position.call this
      # open new tag
      @tokens.insert [
        type: 'strikethrough'
        nesting: 1
      ,
        type: 'strikethrough'
        nesting: -1
      ], null, 1
    else
      @tokens.setAfterClosing 'strikethrough'
  else
    position.call this
    return unless input
    # complete with content
    @tokens.insert
      type: 'strikethrough'
      nesting: 1
    @text input
    @tokens.insert
      type: 'strikethrough'
      nesting: -1
  this

###
Add inline text formated as strikethrough.

@param {String|Boolean} input with content of text or true to open tag and
false to close tag if content is added manually.
@return {Report} instance itself for command concatenation
###
Report.prototype.del = (input) -> @strikethrough input


###
Markdown Input/Output
----------------------------------------------------
The markdown interpretation goes back to the
[GFM strikethrough](https://help.github.com/articles/basic-writing-and-formatting-syntax/#styling-text)
implementation.

Text which is placed in double `~` characters will be presented as strike through
text.

Other Output
----------------------------------------------------


Examples
----------------------------------------------------
Examples will come soon...
###
