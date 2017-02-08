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

  underscore:
    state: ['m-inline']
    re: ///
      ^(_{1,2})                   # 1: start MARKER
      (                           # 2: content
        [*_~=`^]*                 # inner marker
        [^\W_]                    # + word character (without underscore)
        (?:                       # + inner content
          (_{1,2})                  # 3: inner marker
          [\s\S]+?                  # data
          \3                        # end marker
        | [\s\S]                    # any characters
        )*?                         # multiple
        [^\W_]                    # end with word character (without underscore)
        [*_~=`^]*                 # + possible inner marker
      | [*_~=`^]*                 # or inner marker
        [^\W_]                    # + only one word character
        [*_~=`^]*                 # + inner marker
      )
      \1                          # end of element
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
      return if last.type not in ['text', 'paragraph']
      return if last.data?.text.substr(-1).match /\w|[*_~=`^]/
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
        (?:                       # + inner content
          (_{1,2})                  # 3: inner marker
          [\s\S]+?                  # data
          \3                        # end marker
        | [\s\S]                    # any characters
        )*?                         # multiple
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
      if last.type is 'text'
        return if last.data.text.match /[\u00BF-\u1FFF\u2C00-\uD7FF\w]$/
        return if last.data.text[-1..] is m[1][0]
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

  asterisk:
    state: ['m-inline']
    re: ///
      ^(\*{1,2})                  # 1: start MARKER
      (                           # 2: content
        [*_~=`^]*                 # inner marker
        [^\W_]                    # + word character (without asterisk)
        (?:                       # + inner content
          (\*{1,2})                 # 3: inner marker
          [\s\S]+?                  # data
          \3                        # end marker
        | [\s\S]                    # any characters
        )*                         # multiple
        [^\W_]                    # end with word character (without asterisk)
        [*_~=`^]*                 # + possible inner marker
      | [*_~=`^]*                 # or inner marker
        [^\W_]                    # + only one word character
        [*_~=`^]*                 # + inner marker
      )
      \1                          # end of element
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
      return if last.type not in ['text', 'paragraph']
      return if last.data?.text.substr(-1).match /\w|[*_~=`^]/
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

  asterisk_punct:
    state: ['m-inline']
    re: ///
      ^(\*{1,2})                  # 1: start MARKER
      (                           # 2: content
        [^\w\s]                   # punctuation
        (?:                       # + inner content
          (\*{1,2})                 # 3: inner marker
          [\s\S]+?                  # data
          \3                        # end marker
        | [\s\S]                    # any characters
        )*?                         # multiple
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
      if last.type is 'text'
        return if last.data.text.match /[\u00BF-\u1FFF\u2C00-\uD7FF\w]$/
        return if last.data.text[-1..] is m[1][0]
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
      ^([~]{1,2}|[=]{2}|[\^])     # 1: start MARKER
      (                           # 2: content
        [*_~=`^]*                 # inner marker
        [^\W_]                    # + word character (without underscore)
        [\s\S]*?                  # content
        [^\W_]                    # end with word character (without underscore)
        [*_~=`^]*                 # + possible inner marker
      | [*_~=`^]*                 # or inner marker
        [^\W_]                    # + only one word character
        [*_~=`^]*                 # + inner marker
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
      ^([~]{1,2}|[=]{2}|[\^])    # 1: start MARKER
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
      if last.type is 'text'
        return if last.data.text.match /[\u00BF-\u1FFF\u2C00-\uD7FF\w]$/
        return if last.data.text[-1..] is m[1][0]
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
