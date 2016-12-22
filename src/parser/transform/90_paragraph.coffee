# Text Paragraph
# =================================================

# Transformer rules
#
# @type {Object<Transformer>} rules to transform text into tokens
module.exports =

  text:
    state: ['m-block', 'mh-block']
    re: /^(\n*[^\n]+)(\n|$)/ # one line
    fn: (m) ->
      # check for concatenating
      last = @get -1
      if last?.nesting is 0 and last.content and not last.closed
        last.content.text += "\n#{m[1]}"
      else
        # opening
        @add
          type: 'paragraph'
          state: '-inline'
          content:
            index: @index
            text: m[1]
      # done
      @index += m[0].length
      m[0].length
