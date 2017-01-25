###
Code
=================================================
Code is like preformatted text but with a specific format which may be presented
with highlights for better readability.
###


# Node Modules
# -------------------------------------------------
Report = require '../index'
Config = require 'alinex-config'


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
    tag =
      type: 'code'
      state: '-text'
      nesting: if input then 1 else -1
      inline: if input then true else false
    if input
      tag.data =
        language: Config.get('/report/code/language')[language] ? language ? 'text'
    @parser.insert null, tag
    return this
  # add with text
  @code true, language
  @text input
  @code false


###
Markdown Input/Output
----------------------------------------------------
The parsing follows the CommonMark specification with the exception of:
- http://spec.commonmark.org/0.27/#example-106 because the code marker is not on
  it's own line it is completely interpreted as paragraph


Other Output
----------------------------------------------------


Examples
----------------------------------------------------
Examples will come soon...
###
