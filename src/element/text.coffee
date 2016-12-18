
exports.lexer =

  char:
    state: ['m-inline', 'mh-inline', 'h-inline']
    re: /^./
    fn: (m) ->
      last = @tokens[@tokens.length-1]
      if last.type is 'text'
        last.data.text += m[0]
      else
        @add
          type: 'text'
          data:
            text: m[0]
      @index++
      # done processing
      m[0].length
