# Table
# =================================================


util = require 'alinex-util'


max = (a, b) -> if not(a) or a < b then b else a

# Transformer rules
#
# @type {Object<Transformer>} rules to set output text in token
module.exports =

  md_th:
    format: 'md'
    type: 'th'
    fn: (num, token) ->
      token.collect = token.collect.replace /\|/g, '\\|'

  md_td:
    format: 'md'
    type: 'td'
    fn: (num, token) ->
      token.collect = token.collect.replace /\|/g, '\\|'

  # fix display width
  md_table:
    format: 'md'
    type: 'table'
    fn: (num, token) ->
      # get column width
      width = []
      n = num
      loop
        next = @tokens.data[++n]
        break if next.level <= token.level
        continue if next.level isnt token.level + 3
        continue if next.nesting isnt 1
        width[next.col] = max width[next.col], next.collect.length
      # optimize cells
      n = num
      loop
        next = @tokens.data[++n]
        break if next.level <= token.level
        # fix width of header separator line
        if next.level is token.level + 1 and next.nesting is -1 and next.type is 'thead'
          cols = next.out.split /\|/
          for i in [1..token.col]
            cols[i] = cols[i].replace /-/, util.string.repeat '-', width[i]
          next.out = cols.join '|'
          continue
        continue if next.level isnt token.level + 3
        continue if next.nesting isnt 1
        next.collect = switch token.align[next.col]
          when 'left' then util.string.rpad next.collect, width[next.col]
          when 'center' then util.string.cpad next.collect, width[next.col]
          when 'right' then util.string.lpad next.collect, width[next.col]
      # recollect data
      loop
        next = @tokens.data[--n]
        break if next.level <= token.level
        continue if next.nesting isnt 1
        continue if next.level > token.level + 2
        @tokens.collect n, next
      @tokens.collect num, token
