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
        [\t\ ]*   # indented by spaces (optional)
      )           # end of start
      (           # 2: ending heading
        [^\n]+    # content
      )           #
      (\r?\n|$)   # 3: end of line
      /// # one line
    fn: (m) ->
      # check for concatenating
      last = @get @idx ? -1
      return false unless last and last.type is 'paragraph'
      return unless last?.nesting is 0 and last.content and not last.closed
      # add text
      last.content += "\n#{m[2]}"
      @change()
      # done
      m[0].length
