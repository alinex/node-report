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
      return false unless last and last.type is 'item'
      return unless last?.nesting is 0 and last.content and not last.closed
      # check for concatenating
      depth = m[2].replace(/\t/g, '    ').length
      if depth < last.depth
        last.closed = true
        return false
      # add text
      last.content += '\n' if m[1][0] is '\n'
      last.content += '\n' + "#{m[2]}#{m[3]}".substr last.depth
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
          start: list.start
          list: list.list
          nesting: -1
          marker: list.marker
          depth: list.depth
      return false
