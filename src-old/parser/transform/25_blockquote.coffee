# Blockquote
# =================================================


# Transformer rules
#
# @type {Object<Transformer>} rules to transform text into tokens
module.exports =

  block:
    state: ['m-block']
    re: ///
      ^(\n?       # 1: start of line
        \ {0,3}   # indented by 1-3 spaces (optional)
        >\ ?      # blockquote identifier
      )           # end of start
      (           # 2: content
        [^\n]*    # all to end of line (maybe empty)
      )           # end content
      (\n|$)      # 3: end of line
      /// # one line
    fn: (m) ->
      # check for concatenating
      last = @get()
      if last?.type is 'blockquote' and last.nesting is 0 and last.content? and not last.closed
        # add text
        last.content += '\n' if last.content
        last.content += m[2]
        @change()
      else
        # opening
        @insert null,
          type: 'blockquote'
          content: m[2]
      # done
      m[0].length

  continue:
    state: ['m-block']
    re: ///
      ^(\n?       # 1: start of line
        [\t\ ]*   # indented by spaces (optional)
        (?:>\ ?)? # block mark
      )           # end of start
      (           # 2: ending heading
        [^\n]*    # content
      )           #
      (\n|$)      # 3: end of line
      /// # one line
    fn: (m) ->
      # check for concatenating
      last = @get()
      return false unless last and last.type is 'blockquote'
      return unless last.nesting is 0 and last.content and not last.closed
      return if last.content.match /\n$/ # empty line break to paragraph
      # add text
      last.content += '\n' if last.content
      last.content += m[2]
      .replace /^(\s{0,3})([=-])/, "$1\\$2" # prevent headings in lazy continuation
      @change()
      # done
      m[0].length
