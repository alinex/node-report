###
Text
=================================================
Text may be added in block and inline elements like {@link paragraph.coffee},
{@link heading.coffee} or {@link char_style.coffee}. To use it you have to open
the element with value `true` before adding one or multiple text elements.
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
  unless @tokens.in ['paragraph', 'heading', 'preformatted', 'code']
    throw Error "Could only use `text()` in inline area"

###
Builder API
----------------------------------------------------
###

###
Add plain text to currently opened element.

@param {String} text to be added in currently opened element..
@return {Report} instance itself for command concatenation
###
Report.prototype.text = (text) ->
  return unless text
  position.call this
  @tokens.insert
    type: 'text'
    content: text
  this


###
Markdown Input/Output
----------------------------------------------------
While parsing backslashes used to escape special meaning will be removed in the
element and re-added on output. But only the really necessary escapes are done in
the output to keep it more readable.

The parsing is done after the CommonMark standard:
- [backslash escapes](http://spec.commonmark.org/0.27/#backslash-escapes)
- [hard line break](http://spec.commonmark.org/0.27/#hard-line-break)
- [soft line break](http://spec.commonmark.org/0.27/#soft-line-breaks)
- [textual content](http://spec.commonmark.org/0.27/#textual-content)


Other Output
----------------------------------------------------
The text content is mostly outputted without any change. Only exception may be the
transformation into emoji, special characters or fontawesome signs.


Examples
----------------------------------------------------
Examples will come soon...
###
