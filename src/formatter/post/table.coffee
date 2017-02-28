# Table
# =================================================


util = require 'alinex-util'
chalk = require 'chalk'


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
    format: ['md', 'text']
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
        if next.level is token.level + 1 and next.type in ['thead', 'tbody']
          continue unless next.out
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

  # add ascii art
  text_table:
    format: 'text'
    type: 'table'
    fn: (num, token) ->
      return unless @setup.ascii_art
      lines = token.collect.split /\n/
      for line, num in lines
        switch num
          when 0
            lines[num] = "┏#{line[1..-2]}┓"
            .replace /-/g, '━'
          when 2
            lines[num] = "┠#{line[1..-2]}┨"
            .replace /-/g, '─'
          when lines.length - 2
            lines[num] = "┗#{line[1..-2]}┛"
            .replace /-/g, '━'
          when lines.length - 1
            continue
          else
            lines[num] = "┃#{line[1..-2]}┃"
      while m = lines[0].match /\|/
        for line, num in lines
          switch num
            when 0
              lines[num] = "#{lines[num][0..m.index-1]}┯#{lines[num][m.index+1..]}"
            when 2
              lines[num] = "#{lines[num][0..m.index-1]}┼#{lines[num][m.index+1..]}"
            when lines.length - 2
              lines[num] = "#{lines[num][0..m.index-1]}┷#{lines[num][m.index+1..]}"
            when lines.length - 1
              continue
            else
              lines[num] = "#{lines[num][0..m.index-1]}│#{lines[num][m.index+1..]}"
      if @setup.ansi_escape
        for line, num in lines
          if 2 < num < lines.length - 2 and num % 2 is 0
            lines[num] = "#{line[0]}#{chalk.bgBlue line[1..-2]}#{line[-1..]}"
#            lines[num] = chalk.bgBlack.yellow lines[num]
      # rejoin content
      token.collect = lines.join '\n'
