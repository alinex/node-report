###
Preformatted Text
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
Report.prototype.preformatted = (input) ->
  @parser.begin()
  if typeof input is 'boolean'
    @parser.insert null,
      type: 'preformatted'
      nesting: if input then 1 else -1
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
