# Text Paragraph
# =================================================


util = require 'alinex-util'


# Transformer rules
#
# @type {Object<Transformer>} rules to transform text into tokens
module.exports =

  text:
    state: ['m-block']
    re: ///
      ^(\r?\n?    # 1: start of line
        \ {0,3}   # indented by 1-3 spaces (optional)
      )           # end of start
      (           # 2: content
        [^\n]+    # all to end of line
      )           # end content
      (\r?\n|$)   # 3: end of line
      /// # one line
    fn: (m) ->
      # check for concatenating
      last = @get()
      if last?.nesting is 0 and last.content and not last.closed
        # insert padding for accurate positioning
        pad = util.string.repeat '\ufffd', m[1].length
        # add text
        @change()
        last.content.text += "\n#{pad}#{m[2]}"
      else
        # opening
        @insert null,
          type: 'paragraph'
          state: '-inline'
          content:
            index: @index + m[1].length
            text: m[2]
      # done
      @index += m[0].length
      m[0].length
