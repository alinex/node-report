###
List
=================================================
Is used for different type of lists.
###


# Node Modules
# -------------------------------------------------
Report = require '../index'


###
Builder API
----------------------------------------------------
The list is constructed of two elements, the `list` defines the type and border
of the list and `item` is used for each element of the list containing block elements
like `paragraph`.
###


###
Add a list element.

@param {String|Boolean} input with content of paragraph or true to open tag and
false to close tag if content is added manually.
@return {Report} instance itself for command concatenation
###
Report.prototype.list = (input, type = 'bullet', start = 1) ->
  if typeof input is 'boolean'
    @parser.begin()
    @parser.autoclose '-block', true if input
    @parser.insert null,
      type: 'list'
      state: '-block'
      nesting: if input then 1 else -1
      inline: if input then true else false
      data:
        list: type
        start: start
    return this
  # add with text
  @list true, type, start
  @item e for e in input
  @list false

###
Add item to list.

@param {String|Boolean} input with content of paragraph or true to open tag and
false to close tag if content is added manually.
@return {Report} instance itself for command concatenation
###
Report.prototype.item = (input, title) ->
  if typeof input is 'boolean'
    @parser.begin()
    @parser.autoclose '-block', true if input
    @parser.insert null,
      type: 'item'
      state: '-block'
      nesting: if input then 1 else -1
      inline: if input then true else false
      title: title
    return this
  # add with text
  @item true, title
  @paragraph true
  @text input
  @paragraph false
  @item false

###
Add a bullet list (shortcut).

@param {Array|Boolean} input with content of paragraph or true to open tag and
false to close tag if content is added manually.
@return {Report} instance itself for command concatenation
###
Report.prototype.ul = (input) -> @list input, 'bullet'

###
Add a bullet list (shortcut).

@param {Array|Boolean} input with content of paragraph or true to open tag and
false to close tag if content is added manually.
@return {Report} instance itself for command concatenation
###
Report.prototype.dl = (input) -> @list input, 'definition'

###
Add a bullet list (shortcut).

@param {Array|Boolean} input with content of paragraph or true to open tag and
false to close tag if content is added manually.
@return {Report} instance itself for command concatenation
###
Report.prototype.ol = (input, start) -> @list input, 'ordered', start

###
Add a single item (shortcut).

@param {Array|Boolean} input with content of paragraph or true to open tag and
false to close tag if content is added manually.
@return {Report} instance itself for command concatenation
###
Report.prototype.li = (input, title) -> @item input, title


###
Markdown Input/Output
----------------------------------------------------
The markdown format is based on CommonMark Specification:
[list items](http://spec.commonmark.org/0.27/#atx-headings),
[lists](http://spec.commonmark.org/0.27/#atx-headings)

I prefer proper structure of information and don't support the decision between
loose or tight lists like propagated in the specification. I prefer to make such
layout decisions through the styles.


Other Output
----------------------------------------------------


Examples
----------------------------------------------------
Examples will come soon...
###
