# List
# =================================================


util = require 'alinex-util'


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
            when 1 then "<ul#{@htmlAttribs token}>#{nl}"
            when -1 then "</ul>#{nl}"
            else "<ul#{@htmlAttribs token} />#{nl}"
        when 'ordered'
          if token.start > 1
            util.extend token,
              html:
                start: token.start
          switch token.nesting
            when 1 then "<ol#{@htmlAttribs token}>#{nl}"
            when -1 then "</ol>#{nl}"
            else "<ol#{@htmlAttribs token} />#{nl}"

  roff:
    format: 'roff'
    type: 'list'
    fn: (num, token) ->
      token.out = switch token.list
        when 'bullet', 'ordered'
          switch token.nesting
            when 1 then '.RS 0\n'
            when -1 then '\n\n.RE\n'

  md:
    format: 'md'
    type: 'list'
    fn: (num, token) ->
      pos = num - 1
      prev = @tokens.get pos
      if prev.type is 'list' and prev.nesting is -1
        while pos--
          prev = @tokens.get pos
          break if prev.type is 'list' and prev.level is token.level
        unless prev.marker
          token.marker = if token.list is 'bullet' then '+' else ')'
      # add needed newline if ordered list start with specific number
      token.out = '\n' if token.list is 'ordered' and token.start > 1
