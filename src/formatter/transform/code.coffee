# Code
# =================================================


Config = require 'alinex-config'


# Transformer rules
#
# @type {Object<Transformer>} rules to set output text in token
module.exports =

  html:
    format: 'html'
    type: 'code'
    fn: (num, token) ->
      nl = if @setup.compress then '' else '\n'
      token.out = switch token.nesting
        when 1 then "<pre class=\"lamguage #{token.language}\">\
        <header>#{Config.get('/report/code/title')[token.language] ? token.language}</header>\
        <code>"
        when -1 then "</code></pre>#{nl}"
        else "<pre><code></code></pre>#{nl}"

  roff:
    format: 'roff'
    type: 'code'
    fn: (num, token) ->
      token.out = switch token.nesting
        when 1 then ".P\n.RS 2\n.nf\n"
        when -1 then "\n.fi\n.RE\n"
