# List
# =================================================


# Transformer rules
#
# @type {Object<Transformer>} rules to set output text in token
module.exports =

  html:
    format: 'html'
    type: 'list'
    fn: (num, token) ->
      nl = if @setup.compress then '' else '\n'
      token.out = switch token.list
        when 'bullet'
          switch token.nesting
            when 1 then "<ul>#{nl}"
            when -1 then "</ul>#{nl}"
            else "<ul />#{nl}"
        when 'ordered'
          switch token.nesting
            when 1 then "<ol>#{nl}"
            when -1 then "</ol>#{nl}"
            else "<ol />#{nl}"
        when 'definition'
          switch token.nesting
            when 1 then "<dl>#{nl}"
            when -1 then "</dl>#{nl}"
            else "<dl />#{nl}"

  roff:
    format: 'roff'
    type: 'list'
    fn: (num, token) ->
      token.out = switch token.list
        when 'bullet', 'ordered'
          switch token.nesting
            when 1 then '.RS 0\n'
            when -1 then '\n\n.RE\n'
