# List
# =================================================

debug = require('debug') 'report:parser:rule'


# Transformer rules
#
# @type {Object<Transformer>} rules to transform text into tokens
module.exports =

  empty:
    state: ['m-block']
    last: 'item'
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
    fn: (m, last) ->
      marker = m[4] ? m[2]
      depth = m[1].length + 1
      # check for same list type
      unless last.parent.marker is marker
        # close list
        @insert null,
          type: 'list'
          data:
            list: last.parent.data.list
          nesting: -1
          marker: last.parent.marker
          depth: last.parent.depth
        return false
      # add new item
      @insert null,
        type: 'item'
        depth: depth
        content: ''
      # done
      m[0].length

  next:
    state: ['m-block']
    last: 'item'
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
    fn: (m, last) ->
      # opening
      marker = m[4] ? m[2]
      depth = m[1].length - if m[5].length < 4 then 0 else m[5].length
      # check for same list type
      unless last.parent.marker is marker
        # close list
        @insert null,
          type: 'list'
          data:
            list: last.parent.data.list
          nesting: -1
          marker: last.parent.marker
          depth: last.parent.depth
        return false
      # add new item
      @insert null,
        type: 'item'
        depth: depth
        content: m[5] + m[6]
      # done
      m[0].length

  item:
    state: ['m-block']
    last: 'item'
    re: ///
      ^((?:\n?    # 1: start of line
        ([\t\ ]*) # 2: indention
      )+)         # end of start (multiple lines)
      (           # 3: ending heading
        [^\n]*    # content
      )           #
      (\n|$)      # 4: end of line
      /// # one line
    fn: (m, last) ->
      return unless last.nesting is 0 and last.content? and not last.closed
      # more than one blank line will close item and list
      if last.content is '' and m[1][0] is '\n'
        last.closed = true
        @autoclose last.parent.level - 1
        return
      # check for concatenating
      depth = m[2].replace(/\t/g, '    ').length
      strip = if depth >= last.depth then last.depth else 0
      # no lazy after newline
      if m[1][0] is '\n' and depth < last.depth
        last.closed = true
        return false
      # add text
      if m[1][0] is '\n'
        last.content += m[1].replace /[^\n]/g, ''
      last.content += '\n' + "#{m[2]}#{m[3]}".substr strip
      @change()
      # done
      m[0].length

  list:
    state: ['m-block']
    re: ///
      ^(\n?       # 1: start of line
        ([\t\ ]*) # 2: indention
      )           # end of start
      (           # 3: ending heading
        [^\n]*    # content
      )           #
      (\n|$)      # 4: end of line
      /// # one line
    fn: (m) ->
      last = @get()
      list = last.parent
      return false unless list and list.type is 'list'
      return false if list.closed
      # check for concatenating
      depth = m[2].replace(/\t/g, '    ').length
      if depth < list.depth
        list.closed = true
        @insert null,
          type: 'list'
          data:
            start: list.data.start
            list: list.data.list
          nesting: -1
          marker: list.marker
          depth: list.depth
      return false
