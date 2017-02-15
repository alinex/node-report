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
Add inline text formated as emphasis.

@param {String|Boolean} input with content of text or true to open tag and
false to close tag if content is added manually.
@return {Report} instance itself for command concatenation
###
Report.prototype.emphasis = (input) ->
  if typeof input is 'boolean'
    if input
      position.call this
      # open new tag
      @tokens.insert [
        type: 'emphasis'
        nesting: 1
      ,
        type: 'emphasis'
        nesting: -1
      ], null, 1
    else
      @tokens.setAfterClosing 'emphasis'
  else
    position.call this
    return unless input
    # complete with content
    @tokens.insert
      type: 'emphasis'
      nesting: 1
    @text input
    @tokens.insert
      type: 'emphasis'
      nesting: -1
  this


###
Add inline text formated as strong emphasis.

@param {String|Boolean} input with content of text or true to open tag and
false to close tag if content is added manually.
@return {Report} instance itself for command concatenation
###
Report.prototype.strong = (input) ->
  if typeof input is 'boolean'
    if input
      position.call this
      # open new tag
      @tokens.insert [
        type: 'strong'
        nesting: 1
      ,
        type: 'strong'
        nesting: -1
      ], null, 1
    else
      @tokens.setAfterClosing 'strong'
  else
    return unless input
    position.call this
    # complete with content
    @tokens.insert
      type: 'strong'
      nesting: 1
    @text input
    @tokens.insert
      type: 'strong'
      nesting: -1
  this

###
Add inline text formated as emphasis.

@param {String|Boolean} input with content of text or true to open tag and
false to close tag if content is added manually.
@return {Report} instance itself for command concatenation
###
Report.prototype.italic = (input) -> @emphasis input

###
Add inline text formated as emphasis.

@param {String|Boolean} input with content of text or true to open tag and
false to close tag if content is added manually.
@return {Report} instance itself for command concatenation
###
Report.prototype.em = (input) -> @emphasis input

###
Add inline text formated as strong emphasis.

@param {String|Boolean} input with content of text or true to open tag and
false to close tag if content is added manually.
@return {Report} instance itself for command concatenation
###
Report.prototype.bold = (input) -> @strong input

###
Add inline text formated as strong emphasis.

@param {String|Boolean} input with content of text or true to open tag and
false to close tag if content is added manually.
@return {Report} instance itself for command concatenation
###
Report.prototype.b = (input) -> @strong input


###
Markdown Input/Output
----------------------------------------------------


Other Output
----------------------------------------------------


Examples
----------------------------------------------------
Examples will come soon...
###
