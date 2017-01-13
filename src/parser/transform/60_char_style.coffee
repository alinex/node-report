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
  '**': 'strong'
  '__': 'strong'
  '*': 'emphasis'
  '_': 'emphasis'
  '~~': 'strikethrough'
  '~': 'subscript'
  '^': 'superscript'
  '==': 'highlight'
  '`': 'fixed'


# Transformer rules
# ----------------------------------------------
#
# @type {Object<Transformer>} rules to transform text into tokens
module.exports =

  underscore:
    state: ['m-inline']
    re: ///
      ^(_{1,2})                   # 1: start MARKER
      (                           # 2: content
        [*_~=`^]*\w               # start with marker + word character
        [\s\S]*?                  # content
        \w[*_~=`^]*               # end with word character + marker
      )
      \1                          # 3: end of element
      (?![*_~=`^]*\w)             # not following marker + word character
      ///
    fn: (m) ->
      # not the ones within the text
      last = @get()
      if last.type isnt 'text' \
      or last.data.text.substr(-1).match /\w|[*_~=`^]/
        return
      # opening
      @insert null,
        type: MARKER[m[1]]
        state: if m[1] is 'fixed' then '-text' else '-inline'
        nesting: 1
      # parse subtext
      @lexer m[2]
      # closing
      @insert null,
        type: MARKER[m[1]]
        nesting: -1
      # done
      m[0].length

  other:
    state: ['m-inline']
    re: ///
      ^([*~]{1,2}|[=]{2}|[`^])   # 1: start MARKER
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
      @lexer m[2]
      # closing
      @insert null,
        type: MARKER[m[1]]
        nesting: -1
      # done
      m[0].length
