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

replace = (source, re) ->
  loop
    console.log '<<<<<<<<< replace >>>>>>>>>>'
    console.log "'#{source}'.match", re
    text = null
    while m = re.exec source
      text = source[0..m.index-1] if m.index
      text += "<#{MARKER[m[1]]}>#{m[2]}</#{MARKER[m[1]]}>"
      if m.index + m[0].length < source.length
        text += source[m.index+m[0].length..]
      source = text
    break unless text

replace2 = (num, token, re) ->
  pos = 0
  console.log '<<<<<<<<< replace >>>>>>>>>>'
  console.log "'#{token.data.text}'.match", re
  while m = re.exec token.data.text
    console.log '-->', m
    # remove original
    @remove num unless pos
    # insert pre text
    if pos < m.index
      @insert num++,
        type: 'text'
        data:
          text: token.data.text[pos..m.index-1]
      pos = m.index
    # insert tokens
    @insert num++,
      type: MARKER[m[1]]
      nesting: 1
    @insert num++,
      type: 'text'
      data: {text: m[2]}
    @insert num++,
      type: MARKER[m[1]]
      nesting: -1
    pos += m[0].length
  # insert post text
  if pos and pos < token.data.text.length
    @insert num,
      type: 'text'
      data:
        text: token.data.text[pos..]


re =
  underscore: ///
    (_{1,2})
    (
      [\u00BF-\u1FFF\u2C00-\uD7FFa-zA-Z0-9] # word
    |
      [\u00BF-\u1FFF\u2C00-\uD7FFa-zA-Z0-9] # word
      (?: # optional nested marker
        (__)
        [\u00BF-\u1FFF\u2C00-\uD7FFa-zA-Z0-9] # word
        [^_]*? # any
        [\u00BF-\u1FFF\u2C00-\uD7FFa-zA-Z0-9] # word
        \3
      | # optional multiple characters
        [^_]*? # any
        [^\s*_~=`^] # no whitespace or marker
      )*
      [\u00BF-\u1FFF\u2C00-\uD7FFa-zA-Z0-9] # word
    )
    \1
  ///g


# Export Transformer rules
# ----------------------------------------------
#
# @type {Object<Transformer>} rules to transform text into tokens
module.exports =

  emphasis:
    type: 'text'
    state: 'm-inline'
    fn: (num, token) ->
      replace.call this, token.data.text, re.underscore
      addTokens.call this, num, token
