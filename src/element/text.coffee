
exports.lexer =

  char:
    state: ['md-inline', 'html-inline']
    re: /^./
    fn: (m) ->
      last = @tokens[@tokens.length-1]
      if last.type is 'text'
        last.data += m[0]
      else
        @add
          type: 'text'
          data: m[0]
      @index++
      # done processing
      m[0].length
