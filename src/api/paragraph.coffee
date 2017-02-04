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
    @parser.begin()
    @parser.autoclose '-block', true if input
    @parser.insert null,
      type: 'paragraph'
      nesting: if input then 1 else -1
      state: '-inline'
      inline: if input then true else false
    return this
  # add with text
  @paragraph true
  @text input
  @paragraph false

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
