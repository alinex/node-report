###
Text Format
=================================================
As an inline element you may mark some text with specific display like:
- code
- bold
- italic
###


# Transformer rules
# ----------------------------------------------
#
# @type {Object<Transformer>} rules to transform text into tokens
module.exports =

  code:
    state: ['m-inline', 'mh-inline']
    re: ///
      ^(`)        # 1: start of part
      ([\s\S]*?)  # 2: content
      \1          # 3: end of element
      ///
    fn: (m) ->
      # opening
      @insert null,
        type: 'code'
        nesting: 1
      # parse subtext
      @index += m[1].length
      @lexer m[2]
      # closing
      @index += m[1].length
      @insert null,
        type: 'code'
        nesting: -1
      # done
      m[0].length

x = /^\*\*(\w[^*]*\w)\*\*/g
