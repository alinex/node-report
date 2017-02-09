###
Blockquote
=================================================
Is used for content which is quoted from other sources.
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
It may contain any block level element so if it is used manually you have to
create at least a paragraph element inside for the text element.
###


###
Add a blockquote element.

@param {String|Boolean} input with content of paragraph or true to open tag and
false to close tag if content is added manually.
@return {Report} instance itself for command concatenation
###
Report.prototype.blockquote = (input) ->
  if typeof input is 'boolean'
    if input
      position.call this
      # open new tag
      @tokens.insert [
        type: 'blockquote'
        nesting: 1
      ,
        type: 'blockquote'
        nesting: -1
      ], null, 1
    else
      @tokens.setAfterClosing 'blockquote'
  else
    position.call this
    # complete with content
    @tokens.insert [
      type: 'blockquote'
      nesting: 1
    ,
      type: 'paragraph'
      nesting: 1
    ,
      type: 'text'
      content: input
    ,
      type: 'paragraph'
      nesting: -1
    ,
      type: 'blockquote'
      nesting: -1
    ]
  this

###
Add a blockquote element (shortcut).

@param {String|Boolean} input with content of paragraph or true to open tag and
false to close tag if content is added manually.
@return {Report} instance itself for command concatenation
###
Report.prototype.q = (input) -> @blockquote input


###
Markdown Input/Output
----------------------------------------------------


Other Output
----------------------------------------------------


Examples
----------------------------------------------------
Examples will come soon...
###
