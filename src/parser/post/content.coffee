# Text Phrases
# =================================================

util = require 'alinex-util'

# Transformer rules
#
# @type {Object<Transformer>} rules to transform text into tokens
module.exports =

  paragraph:
    type: ['paragraph', 'preformatted']
    state: ['m-inline']
    nesting: 0
    content: true
    fn: (num, token) ->
      return unless content = token.content
      # change token
      delete token.content
      token.nesting = 1
      # add content tokens
      @token = num
      @state = token.state
      @lexer content
      # close token
      @insert null,
        util.extend {}, token,
          nesting: -1
