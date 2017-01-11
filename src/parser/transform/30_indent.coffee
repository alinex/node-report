# Text Paragraph
# =================================================


# Transformer rules
#
# @type {Object<Transformer>} rules to transform text into tokens
module.exports =

  text:
    state: ['m-block']
    re: ///
      ^(\r?\n?    # 1: start of line
        (?:\ {4}|\t)   # indented by 4 spaces or tab
      )           # end of start
      (           # 2: content
        [^\n]+    # all till end of line
      )           # end content
      (\r?\n|$)   # 3: end of line
      /// # one line
    fn: (m) ->
      # check for concatenating
      last = @get()
      if last?.nesting is 0 and last.content and not last.closed
        # add text
        @change()
        last.content += "\n#{m[2]}"
      else
        # opening
        @insert null,
          type: 'preformatted'
          state: '-text'
          content: m[2]
      # done
      m[0].length
