# Headings
# =================================================


util = require 'alinex-util'


# Transformer rules
#
# @type {Object<Transformer>} rules to set output text in token
module.exports =

  other:
    format: 'text'
    type: 'paragraph'
    fn: (num, token) ->
      width = @setup.width - (token.parent.indent ? 0)
      token.collect = util.string.wordwrap token.collect, width
