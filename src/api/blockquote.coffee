###
Blockquote
=================================================
Is used for content which is quoted from other sources.
###


# Node Modules
# -------------------------------------------------
Report = require '../index'


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
    @parser.begin()
    @parser.autoclose '-block', true if input
    @parser.insert null,
      type: 'blockquote'
      state: '-block'
      nesting: if input then 1 else -1
      inline: if input then true else false
    return this
  # add with text
  @blockquote true
  @paragraph true
  @text input
  @paragraph false
  @blockquote false

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
