# Text Paragraph
# =================================================


util = require 'alinex-util'


# Transformer rules
#
# @type {Object<Transformer>} rules to transform text into tokens
module.exports =

  text:
    state: ['m-block', 'mh-block']
    re: ///
      ^(\n*       # 1: start of line
        [\t\ ]*   # indented by spaces (optional)
      )           # end of start
      (           # 2: ending heading
        [^\n]+    # content
      )           #
      (\n|$)      # 3: end of line
      /// # one line
    fn: (m) ->
      # check for concatenating
      last = @get -1
      return false unless last and last.type is 'paragraph'
      return unless last?.nesting is 0 and last.content and not last.closed
      # insert padding for accurate positioning
      pad = util.string.repeat '\ufffd', m[1].length
      # add text
      last.content.text += "\n#{pad}#{m[2]}"
      # done
      @index += m[0].length
      m[0].length
