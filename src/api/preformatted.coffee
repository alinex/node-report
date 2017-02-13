###
Preformatted Text
=================================================
This section contains text which will be kept as is. No further markdown
interpretation within this blocks and all characters stay as they are including
line breaks. Also other whitespace like spaces are kept.
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
Add a text paragraph.

@param {String|Boolean} input with content of paragraph or true to open tag and
false to close tag if content is added manually.
@return {Report} instance itself for command concatenation
###
Report.prototype.preformatted = (input) ->
  if typeof input is 'boolean'
    if input
      position.call this
      # open new tag
      @tokens.insert [
        type: 'preformatted'
        nesting: 1
      ,
        type: 'preformatted'
        nesting: -1
      ], null, 1
    else
      @tokens.setAfterClosing 'preformatted'
  else
    position.call this
    # complete with content
    @tokens.insert
      type: 'preformatted'
      nesting: 1
    @text input
    @tokens.insert
      type: 'preformatted'
      nesting: -1
  this

###
Add a text paragraph (shortcut).

@param {String|Boolean} input with content of paragraph or true to open tag and
false to close tag if content is added manually.
@return {Report} instance itself for command concatenation
###
Report.prototype.pre = (input) -> @preformatted input


###
Markdown Input/Output
----------------------------------------------------


Other Output
----------------------------------------------------


Examples
----------------------------------------------------
Examples will come soon...
###
