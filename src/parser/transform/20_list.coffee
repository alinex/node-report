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

  empty:
    state: ['m-block']
    re: ///
      ^(\n?       # 1: start of line
        \ {0,3}   # indented by 1-3 spaces (optional)
        (           # 2: type of list
        [-+*:]      # bullet / definition list
        |(\d{1,9})([.)]) # ordered list - 3: start - 4: type
        )         # end of type
      )           # end of start
      [\ \t]*     # indention doesn't matter
      (\n|$)      # 5: end of line
      /// # one line
    fn: (m) ->
      # check for concatenating
      last = @get()
      # opening
      marker = m[4] ? m[2]
      # calculate depth
      depth = m[1].length + 1
      unless @state.match /-list$/ or last.parent.marker is marker
        @insert null,
          type: 'list'
          data:
            list: listType[marker]
            start: Number m[3]
          nesting: 1
          marker: marker
          depth: depth
      @insert null,
        type: 'item'
        depth: depth
        content: ''
      # done
      m[0].length

  text:
    state: ['m-block']
    re: ///
      ^(\n?       # 1: start of line
        \ {0,3}   # indented by 1-3 spaces (optional)
        (           # 2: type of list
        [-+*:]      # bullet / definition list
        |(\d{1,9})([.)]) # ordered list - 3: start - 4: type
        )\          # end of type
        (\ {0,4})   # 5: additional text indent
      )           # end of start
      (           # 6: content
        [^\n]*    # all to end of line (maybe empty)
      )           # end content
      (\n|$)      # 6: end of line
      /// # one line
    fn: (m) ->
      # check for concatenating
      last = @get()
      # opening
      marker = m[4] ? m[2]
      # calculate depth
      depth = m[1].length - if m[5].length < 4 then 0 else m[5].length
      unless @state.match /-list$/ or last.parent.marker is marker
        @insert null,
          type: 'list'
          data:
            list: listType[marker]
            start: Number m[3]
          nesting: 1
          marker: marker
          depth: depth
      @insert null,
        type: 'item'
        depth: depth
        content: m[5] + m[6]
      # done
      m[0].length
