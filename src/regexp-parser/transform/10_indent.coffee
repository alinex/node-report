# Text Paragraph
# =================================================


# Transformer rules
#
# @type {Object<Transformer>} rules to transform text into tokens
module.exports =

  text:
    state: ['m-block']
    re: ///
      ^(          # 1: start of line
        (\n?)     # 2: possible additional newline
        (?:\ {4}|\t)   # indented by 4 spaces or tab
      )           # end of start
      (           # 3: content
        [^\n]+    # all till end of line
      )           # end content
      (\n|$)      # 4: end of line
      /// # one line
    fn: (m) ->
      # check for concatenating
      last = @get()
      return if m[1][0] isnt '\n' and last.type is 'paragraph' and
        last.content? and not last.closed # don't break paragraph blocks
      # don't be lazy in indented blockquote
      return if m[1][0] isnt '\n' and last.type is 'blockquote' and
        last.content? and not last.closed and not last.content.match /^(?:\ {4}|\t)/
      if last?.type is 'preformatted' and last.content and not last.closed
        # add text
        last.content += '\n' + m[2] if last.content
        last.content += m[3]
        @change()
      else
        # opening
        @insert null,
          type: 'preformatted'
          state: '-text'
          content: m[3]
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
      last.content += '\n' if last.content
      @change()
      # done
      m[0].length
