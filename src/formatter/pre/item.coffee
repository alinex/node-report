# List Item
# =================================================


# Transformer rules
#
# @type {Object<Transformer>} rules to set output text in token
module.exports =

  other:
    format: ['md', 'text', 'roff']
    type: 'item'
    nesting: 1
    fn: (num, token) ->
      list = token.parent
      list.start ?= 1
      list.count ?= 0
      token.num = list.start + list.count++
