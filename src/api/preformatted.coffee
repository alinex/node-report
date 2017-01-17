###
Preformatted Text
=================================================
This section contains text which will be kept as si. No further markdown
interpretation within this blocks and all characters stay as they are including
line breaks. Also other whitespace like spaces are kept.
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
  if typeof input is 'boolean'
    @parser.begin()
    @parser.autoclose '-block', true if input
    @parser.insert null,
      type: 'preformatted'
      state: '-text'
      nesting: if input then 1 else -1
      inline: if input then true else false
    return this
  # add with text
  @preformatted true
  @text input
  @preformatted false

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
