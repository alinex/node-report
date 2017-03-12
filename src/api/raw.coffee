###
Raw Content
=================================================
This element is used to add raw content for a specific output format type or format.
It will be displayed as is without any changes and only in the defined output
format (and markdown).

Keep an eye here because you may break your document. The contents of the raw elements
are not checked for validity. It is given out the same as it comes in so be careful.
###


# Node Modules
# -------------------------------------------------
Report = require '../index'


###
Builder API
----------------------------------------------------
###

###
Add raw content to current element position.

@param {String} text to be added in currently opened element..
@param {String} format in which it should be visible
@return {Report} instance itself for command concatenation
###
Report.prototype.raw = (text, format) ->
  return unless text
  # auto detect format
  unless format
    format = 'html' if text.match /<.*>/
    throw new Error "Could not autodetect raw format of '#{text}'"
  # insert token
  @tokens.insert
    type: 'raw'
    format: format
    content: text
    block: Boolean @tokens.token.parent not in ['paragraph']
  this

###
Add raw html content to current element position.

@param {String} text to be added in currently opened element..
@return {Report} instance itself for command concatenation
###
Report.prototype.html = (text) -> @raw text, 'html'


###
Markdown Input/Output
----------------------------------------------------

#3 HTML

HTML content may be directly included in markdown if this is enabled in the configuration
(this is the default). It can be given as block or inline element.

#3 Other Formats

All other formats but also HTML may be added as an HTML comment and will also be outputted
as such.


Other Output
----------------------------------------------------
The raw content will only be included in markdown and the defined format or format type.


Examples
----------------------------------------------------
Examples will come soon...
###
