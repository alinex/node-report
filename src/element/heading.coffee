###
Headings
=================================================
###


# Lexer definition
#
# @type {Object<Lexer>} lexer rules
exports.lexer =

  md_ast:
    state: ['md']
    re: /^(\n*(#{1,6}) )([^\n]+)(?:\n|$)/
    fn: (m) ->
      level = m[2].length
      # opening
      @add
        type: 'heading'
        data: level
        nesting: 1
        state: 'md-inline'
      @index += m[1].length
      # parse subtext
      @parse m[3]
      # closing
      @add
        type: 'heading'
        data: level
        nesting: -1
        index: @index + m[1].length + m[3].length
      # done
      m[0].length

  html:
    state: ['html-block', 'html-inline']
    re: /^<(\/)h([1-6])>/
    fn: (m) ->
      # check for autoclose
      if @state is 'html-inline'
        return unless @autoclose 'html-block'
      # add token
      level = parseInt m[2]
      unless m[1]
        @add
          type: 'heading'
          data: level
          nesting: 1
          state: 'html-inline'
      else
        @add
          type: 'heading'
          data: level
          nesting: -1
      # done
      m[0].length

# Modifications before transforming
exports.pre = {}

# Transform routines
exports.transform = {}

# Modifications after transform
exports.post = {}
