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

INNER_CODE = /(`+).*?\1/g

insertTag = (type, content) ->
  # opening
  @insert null,
    type: type
    state: '-inline'
    nesting: 1
  # parse subtext
  @lexer content
  # closing
  @insert null,
    type: type
    nesting: -1

re =
  punct: /[!"#$%&'()*+,./:;<=>?@[\\\]^`{|}~-]/
  word: /[\u00BF-\u1FFF\u2C00-\uD7FF\w]/

evalWord = (m, _, chars) ->
  console.log '--->', m
  # skip if fixed within
  while check = INNER_CODE.exec chars
    return if check.index + check[0].length > m[0].length
  # not the ones within the text
  last = @get()
  return if last.type not in ['text', 'paragraph']
  # check flanking
  startLeft = (last.data?.text.substr(-1).match re.punct) ? false
  startRight = (m[2][0].match re.punct) ? false
  console.log startLeft, startRight
  return if startRight and not startLeft
#  return if startLeft and startRight # punctuation start
#  if m[2][0].match re.punct # start right punct
#    return if last.data?.text.substr(-1).match re.punct # start left punct
  # disallow _ within words
  if m[1] is '_' and last.data?.text
    return unless startLeft or startRight
#    return if last.data?.text.substr(-1).match re.word
  # opening
  insertTag.call this, MARKER[m[1]], m[2]
  # done
  m[0].length


# Transformer rules
# ----------------------------------------------
#
# @type {Object<Transformer>} rules to transform text into tokens
module.exports =

  underscoreStrong:
    state: ['m-inline']
    re: ///
      ^(__)                     # 1: start MARKER
      (                         # 2: content is either
                                # single character
        [*_~=`^]*                 # or inner marker
                                  # + word or punct (without underscore)
        [\u00BF-\u1FFF\u2C00-\uD7FF\w!"#$%&'()*+,./:;<=>?@[\\\]^`{|}~-]
        [*_~=`^]*                 # + inner marker
        [*_~=`^]*                 # inner marker
      |                         # or text phrase
                                  # + word or punct (without underscore)
        [\u00BF-\u1FFF\u2C00-\uD7FF\w!"#$%&'()*+,./:;<=>?@[\\\]^`{|}~-]
        (?:                       # + inner content
          (_{1,2})                  # 3: inner marker
          [\s\S]+?                  # data
          \3                        # end marker
        | [\s\S]                    # any characters
        )*?                         # multiple
                                  # end with word or punct (without underscore)
        [\u00BF-\u1FFF\u2C00-\uD7FF\w!"#$%&'()*+,./:;<=>?@[\\\]^`{|}~-]
        [*_~=`^]*                 # + possible inner marker
      )
      \1                          # end of element
      ///
    fn: evalWord

  underscore:
    state: ['m-inline']
    re: ///
      ^(_)                       # 1: start MARKER
      (                           # 2: content
        [*_~=`^]*                   # inner marker
                                    # + word or punct (without underscore)
        [\u00BF-\u1FFF\u2C00-\uD7FF\w!"#$%&'()*+,./:;<=>?@[\\\]^`{|}~-]
        (?:                         # + inner content
          (_{1,2})                   # 3: inner marker
          [\s\S]+?                    # data
          \3                          # end marker
        | [\s\S]                    # any characters
        )*?                         # multiple
        (?:                         # + word or punct (without underscore)
          [\u00BF-\u1FFF\u2C00-\uD7FF\w!"#$%&'()*+,./:;<=>?@[\\\]^`{|}~-]
          [*_~=`^]*                   # + possible inner marker
        |$)
      | [*_~=`^]*                 # only inner marker
                                  # + word or punct (without underscore)
        [\u00BF-\u1FFF\u2C00-\uD7FF\w!"#$%&'()*+,./:;<=>?@[\\\]^`{|}~-]
        [*_~=`^]*                   # + inner marker
      )
      \1                          # end of element
      ///
    fn: evalWord

  asteriskStrong:
    state: ['m-inline']
    re: ///
      ^(\*\*)                     # 1: start MARKER
      (                         # 2: content is either
                                # single character
        [*_~=`^]*                 # or inner marker
                                  # + word or punct (without underscore)
        [\u00BF-\u1FFF\u2C00-\uD7FF\w!"#$%&'()*+,./:;<=>?@[\\\]^`{|}~-]
        [*_~=`^]*                 # + inner marker
        [*_~=`^]*                 # inner marker
      |                         # or text phrase
                                  # + word or punct (without underscore)
        [\u00BF-\u1FFF\u2C00-\uD7FF\w!"#$%&'()*+,./:;<=>?@[\\\]^`{|}~-]
        (?:                       # + inner content
          (\*{1,2})                  # 3: inner marker
          [\s\S]+?                  # data
          \3                        # end marker
        | [\s\S]                    # any characters
        )*?                         # multiple
                                  # end with word or punct (without underscore)
        [\u00BF-\u1FFF\u2C00-\uD7FF\w!"#$%&'()*+,./:;<=>?@[\\\]^`{|}~-]
        [*_~=`^]*                 # + possible inner marker
      )
      \1                          # end of element
      ///
    fn: evalWord

  asterisk:
    state: ['m-inline']
    re: ///
      ^(\*)                       # 1: start MARKER
      (                           # 2: content
        [*_~=`^]*                 # only inner marker
                                  # + word or punct (without underscore)
        [\u00BF-\u1FFF\u2C00-\uD7FF\w!"#$%&'()*+,./:;<=>?@[\\\]^`{|}~-]
        [*_~=`^]*                   # + inner marker
      |
        [*_~=`^]*                   # inner marker
                                    # + word or punct (without underscore)
        [\u00BF-\u1FFF\u2C00-\uD7FF\w!"#$%&'()*+,./:;<=>?@[\\\]^`{|}~-]
        (?:                         # + inner content
          (\*{1,2})                   # 3: inner marker
          [\s\S]+?                    # data
          \3                          # end marker
        | [\s\S]                    # any characters
        )*?                         # multiple
        (?:                         # + word or punct (without underscore)
          [\u00BF-\u1FFF\u2C00-\uD7FF\w!"#$%&'()*+,./:;<=>?@[\\\]^`{|}~-]
          [*_~=`^]*                   # + possible inner marker
        |$)
      )
      \1                          # end of element
      ///
    fn: evalWord
