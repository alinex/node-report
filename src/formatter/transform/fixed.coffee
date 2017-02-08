# Headings
# =================================================


# Transformer rules
#
# @type {Object<Transformer>} rules to set output text in token
module.exports =

  html:
    format: 'html'
    type: 'fixed'
    fn: (num, token) ->
      token.out = switch token.nesting
        when 1 then "<code>"
        when -1 then "</code>"
        else "<code></code>"

  roff:
    format: 'roff'
    type: 'fixed'
    fn: (num, token) ->
      token.out = switch token.nesting
        when 1 then ".P\n.RS 2\n.nf\n"
        when -1 then ".fi\n.RE\n"
