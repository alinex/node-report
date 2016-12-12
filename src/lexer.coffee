# Lexer
# =================================================
# This module is used to transform any input into the syntax tree.


# Node Modules
# -------------------------------------------------
debug = require('debug') 'report'

console.log 'TEST'

# regexp building helpers
WHITESPACE = '[^\S\n]'


# - `String` - `format`
# - `Array` - `tokenSrc`
class Lexer

  # instantiate
  construct: (@format) ->

  # add rules

  # init rules

  # parse
  parse: (text) ->
    @tokenSrc.push 111



lexer = new Lexer 'markdown'
console.log lexer
console.log lexer.parse "This is a test."
