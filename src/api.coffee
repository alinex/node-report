###
Builder API
=================================================
###


module.exports = ->
  Report = require './index'


  ###
  Single Elements
  ----------------------------------------------
  ###
  Report.prototype.hr = ->
    @parser.begin()
    @parser.insert null,
      type: 'thematic_break'


  ###
  Block Elements
  ----------------------------------------------
  ###

  ###
  Add heading

  @param {Integer} level number of heading between 1..6
  @param {String|Boolean} text with content of heading or true to open tag and
  false to close tag if content is added manually.
  @return {Report} instance itself for command concatenation
  ###
  Report.prototype.heading = (level, text) ->
    @parser.begin()
    if typeof text is 'boolean'
      @parser.insert null,
        type: 'heading'
        data:
          level: level
        nesting: if text then 1 else -1
        inline: if text then true else false
      return this
    # add with text
    @heading level, true
    @text text
    @heading level, false

  Report.prototype.h1 = (text) -> @heading 1, text
  Report.prototype.h2 = (text) -> @heading 2, text
  Report.prototype.h3 = (text) -> @heading 3, text
  Report.prototype.h4 = (text) -> @heading 4, text
  Report.prototype.h5 = (text) -> @heading 5, text
  Report.prototype.h6 = (text) -> @heading 6, text


  Report.prototype.tt = (text) ->
    return unless text
    last = @parser.get -1
    throw Error "Could only use `tt()` in inline area" unless last?.inline
    if typeof text is 'boolean'
      @parser.insert null,
        type: 'typewriter'
        nesting: if text then 1 else -1
        inline: 1
      return this
    # add with text
    @tt true
    @text text
    @tt false


  ###
  Special Elements
  ----------------------------------------------
  ###

  Report.prototype.text = (text) ->
    return unless text
    last = @parser.get -1
    throw Error "Could only use `text()` in inline area" unless last?.inline
    @parser.insert null,
      type: 'text'
      data:
        text: text
      inline: true
