###
Paragraph
=================================================
###


# Node Modules
# -------------------------------------------------
Report = require '../index'


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
