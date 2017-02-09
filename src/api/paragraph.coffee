###
Paragraph
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
Add a text paragraph.

@param {String|Boolean} input with content of paragraph or true to open tag and
false to close tag if content is added manually.
@return {Report} instance itself for command concatenation
###
Report.prototype.paragraph = (input) ->
  if typeof input is 'boolean'
    if input
      position.call this
      # open new tag
      @tokens.insert [
        type: 'paragraph'
        nesting: 1
      ,
        type: 'paragraph'
        nesting: -1
      ], null, 1
    else
      @tokens.setAfterClosing 'paragraph'
  else
    position.call this
    # complete with content
    @tokens.insert [
      type: 'paragraph'
      nesting: 1
    ,
      type: 'text'
      content: input
    ,
      type: 'paragraph'
      nesting: -1
    ]

###
Add a text paragraph (shortcut).

@param {String|Boolean} input with content of paragraph or true to open tag and
false to close tag if content is added manually.
@return {Report} instance itself for command concatenation
###
Report.prototype.p = (input) -> @paragraph input


###
Markdown Input/Output
----------------------------------------------------


Other Output
----------------------------------------------------


Examples
----------------------------------------------------
Examples will come soon...
###
