###
Character Style
=================================================
###


# Node Modules
# -------------------------------------------------
Report = require '../index'


###
Builder API
----------------------------------------------------
###


###
Add inline text formated as typewriter.

@param {String|Boolean} input with content of text or true to open tag and
false to close tag if content is added manually.
@return {Report} instance itself for command concatenation
###
Report.prototype.tt = (input) ->
  return unless input
  last = @parser.get -1
  throw Error "Could only use `tt()` in inline area" unless last?.inline
  if typeof input is 'boolean'
    @parser.insert null,
      type: 'typewriter'
      nesting: if input then 1 else -1
      inline: 1
    return this
  # add with text
  @tt true
  @text input
  @tt false


###
Markdown Input/Output
----------------------------------------------------


Other Output
----------------------------------------------------


Examples
----------------------------------------------------
Examples will come soon...
###
