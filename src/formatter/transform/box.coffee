# Headings
# =================================================


# Transformer rules
#
# @type {Object<Transformer>} rules to set output text in token
module.exports =

  md:
    format: 'md'
    type: 'box'
    fn: (num, token) ->
      token.out = switch token.nesting
        when 1
          if token.box then "\n::: #{token.box} #{token.title}" else "\n:::"
        when -1
          unless token.concat then ':::\n' else ''

  html:
    format: 'html'
    type: 'md'
    fn: (num, token) ->
      nl = if @setup.compress then '' else '\n'
      token.out = switch token.nesting
        when 1 then "<pre#{@htmlAttribs token}><code>"
        when -1 then "</code></pre>#{nl}"
        else "<pre#{@htmlAttribs token}><code></code></pre>#{nl}"
