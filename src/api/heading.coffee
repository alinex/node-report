###
Headings
=================================================
Each document should have at least one heading at the top but you may use multiple
headings in different levels to structure your document. You may use the levels
1 to 6 therefore with 1 as the highest level. The first heading in your report
is also considered as the document title.

To visualize the report structure you may use the {@link toc.coffee} element.
###


# Node Modules
# -------------------------------------------------
Report = require '../index'


###
Builder API
----------------------------------------------------
###

###
Add heading to the report.

@param {Integer} level number of heading between 1..6
@param {String|Boolean} input with content of heading or true to open tag and
false to close tag if content is added manually.
@return {Report} instance itself for command concatenation
###
Report.prototype.heading = (level, input) ->
  if typeof input is 'boolean'
    @parser.begin()
    @parser.autoclose '-block', true if input
    @parser.insert null,
      type: 'heading'
      data:
        level: level
      state: '-inline'
      nesting: if input then 1 else -1
      inline: if input then true else false
    return this
  # add with text
  @heading level, true
  @text input
  @heading level, false

###
Add heading to the report (shortcut).

@param {Integer} level number of heading between 1..6
@param {String|Boolean} input with content of heading or true to open tag and
false to close tag if content is added manually.
@return {Report} instance itself for command concatenation
###
Report.prototype.h = (level, input) -> @heading level, input

###
Add heading level 1 to the report

@param {String|Boolean} input with content of heading or true to open tag and
false to close tag if content is added manually.
@return {Report} instance itself for command concatenation
###
Report.prototype.h1 = (input) -> @heading 1, input

###
Add heading level 2 to the report

@param {String|Boolean} input with content of heading or true to open tag and
false to close tag if content is added manually.
@return {Report} instance itself for command concatenation
###
Report.prototype.h2 = (input) -> @heading 2, input

###
Add heading level 3 to the report

@param {String|Boolean} input with content of heading or true to open tag and
false to close tag if content is added manually.
@return {Report} instance itself for command concatenation
###
Report.prototype.h3 = (input) -> @heading 3, input

###
Add heading level 4 to the report

@param {String|Boolean} input with content of heading or true to open tag and
false to close tag if content is added manually.
@return {Report} instance itself for command concatenation
###
Report.prototype.h4 = (input) -> @heading 4, input

###
Add heading level 5 to the report

@param {String|Boolean} input with content of heading or true to open tag and
false to close tag if content is added manually.
@return {Report} instance itself for command concatenation
###
Report.prototype.h5 = (input) -> @heading 5, input

###
Add heading level 6 to the report

@param {String|Boolean} input with content of heading or true to open tag and
false to close tag if content is added manually.
@return {Report} instance itself for command concatenation
###
Report.prototype.h6 = (input) -> @heading 6, input


###
Markdown Input/Output
----------------------------------------------------
The markdown format is based on CommonMark Specification:
[ATX Headings](http://spec.commonmark.org/0.27/#atx-headings),
[Setext Headings](http://spec.commonmark.org/0.27/#setext-headings)

Exceptions to the standard:
- Escaped Underline of an setext heading is also not interpreted as thematic break
  which makes it more consistent and the behavior in
  [example 75](http://spec.commonmark.org/0.27/#example-75)
  is never really needed.

In the output Setext headings are used for headings level 1 and 2 but for all others
the ATX headings will be used.


Other Output
----------------------------------------------------
Headings are possible in all formats and renders with strongest, biggest letters
(possibly with underline) and thiner, smaller ones for the lower levels 2..6.


Examples
----------------------------------------------------
Examples will come soon...
###
