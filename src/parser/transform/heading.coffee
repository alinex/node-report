# Detect Headings
# =================================================

# Transformer rules
#
# @type {Object<Transformer>} rules to transform text into tokens
module.exports =

  md:
    state: ['m-block', 'mh-block']
    re: /^(\n*(#{1,6}) )([^\n]+)(?:\n|$)/
    fn: (m) ->
      level = m[2].length
      # opening
      @add
        type: 'heading'
        data:
          level: level
        nesting: 1
        state: '-inline'
      @index += m[1].length
      # parse subtext
      @lexer m[3]
      # closing
      @add
        type: 'heading'
        data:
          level: level
        nesting: -1
        index: @index + m[1].length + m[3].length
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
