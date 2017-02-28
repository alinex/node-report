# Table
# =================================================


# Table rules
#
# @type {Object<Transformer>} rules to set output text in token
module.exports =

  # add column number to cells and align
  row:
    format: ['md', 'text', 'html']
    type: 'tr'
    nesting: 1
    fn: (num, token) ->
      n = num
      col = 0
      table = token.parent.parent
      table.align ?= []
      loop
        next = @tokens.data[++n]
        break if next.level <= token.level
        continue if next.level isnt token.level + 1
        continue if next.nesting isnt 1
        next.col = ++col
        # collect align
        continue unless next.type is 'th'
        table.align[col] = next.align ? 'left'
      # set column number in table
      table.col = col if col > (table.col ? 0)
