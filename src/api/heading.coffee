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
Add heading to the report.

@param {Integer} level number of heading between 1..6
@param {String|Boolean} input with content of heading or true to open tag and
false to close tag if content is added manually.
@return {Report} instance itself for command concatenation
###
Report.prototype.heading = (level, input) ->
  if typeof input is 'boolean'
    if input
      position.call this
      # open new tag
      @tokens.insert [
        type: 'heading'
        heading: level
        nesting: 1
      ,
        type: 'heading'
        heading: level
        nesting: -1
      ], null, 1
    else
      @tokens.setAfterClosing 'heading'
  else
    position.call this
    # complete with content
    @tokens.insert
      type: 'heading'
      heading: level
      nesting: 1
    @text input
    @tokens.insert
      type: 'heading'
      heading: level
      nesting: -1
  this

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
[Setext Headings](http://spec.commonmark.org/0.27/#setext-headings).
So you may use one to six `#` characters at the start of line followed by one to three
spaces to issue a heading of level 1 to 6. The setext headings work as a line
which is followed by a line of at least three `=` or `-` characters to specify
a heading level 1 or 2.

In the output Setext headings are used for headings level 1 and 2 but for all others
the ATX headings will be used.

> If used for code documentation within the `alinex-codedoc` package you may also use
> the alternate syntax of hash followed by a number but this is not supported here

Other Output
----------------------------------------------------
Headings are possible in all formats and renders with strongest, biggest letters
(possibly with underline) and thiner, smaller ones for the lower levels 2..6.


Examples
----------------------------------------------------
Examples will come soon...
###
