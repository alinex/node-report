# List
# =================================================

debug = require('debug') 'report:parser:rule'


# Transformer rules
#
# @type {Object<Transformer>} rules to transform text into tokens
module.exports =

  item:
    state: ['m-block']
    re: ///
      ^((?:\n?    # 1: start of line
        ([\t\ ]*) # 2: indention
      )+)         # end of start (multiple lines)
      (           # 3: ending heading
        [^\n]*    # content
      )           #
      (\n|$)      # 4: end of line
      /// # one line
    fn: (m) ->
      last = @get()
      return false unless last and last.type is 'item'
      return unless last?.nesting is 0 and last.content? and not last.closed
      # more than one blank line will close item and list
      if last.content is '' and m[1][0] is '\n'
        console.log '--------'
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
