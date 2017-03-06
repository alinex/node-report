###
Code
=================================================
Code is like preformatted text but with a specific format which may be presented
with highlights for better readability.
###


# Node Modules
# -------------------------------------------------
Report = require '../index'
Config = require 'alinex-config'


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
Add a text paragraph.

@param {String|Boolean} input with content of code or true to open tag and
false to close tag if content is added manually.
@return {Report} instance itself for command concatenation
###
Report.prototype.code = (input, language) ->
  if typeof input is 'boolean'
    if input
      position.call this
      # open new tag
      @tokens.insert [
        type: 'code'
        nesting: 1
        language: Config.get('/report/code/alias')[language] ? language ? 'text'
      ,
        type: 'code'
        nesting: -1
      ], null, 1
    else
      @tokens.setAfterClosing 'code'
  else
    position.call this
    # complete with content
    @tokens.insert [
      type: 'code'
      nesting: 1
      language: Config.get('/report/code/alias')[language] ? language ? 'text'
    ,
      type: 'text'
      content: input
    ,
      type: 'code'
      nesting: -1
    ]
  this


###
Markdown Input/Output
----------------------------------------------------


Other Output
----------------------------------------------------


Examples
----------------------------------------------------
Examples will come soon...
###
