# Strikethrough
# =================================================


# Transformer rules
#
# @type {Object<Transformer>} rules to set output text in token
module.exports =

  html:
    format: 'html'
    type: 'strikethrough'
    fn: (num, token) ->
      token.out = switch token.nesting
        when 1 then "<s>"
        when -1 then "</s>"
        else "<s></s>"

  other:
    format: ['md', 'text']
    type: 'strikethrough'
    fn: (num, token) ->
      token.out = '~~'
