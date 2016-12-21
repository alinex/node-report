# Text Paragraph
# =================================================

# Transformer rules
#
# @type {Object<Transformer>} rules to transform text into tokens
module.exports =

  text:
    state: ['m-block', 'mh-block']
    re: /^(\n*)([^\n]+)(\n|$)/ # one line
    fn: (m) ->
      # check for concatenating
      last = @tokens[@tokens.length - 1]
      text = @tokens[@tokens.length - 2]
      if last?.nesting is -1 and text?.type is 'text' and not last?.closed
        # remove old closing tag and continue on existing as if it was just created
        text.data.text += '\n'
        @tokens.pop()
        @states.push text.state
      else
        # opening
        @add
          type: 'paragraph'
          nesting: 1
          state: '-inline'
      # parse subtext
      @state = "#{@domain}-inline"
      @index += m[1].length
      @lexer m[2]
      # closing
      @index += m[3].length
      @add
        type: @tokens[@tokens.length - 2].type
        nesting: -1
      # done
      m[0].length
