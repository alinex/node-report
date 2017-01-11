###
Thematic Break
=================================================
###


Report = require '../index'

###
API Builder
----------------------------------------------------
###

###
Add thematic break as horizontal rule.

@return {Report} instance itself for command concatenation
###
Report.prototype.thematic_break = ->
  @parser.begin()
  @parser.insert null,
    type: 'thematic_break'
  this

###
Add thematic break as horizontal rule (shortcut).

@return {Report} instance itself for command concatenation
###
Report.prototype.hr = -> @thematic_break()


###
Markdown Spec
----------------------------------------------------





###
