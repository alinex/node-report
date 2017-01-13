# Headings
# =================================================


# Transformer rules
#
# @type {Object<Transformer>} rules to set output text in token
module.exports =

  markdown:
    format: ['md', 'text']
    type: 'blockquote'
    fn: (num, token) ->
      return unless token.nesting is 1
      token.out = '> '

  html:
    format: 'html'
    type: 'blockquote'
    fn: (num, token) ->
      nl = if @setup.compress then '' else '\n'
      token.out = switch token.nesting
        when 1 then "<blockquote>"
        when -1 then "</blockquote>#{nl}"
        else "<blockquote />#{nl}"
