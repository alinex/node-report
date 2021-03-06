# Headings
# =================================================


# Transformer rules
#
# @type {Object<Transformer>} rules to set output text in token
module.exports =

  md:
    format: 'md'
    type: 'preformatted'
    fn: (num, token) ->
      token.out = "\n"

  html:
    format: 'html'
    type: 'preformatted'
    fn: (num, token) ->
      nl = if @setup.compress then '' else '\n'
      token.out = switch token.nesting
        when 1 then "<pre#{@htmlAttribs token}><code>"
        when -1 then "</code></pre>#{nl}"
        else "<pre#{@htmlAttribs token}><code></code></pre>#{nl}"

  roff:
    format: 'roff'
    type: 'preformatted'
    fn: (num, token) ->
      token.out = switch token.nesting
        when 1 then ".P\n.RS 2\n.nf\n"
        when -1 then "\n.fi\n.RE\n"
