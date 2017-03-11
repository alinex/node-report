###
Style setting
=================================================
This element is should not be displayed but kept hidden in the output source..
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
Report.prototype.comment = (text) ->
  return unless text
  # insert token
  @tokens.insert
    type: 'format'
    content: text
    block: Boolean @tokens.token.parent not in ['paragraph']
  this


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
