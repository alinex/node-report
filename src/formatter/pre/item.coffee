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
      list = token.parent.data
      list.count ?= 0
      token.data ?= {}
      token.data.num = list.start + list.count++
