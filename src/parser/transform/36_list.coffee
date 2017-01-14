# List
# =================================================

# token.list = bullet, ordered, definition, check
# token.start = 4 (for ordered list)
# token.marker = - + * \d+\. \d+\)

listType =
  '-': 'bullet'
  '+': 'bullet'
  '*': 'bullet'
  '.': 'ordered'
  ')': 'ordered'
  ':': 'definition'


# Transformer rules
#
# @type {Object<Transformer>} rules to transform text into tokens
module.exports =

  text:
    state: ['m-block', 'm-list']
    re: ///
      ^(\n?       # 1: start of line
        \ {0,3}   # indented by 1-3 spaces (optional)
      )           # end of start
      (           # 2: type of list
      [-+*:]      # bullet / definition list
      |(\d+)([.)]) # ordered list - 3: start - 4: type
      )\          # end of type
      (           # 5: content
        [^\n]*    # all to end of line (maybe empty)
      )           # end content
      (\n|$)      # 6: end of line
      /// # one line
    fn: (m) ->
      # check for concatenating
      last = @get()
      if last?.type is 'list' and last.nesting is 0 and last.content and not last.closed
        # add text
        last.content += "\n#{m[5]}"
        @change()
      else
        # opening
        marker = m[4] ? m[2]
        unless @state.match /-list$/ or last.parent.marker is marker
          @insert null,
            type: 'list'
            start: m[3]
            list: listType[marker]
            state: '-list'
            nesting: 1
            marker: marker
        @insert null,
          type: 'item'
          state: '-block'
          content: m[5]
      # done
      m[0].length
