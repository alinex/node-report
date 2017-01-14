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


# 02_list if less than depth-spaces close list
# check again
# else remove depth-spaces from start

# Transformer rules
#
# @type {Object<Transformer>} rules to transform text into tokens
module.exports =

  text:
    state: ['m-block']
    re: ///
      ^(\n?       # 1: start of line
        \ {0,3}   # indented by 1-3 spaces (optional)
      (           # 2: type of list
      [-+*:]      # bullet / definition list
      |(\d+)([.)]) # ordered list - 3: start - 4: type
      )\          # end of type
      )           # end of start
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
            nesting: 1
            marker: marker
            depth: m[1].length
        @insert null,
          type: 'item'
          depth: m[1].length
          content: m[5]
      # done
      m[0].length
