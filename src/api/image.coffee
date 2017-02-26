###
Image
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
Add an image.

@param {String|Boolean} input with image text or true to open tag and
false to close tag if image text is added manually.
@param {String} src destination (can also be an base64 image string)
@param {String} [title] can be given to describe the image (tooltip in html)
@return {Report} instance itself for command concatenation
###
Report.prototype.image = (input, src, title) ->
  if typeof input is 'boolean'
    if input
      unless src and src.length
        throw new Error "A image target is needed as second parameter if image is opened."
      position.call this
      # open new tag
      @tokens.insert [
        type: 'image'
        nesting: 1
        src: src
        title: title
      ,
        type: 'image'
        nesting: -1
      ], null, 1
    else
      @tokens.setAfterClosing 'image'
  else
    position.call this
    # complete with content
    @tokens.insert
      type: 'image'
      nesting: 1
      src: src ? input
      title: title
    @text input
    @tokens.insert
      type: 'image'
      nesting: -1
  this

###
Add a text image (shortcut).

@param {String|Boolean} input with content of paragraph or true to open tag and
false to close tag if content is added manually.
@return {Report} instance itself for command concatenation
###
Report.prototype.img = (input, href, title) -> @image input, href, title


###
Markdown Input/Output
----------------------------------------------------


Other Output
----------------------------------------------------


Examples
----------------------------------------------------
Examples will come soon...
###
