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
        (?:\ {4}|\t)   # indented by 4 spaces or tab
      )           # end of start
      (           # 2: content
        [^\n]+    # all till end of line
      )           # end content
      (\n|$)      # 3: end of line
      /// # one line
    fn: (m) ->
      # check for concatenating
      last = @get()
      if last?.type is 'preformatted' and last.content and not last.closed
        # add text
        last.content += "\n#{m[2]}"
        @change()
      else
        # opening
        @insert null,
          type: 'preformatted'
          state: '-text'
          content: m[2]
      # done
      m[0].length

  empty:
    state: ['m-block']
    re: /^[\ \t]*\n/ # multiple empty lines
    fn: (m) ->
      # check for concatenating
      last = @get()
      return if last?.type isnt 'preformatted' or (not last.content) or last.closed
      # add text
      last.content += "\n"
      @change()
      # done
      m[0].length
