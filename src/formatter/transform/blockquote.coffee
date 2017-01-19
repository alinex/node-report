# Headings
# =================================================


# Transformer rules
#
# @type {Object<Transformer>} rules to set output text in token
module.exports =

  html:
    format: 'html'
    type: 'blockquote'
    fn: (num, token) ->
      nl = if @setup.compress then '' else '\n'
      token.out = switch token.nesting
        when 1 then "<blockquote>"
        when -1 then "</blockquote>#{nl}"
        else "<blockquote />#{nl}"

  roff:
    format: 'roff'
    type: 'blockquote'
    fn: (num, token) ->
      token.out = if token.nesting is 1 then '.P\n.RS 2\n.nf\n' else '.fi\n.RE\n'
