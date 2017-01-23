# Text Phrases
# =================================================

util = require 'alinex-util'

# Transformer rules
#
# @type {Object<Transformer>} rules to transform text into tokens
module.exports =

  blocks:
    type: ['paragraph', 'preformatted', 'blockquote', 'item', 'include']
    state: ['m-inline', 'm-block']
    nesting: 0
    content: true
    fn: (num, token) ->
      return unless content = token.content
      # change token
      delete token.content
      token.nesting = 1
      # close item and list if not done already
      if token.type is 'item'
        token.closed = true
        token.parent.closed = true
      @change num
      # add content tokens
      @token = num
      @state = token.state
      @dirname = token.dirname if token.dirname
      @base = token.level
      @lexer content
      @autoclose token.level
      delete @base
      # close token
      @insert null,
        util.extend {}, token,
          nesting: -1
#      console.log @tokens.map (e) -> util.string.repeat(' ', e.level) + e.type
