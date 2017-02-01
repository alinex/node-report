###
Text Format
=================================================
###

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

rePunct = /[!"#$%&'()*+,./:;<=>?@[\\\]^`{|}~ \t-]/


evalWord = (m, _, chars) ->
  console.log '--->', m
  # skip if fixed within
  while check = INNER_CODE.exec chars
    return if check.index + check[0].length > m[0].length
  # not the ones within the text
  last = @get()
  return if last.type not in ['text', 'paragraph']
  # check flanking
  before = Boolean (last.data?.text
  .match /[^\s*_~=`^][\s*_~=`^]*$/)
  startLeft = Boolean (last.data?.text
  .match /[!"#$%&'()+,./:;<>?@[\\\]{|} \t-][*_~=`^]*$/)
  startRight = Boolean (m[2]
  .match /^[*_~=`^]*[!"#$%&'()+,./:;<>?@[\\\]{|} \t-]/)
  endLeft = Boolean (m[2]
  .match /[!"#$%&'()+,./:;<>?@[\\\]{|} \t-][*_~=`^]*$/)
  endRight = Boolean (chars.substr(m[0].length)
  .match /^[*_~=`^]*[!"#$%&'()+,./:;<>?@[\\\]{|} \t-]/)
  after = Boolean chars.substr(m[0].length, 1)
  console.log before, startLeft, startRight, endLeft, endRight, after
  return if startRight and not (before or startLeft or endLeft)
  return if startRight and before and not startLeft
  return if startRight and endRight and after and not endLeft
  if m[1][0] is '_' and last.data?.text
    return unless startLeft

  # opening
  insertTag.call this, MARKER[m[1]], m[2]
  # done
  m[0].length


# Export Transformer rules
# ----------------------------------------------
#
# @type {Object<Transformer>} rules to transform text into tokens
module.exports =

  # Strong Rules
  # ---------------------------------------------

  star2Word:
    state: ['m-inline']
    re: ///
      ^(\*\*) # marker
      ( # content
        [\u00BF-\u1FFF\u2C00-\uD7FFa-zA-Z0-9] # word
        (?: # optional nested marker
          \1
          [\s\S]*? # any
          \1
        | # optional multiple characters
          [\s\S]*? # any
        )*?
        [^\s*_~=`^] # no whitespace or marker
      )
      \1 # end marker
    ///
    fn: evalWord

  star2Punct:
    state: ['m-inline']
    re: ///
      ^(\*\*) # marker
      ( # content
        [\ \t!"#$%&\'()*+,.\/:;<=>?@[\\\]^`{|}~-] # white or punct
        (?: # optional multiple characters
          [\s\S]*? # any
          [!"#$%&\'()*+,.\/:;<=>?@[\\\]^`{|}~-] # punct
        )?
      )
      \1 # end marker
      (?= # following but not included
        [\ \t!"#$%&\'()*+,.\/:;<=>?@[\\\]^`{|}~-] # white or punct
      | $ # end of document
      )
    ///
    fn: evalWord

  under2Word:
    state: ['m-inline']
    re: ///
      ^(__) # marker
      ( # content
        [\u00BF-\u1FFF\u2C00-\uD7FFa-zA-Z0-9] # word
        (?: # optional nested marker
          \1
          [\s\S]*? # any
          \1
        | # optional multiple characters
          [\s\S]*? # any
        )*?
        [^\s*_~=`^] # no whitespace or marker
      )
      \1 # end marker
      (?= # following but not included
        [\ \t!"#$%&\'()*+,.\/:;<=>?@[\\\]^`{|}~-] # white or punct
      | $ # end of document
      )
    ///
    fn: evalWord

  under2Punct:
    state: ['m-inline']
    re: ///
      ^(__) # marker
      ( # content
        [\ \t!"#$%&\'()*+,.\/:;<=>?@[\\\]^`{|}~-] # white or punct
        (?: # optional multiple characters
          [\s\S]*? # any
          [!"#$%&\'()*+,.\/:;<=>?@[\\\]^`{|}~-] # punct
        )?
      )
      \1 # end marker
      (?= # following but not included
        [\ \t!"#$%&\'()*+,.\/:;<=>?@[\\\]^`{|}~-] # white or punct
      | $ # end of document
      )
    ///
    fn: evalWord


  # Emphasis Rules
  # ---------------------------------------------

  starWord:
    state: ['m-inline']
    re: ///
      ^(\*) # marker
      ( # single character content
        [\u00BF-\u1FFF\u2C00-\uD7FFa-zA-Z0-9] # word
      | # multi character content
        [\u00BF-\u1FFF\u2C00-\uD7FFa-zA-Z0-9] # word
        (?: # optional nested marker
          (\*{1,2})
          [\s\S]*? # any
          \3
        | # optional multiple characters
          [\s\S]*? # any
        )*?
        [^\s*_~=`^] # no whitespace or marker
      )
      \1 # end marker
    ///
    fn: evalWord

  starPunct:
    state: ['m-inline']
    re: ///
      ^(\*) # marker
      ( # content as single character
        [*_~=`^]*
        [!"#$%&\'()+,.\/:;<>?@[\\\]{|}-] # white or punct
      | # multi character content
        [*_~=`^]*
        [\ \t!"#$%&\'()+,.\/:;<>?@[\\\]{|}-] # white or punct
        (?: # optional nested marker
          (\*{1,2})
          [\s\S]*? # any
          \3
        | # optional multiple characters
          [\s\S]*? # any
          [!"#$%&\'()*+,.\/:;<=>?@[\\\]^`{|}~-] # punct
        )+?
      )
      \1 # end marker
      (?= # following but not included
        [*_~=`^]*
        [\ \t!"#$%&\'()+,.\/:;<>?@[\\\]{|}-] # white or punct
      | $ # end of document
      )
    ///
    fn: evalWord

  underWord:
    state: ['m-inline']
    re: ///
      ^(_) # marker
      ( # single character content
        [*_~=`^]* # possible marker
        [\u00BF-\u1FFF\u2C00-\uD7FFa-zA-Z0-9] # word
      | # multi character content
        [*_~=`^]* # possible marker
        [\u00BF-\u1FFF\u2C00-\uD7FFa-zA-Z0-9] # word
        (?: # optional multiple characters
          (_{1,2})
          [\s\S]*? # any
          \3
        |
          [\s\S]*? # any
        )*?
        [^\s*_~=`^] # no whitespace or marker
      )
      \1 # end marker
      (?= # following but not included
        [\ \t!"#$%&\'()*+,.\/:;<=>?@[\\\]^`{|}~-] # white or punct
      | $ # end of document
      )
    ///
    fn: evalWord

  underPunct:
    state: ['m-inline']
    re: ///
      ^(_) # marker
      ( # content as single character
        [*_~=`^]*
        [!"#$%&\'()+,.\/:;<>?@[\\\]{|}-] # white or punct
      | # multi character content
        [*_~=`^]*
        [\ \t!"#$%&\'()+,.\/:;<>?@[\\\]{|}-] # white or punct
        (?: # optional multiple characters
          (_{1,2})
          [\s\S]*? # any
          \S
          [\s\S]*? # any
          \3
        |
          [\s\S]*? # any
          [!"#$%&\'()*+,.\/:;<=>?@[\\\]^`{|}~-] # punct
        )+?
      )
      \1 # end marker
      (?= # following but not included
        [\ \t!"#$%&\'()*+,.\/:;<=>?@[\\\]^`{|}~-] # white or punct
      | $ # end of document
      )
    ///
    fn: evalWord
