# Headings
# =================================================


# Transformer rules
#
# @type {Object<Transformer>} rules to set output text in token
module.exports =

  strong_md:
    format: 'md'
    type: 'strong'
    fn: (num, token) -> token.out = '**'

  strong_html:
    format: 'html'
    type: 'strong'
    fn: (num, token) ->
      token.out = if token.nesting is -1 then '<strong>' else '</strong>'

  emphasis_md:
    format: 'md'
    type: 'emphasis'
    fn: (num, token) -> token.out = '*'

  emphasis_html:
    format: 'html'
    type: 'emphasis'
    fn: (num, token) ->
      token.out = if token.nesting is -1 then '<em>' else '</em>'
