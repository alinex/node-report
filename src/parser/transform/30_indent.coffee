# Text Paragraph
# =================================================


# Transformer rules
#
# @type {Object<Transformer>} rules to transform text into tokens
module.exports =

  text:
    state: ['m-block', 'mh-block']
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
      if last?.type is 'preformatted'
        # add text
        last.data.text += "\n#{m[2]}"
        @change()
      else
        # opening
        @insert null,
          type: 'preformatted'
          data:
            text: m[2]
      # done
      @index += m[0].length
      m[0].length
