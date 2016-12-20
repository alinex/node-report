# Text Paragraph
# =================================================

# Transformer rules
#
# @type {Object<Transformer>} rules to transform text into tokens
module.exports =

  md:
    state: ['m-block', 'mh-block']
    re: /^(\n*)([^\n]+)(\n|$)/
    fn: (m) ->
      if m[1].length is 0 and @tokens[@tokens.length - 1]?.type is 'paragraph'
        @tokens.pop()
      # opening
      @add
        type: 'paragraph'
        nesting: 1
        state: '-inline'
      @index += m[1].length
      # parse subtext
      @lexer m[2]
      # closing
      @index += m[3].length
      @add
        type: 'paragraph'
        nesting: -1
      # done
      m[0].length

  html:
    state: ['h-block', 'mh-block']
    re: /^<(\/)h([1-6])>/
    fn: (m) ->
      # check for autoclose
      if @state.match /m?h-inline/
        return unless @autoclose '-block'
      # add token
      level = parseInt m[2]
      unless m[1]
        @add
          type: 'heading'
          data:
            level: level
          nesting: 1
          state: '-inline'
      else
        @add
          type: 'heading'
          data:
            level: level
          nesting: -1
      # done
      m[0].length
