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
    @tokens.insert
      type: 'list'
      list: type
      start: start
      nesting: 1
    @item e for e in input
    @tokens.insert
      type: 'list'
      list: type
      nesting: -1
  this

###
Add item to list.

@param {String|Boolean} input with content of paragraph or true to open tag and
false to close tag if content is added manually.
@param {Boolean} task set to `true` or `false` to use as task item
@return {Report} instance itself for command concatenation
###
Report.prototype.item = (input, task) ->
  if typeof input is 'boolean'
    if input
      position.call this
      # open new tag
      @tokens.insert [
        type: 'item'
        nesting: 1
        task: task
      ,
        type: 'item'
        nesting: -1
      ], null, 1
    else
      @tokens.setAfterClosing 'item'
  else
    position.call this
    # complete with content
    @tokens.insert
      type: 'item'
      nesting: 1
      task: task
    @paragraph input, not input.match /\n/
    @tokens.insert
      type: 'item'
      nesting: -1
  this

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
