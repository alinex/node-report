###
Headings
=================================================
###


# Lexer definition
#
# @type {Object<Lexer>} lexer rules
exports.lexer =

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
      @parse m[3]
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
    state: ['h-block', 'h-inline', 'mh-block', 'mh-inline']
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

# Modifications before transforming
exports.pre = {}

# Transform routines
exports.transform =
  text: (t) ->

  html: (t) ->
    if t.nesting > 0
      t.text = "<h#{t.data.level}"
      t.text += " class=\"#{t.data.class.join ' '}\"" if t.data.class
      t.text += ">"
    else
      t.text = "</h#{t.data.level}>"

# Modifications after transform
exports.post = {}
