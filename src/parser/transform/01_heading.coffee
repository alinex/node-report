# Detect Headings
# =================================================

# Transformer rules
#
# @type {Object<Transformer>} rules to transform text into tokens
module.exports =

  md:
    state: ['m-block', 'mh-block']
    re: ///
      ^(\n*       # 1: start of line
        \ {0,3}   # indented by 1-3 spaces
        (\#{1,6}) # 2: level 1-6
        [\ \t]+   # at least one space
      )           # end of start
      ([^\n]*?)   # 3: text with optional trailing spaces
      (\n|$)      # 4: end of line
      ///
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
      text = m[3].replace /\s+$/, ''
      @lexer text
      # closing
      @index += m[3].length - text.length + m[4].length
      @add
        type: 'heading'
        data:
          level: level
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
