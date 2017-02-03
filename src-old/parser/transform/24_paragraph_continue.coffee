# Text Paragraph
# =================================================


# Transformer rules
#
# @type {Object<Transformer>} rules to transform text into tokens
module.exports =

  paragraph:
    state: ['m-block']
    last: 'paragraph'
    re: ///
      ^(\n?       # 1: start of line
        [\t\ ]*   # indented by spaces (optional)
      )           # end of start
      (           # 2: ending heading
        [^>][^\n]*  # content
      )           #
      (\n|$)      # 3: end of line
      /// # one line
    fn: (m, last) ->
      # check for concatenating
      return unless last.nesting is 0 and last.content and not last.closed
      # add text
      last.content += '\n' if last.content
      last.content += m[2]
      @change()
      # done
      m[0].length
