# List Item
# =================================================


# Transformer rules
#
# @type {Object<Transformer>} rules to set output text in token
module.exports =

  html:
    format: 'html'
    type: 'item'
    fn: (num, token) ->
      list = token.parent.data
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
      list = token.parent.data
      token.out = switch list.list
        when 'bullet'
          switch token.nesting
            when 1 then '.IP \\(bu 2\n'
            when -1 then '\n'
        when 'ordered'
          switch token.nesting
            when 1 then ".IP #{token.data.num}. 3\n"
            when -1 then '\n'

  other:
    format: ['md', 'text', 'adoc']
    type: 'item'
    fn: (num, token) ->
      list = token.parent.data
      token.out = switch list.list
        when 'bullet'
          switch token.nesting
            when 1 then '- '
            when -1 then '\n'
        when 'ordered'
          switch token.nesting
            when 1 then "#{token.data.num}. "
            when -1 then '\n'
