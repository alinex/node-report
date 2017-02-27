# List Item
# =================================================


# Node Modules
# --------------------------------------------------
util = require 'alinex-util'


# Transformer rules
#
# @type {Object<Transformer>} rules to set output text in token
module.exports =

  html:
    format: 'html'
    type: 'item'
    fn: (num, token) ->
      list = token.parent
      nl = if @setup.compress then '' else '\n'
      token.out = switch list.list
        when 'bullet'
          switch token.nesting
            when 1 then "<li>"
            when -1 then "</li>#{nl}"
            else "<li />#{nl}"
        when 'ordered'
          switch token.nesting
            when 1 then "<li>"
            when -1 then "</li>#{nl}"
            else "<li />#{nl}"
        when 'definition'
          switch token.nesting
            when 1 then "<dt>#{list.title}</dt>#{nl}<dd>"
            when -1 then "</dd>#{nl}"
            else "<dt /><dd />#{nl}"

  roff:
    format: 'roff'
    type: 'item'
    fn: (num, token) ->
      list = token.parent
      token.out = switch list.list
        when 'bullet'
          switch token.nesting
            when 1 then '.IP \\(bu 2\n'
            when -1 then '\n'
        when 'ordered'
          switch token.nesting
            when 1 then ".IP #{token.num}. 3\n"
            when -1 then '\n'

  md:
    format: ['md']
    type: 'item'
    fn: (num, token) ->
      list = token.parent
      token.out = switch list.list
        when 'bullet'
          marker = list.marker ? '-'
          switch token.nesting
            when 1 then "   #{marker} "
        when 'ordered'
          marker = list.marker ? '.'
          switch token.nesting
            when 1 then "#{util.string.lpad token.num, 3}#{marker} "

  other:
    format: ['text']
    type: 'item'
    fn: (num, token) ->
      list = token.parent
      token.out = switch list.list
        when 'bullet'
          # color dependent of depth
          depth = 0
          p = token
          while p = p.parent
            depth++ if p.type is 'list'
          marker = if @setup.ascii_art
            switch depth
              when 1 then '⭘'
              when 2 then '‣'
              when 3 then '•'
              else '·'
          else
            list.marker ? '.'
          # make bullet
          switch token.nesting
            when 1 then "   #{marker} "
        when 'ordered'
          marker = list.marker ? '.'
          switch token.nesting
            when 1 then "#{util.string.lpad token.num, 3}#{marker} "
