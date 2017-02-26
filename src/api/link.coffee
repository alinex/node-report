###
Link
=================================================
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
  for autoclose in ['preformatted', 'code']
    @tokens.setAfterClosing autoclose if @tokens.in autoclose

###
Builder API
----------------------------------------------------
###

###
Add a link.

@param {String|Boolean} input with link text or true to open tag and
false to close tag if link text is added manually.
@param {String} href destination (can be kept equal if link text is also the
destination)
@param {String} [title] can be given to describe the link (tooltip in html)
@return {Report} instance itself for command concatenation
###
Report.prototype.link = (input, href, title) ->
  if typeof input is 'boolean'
    if input
      unless href and href.length
        throw new Error "A link target is needed as second parameter if link is opened."
      position.call this
      # open new tag
      @tokens.insert [
        type: 'link'
        nesting: 1
        href: href
        title: title
      ,
        type: 'link'
        nesting: -1
      ], null, 1
    else
      @tokens.setAfterClosing 'link'
  else
    position.call this
    # complete with content
    @tokens.insert
      type: 'link'
      nesting: 1
      href: href ? input
      title: title
    @text input
    @tokens.insert
      type: 'link'
      nesting: -1
  this

###
Add a text link (shortcut).

@param {String|Boolean} input with content of paragraph or true to open tag and
false to close tag if content is added manually.
@return {Report} instance itself for command concatenation
###
Report.prototype.a = (input, href, title) -> @link input, href, title


###
Markdown Input/Output
----------------------------------------------------


Other Output
----------------------------------------------------


Examples
----------------------------------------------------
Examples will come soon...
###
