
exports.lexer =

  md:
    state: ['md']
    re: /^(\n*(#{1,6}) )([^\n]+)(?:\n|$)/
    fn: (m) ->
      # opening
      @add
        type: 'heading'
        nesting: 1
        data: m[2].length
        state: 'md-inline'
      @index += m[1].length
      # parse subtext
      @parse m[3]
      # closing
      @add
        type: 'heading'
        nesting: -1
        data: m[2].length
        index: @index + m[1].length + m[3].length
      # done
      m[0].length

  html:
    state: ['html-block']
    re: /^<(\/)h([1-6])>/
    fn: (m) ->
      @add
        nesting: if m[1] then -1 else 1
        data: parseInt m[2]

exports.pre = {}

exports.transform = {}

exports.post = {}
