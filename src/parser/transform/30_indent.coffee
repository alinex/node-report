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
        # insert padding for accurate positioning
        pad = util.string.repeat '\ufffd', m[1].length
        # add text
        @change()
        last.content.text += "\n#{pad}#{m[2]}"
      else
        # opening
        @insert null,
          type: 'preformatted'
          state: '-text'
          content:
            index: @index + m[1].length
            text: m[2]
      # done
      @index += m[0].length
      m[0].length
