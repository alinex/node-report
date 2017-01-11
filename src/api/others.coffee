###
Builder API
=================================================
###


Report = require '../index'

###
Single Elements
----------------------------------------------
###

###
Add thematic break as horizontal rule.

@return {Report} instance itself for command concatenation
###
Report.prototype.thematic_break = ->
  @parser.begin()
  @parser.insert null,
    type: 'thematic_break'
  this

###
Add thematic break as horizontal rule (shortcut).

@return {Report} instance itself for command concatenation
###
Report.prototype.hr = -> @thematic_break()


###
Block Elements
----------------------------------------------
###

###
Add heading to the report.

@param {Integer} level number of heading between 1..6
@param {String|Boolean} input with content of heading or true to open tag and
false to close tag if content is added manually.
@return {Report} instance itself for command concatenation
###
Report.prototype.heading = (level, input) ->
  @parser.begin()
  if typeof input is 'boolean'
    @parser.insert null,
      type: 'heading'
      data:
        level: level
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
Add a text paragraph.

@param {String|Boolean} input with content of paragraph or true to open tag and
false to close tag if content is added manually.
@return {Report} instance itself for command concatenation
###
Report.prototype.paragraph = (input) ->
  @parser.begin()
  if typeof input is 'boolean'
    @parser.insert null,
      type: 'paragraph'
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
Report.prototype.p = (input) -> @paragraph input

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
Inline Elements
----------------------------------------------
###

###
Add inline text formated as typewriter.

@param {String|Boolean} input with content of text or true to open tag and
false to close tag if content is added manually.
@return {Report} instance itself for command concatenation
###
Report.prototype.tt = (input) ->
  return unless input
  last = @parser.get -1
  throw Error "Could only use `tt()` in inline area" unless last?.inline
  if typeof input is 'boolean'
    @parser.insert null,
      type: 'typewriter'
      nesting: if input then 1 else -1
      inline: 1
    return this
  # add with text
  @tt true
  @text input
  @tt false


###
Special Elements
----------------------------------------------
###

###
Add plain text to currently opened element.

@param {String} text to be added in currently opened element..
@return {Report} instance itself for command concatenation
###
Report.prototype.text = (text) ->
  return unless text
  last = @parser.get -1
  throw Error "Could only use `text()` in inline area" unless last?.inline
  @parser.insert null,
    type: 'text'
    data:
      text: text
    inline: true
  this
