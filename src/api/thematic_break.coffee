###
Thematic Break
=================================================
The thematic break is used to indicate the transition to another topic within
the section. Mostly this is displayed as a horizontal line.
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
Add thematic break as horizontal rule.

@return {Report} instance itself for command concatenation
###
Report.prototype.thematic_break = ->
  position.call this
  @tokens.insert
    type: 'thematic_break'
  this

###
Add thematic break as horizontal rule (shortcut).

@return {Report} instance itself for command concatenation
###
Report.prototype.hr = -> @thematic_break()


###
Markdown Input/Output
----------------------------------------------------
Like defined in [CommonMark Specification](http://spec.commonmark.org/0.27/#thematic-breaks)
all three types `***`, `---`, `___` are possible for parsing with three or more
characters and possible spaces within. But in the


Other Output
----------------------------------------------------
Thematic breaks are possible in all formats and always render as a full width horizontal
line using `*` characters.


Examples
----------------------------------------------------
Examples will come soon...
###
