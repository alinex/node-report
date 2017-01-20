# Text Paragraph
# =================================================


# Transformer rules
#
# @type {Object<Transformer>} rules to transform text into tokens
module.exports =

  text:
    state: ['m-block']
    re: ///
      ^(\n?       # 1: start of line
        \ {0,3}   # indented by 1-3 spaces (optional)
      )           # end of start
      (           # 2: content
        [^\n]+    # all to end of line
      )           # end content
      (\n|$)      # 3: end of line
      /// # one line
    fn: (m) ->
      # check for concatenating
      last = @get()
      if last?.type is 'paragraph' and last.nesting is 0 and last.content and not last.closed
        # add text
        last.content += '\n' if last.content
        last.content += m[2]
        @change()
      else
        # opening
        @insert null,
          type: 'paragraph'
          state: '-inline'
          content: m[2]
      # done
      m[0].length
