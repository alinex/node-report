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
      @index = content.index
      @state = token.state
      @lexer content.text
      # close token
      @insert null,
        util.extend {}, token,
          nesting: -1
          index: content.index + content.text.length
