###
List
=================================================
Is used for different type of lists.
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
    if input
      position.call this
      # open new tag
      @tokens.insert [
        type: 'list'
        list: type
        start: start
        nesting: 1
      ,
        type: 'list'
        list: type
        nesting: -1
      ], null, 1
    else
      @tokens.setAfterClosing 'list'
  else
    position.call this
    # complete with content
    list = [
      type: 'list'
      list: type
      start: start
      nesting: 1
    ]
    for e in input
      list.push
        type: 'item'
        nesting: 1
      list.push
        type: 'paragraph'
        hidden: true
        nesting: 1
      list.push
        type: 'text'
        content: e
      list.push
        type: 'paragraph'
        nesting: -1
      list.push
        type: 'item'
        nesting: -1
    list.push
      type: 'list'
      list: type
      nesting: -1
    @tokens.insert list
  this


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
