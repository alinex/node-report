###
Text Format
=================================================
As an inline element you may mark some text with specific display like:
- code
- bold
- italic
###

# ` typewriter
# ** bold
# __ bold
# * italic
# _ italic
# ^ superscript
# ~ subscript
# ~~ strikethrough
# == marked

MARKER =
  '**': 'bold'
  '__': 'bold'
  '*': 'italic'
  '_': 'italic'
  '~~': 'strikethrough'
  '~': 'subscript'
  '^': 'superscript'
  '==': 'highlight'
  '`': 'code'


# Transformer rules
# ----------------------------------------------
#
# @type {Object<Transformer>} rules to transform text into tokens
module.exports =

  all:
    state: ['m-inline', 'mh-inline']
    re: ///
      ^([*_~]{1,2}|[=]{2}|[`^])   # 1: start MARKER
      (                           # 2: content
        [*_~=`^]*\w               # start with marker + word character
        [\s\S]*?                  # content
        \w[*_~=`^]*               # end with word character + marker
      )
      \1                          # 3: end of element
      ///
    fn: (m) ->
      # opening
      @insert null,
        type: MARKER[m[1]]
        nesting: 1
      # parse subtext
      @index += m[1].length
      @lexer m[2]
      # closing
      @index += m[1].length
      @insert null,
        type: MARKER[m[1]]
        nesting: -1
      # done
      m[0].length
