###
Code
=================================================
Code is like preformatted text but with a specific format which may be presented
with highlights for better readability.
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

@param {String|Boolean} input with content of code or true to open tag and
false to close tag if content is added manually.
@return {Report} instance itself for command concatenation
###
Report.prototype.code = (input, language) ->
  if typeof input is 'boolean'
    @parser.begin()
    @parser.autoclose '-block', true if input
    @parser.insert null,
      type: 'code'
      state: '-text'
      data:
        language: language
      nesting: if input then 1 else -1
      inline: if input then true else false
    return this
  # add with text
  @code true
  @text input
  @code false


###
Markdown Input/Output
----------------------------------------------------


Other Output
----------------------------------------------------


Examples
----------------------------------------------------
Examples will come soon...
###
