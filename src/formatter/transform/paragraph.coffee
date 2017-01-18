# Headings
# =================================================


# Transformer rules
#
# @type {Object<Transformer>} rules to set output text in token
module.exports =

  html:
    format: 'html'
    type: 'paragraph'
    fn: (num, token) ->
      nl = if @setup.compress then '' else '\n'
      token.out = switch token.nesting
        when 1 then "<p>"
        when -1 then "</p>#{nl}"
        else "<p />#{nl}"

  roff:
    format: 'roff'
    type: 'paragraph'
    nesting: 1
    fn: (num, token) ->
      token.out = '.P\n'

  other:
    format: ['md', 'text', 'adoc']
    type: 'paragraph'
    fn: (num, token) ->
      token.out = '\n'
