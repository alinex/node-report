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

INNER_CODE = /(`+).*?\1/g


# Transformer rules
# ----------------------------------------------
#
# @type {Object<Transformer>} rules to transform text into tokens
module.exports =

  backquote:
    state: ['m-inline']
    re: ///
      ^(`+)                # 1: start MARKER
      (?=[^`])             # not followed by backquote
      ([\s\S]*?[^`])       # 2: content
      \1                   # end MARKER
      (?=[^`]|$)           # not followed by backquote
      ///
    fn: (m) ->
      # opening
      @insert null,
        type: 'fixed'
        nesting: 1
      # parse subtext
      if m[2]
        @insert null,
          type: 'text'
          data:
            text: m[2].trim()
      # closing
      @insert null,
        type: 'fixed'
        nesting: -1
      # done
      m[0].length

  underscore:
    state: ['m-inline']
    re: ///
      ^(_{1,2})                   # 1: start MARKER
      (                           # 2: content
        [*_~=`^]*\w               # start with marker + word character
        [\s\S]*?                  # content
        \w[*_~=`^]*               # end with word character + marker
      | [*_~=`^]*\w[*_~=`^]*      # only one word character
      )
      \1                          # 3: end of element
      (?![*_~=`^]*                # not following marker
        [\u00BF-\u1FFF\u2C00-\uD7FF\w]  # + word character
      )
      ///
    fn: (m, _, chars) ->
      # skip if fixed within
      while check = INNER_CODE.exec chars
        return if check.index + check[0].length > m[0].length
      # not the ones within the text
      last = @get()
      if last.type not in ['text', 'paragraph'] \
      or last.data?.text.substr(-1).match /\w|[*_~=`^]/
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

  underscore_punct:
    state: ['m-inline']
    re: ///
      ^(_{1,2})                   # 1: start MARKER
      (                           # 2: content
        [^\w\s]                   # punctuation
        [\s\S]*?                  # content
        [^\w\s]                   # punctuation
      )
      \1                          # end of element
      (?![*_~=`^]*                # not following marker
        [\u00BF-\u1FFF\u2C00-\uD7FF\w]  # + word character
      )
      ///
    fn: (m, _, chars) ->
      last = @get()
      # skip if last text character isnt a punctuation character
      return if last.type is 'text' and last.data.text.match /[\u00BF-\u1FFF\u2C00-\uD7FF\w]$/
      # skip if fixed within
      while check = INNER_CODE.exec chars
        return if check.index + check[0].length > m[0].length
      # not the ones within the text
      if last.type not in ['text', 'paragraph'] \
      or last.data?.text.substr(-1).match /\w|[*_~=`^]/
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
      ^([*~]{1,2}|[=]{2}|[\^])    # 1: start MARKER
      (                           # 2: content
        [*_~=`^]*\w               # start with marker + word character
        [\s\S]*?                  # content
        \w[*_~=`^]*               # end with word character + marker
      | [*_~=`^]*\w[*_~=`^]*      # only one word character
      )
      \1                          # end MARKER
      ///
    fn: (m, _, chars) ->
      # skip if fixed within
      while check = INNER_CODE.exec chars
        return if check.index + check[0].length > m[0].length
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

  other_punct:
    state: ['m-inline']
    re: ///
      ^([*~]{1,2}|[=]{2}|[\^])    # 1: start MARKER
      (                           # 2: content
        [^\w\s*_]                 # punctuation
        [\s\S]*?                  # content
        [^\w\s*_]                 # punctuation
      )
      \1                          # end of element
      (?=[^\w\s]|$)               # punctuation
      ///
    fn: (m, _, chars) ->
      last = @get()
      # skip if last text character isnt a punctuation character
      return if last.type is 'text' and last.data.text.match /[\u00BF-\u1FFF\u2C00-\uD7FF\w]$/
      # skip if fixed within
      while check = INNER_CODE.exec chars
        return if check.index + check[0].length > m[0].length
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
