# Code
# =================================================


Config = require 'alinex-config'
util = require 'alinex-util'


# Transformer rules
#
# @type {Object<Transformer>} rules to set output text in token
module.exports =

  html:
    format: 'html'
    type: 'code'
    fn: (num, token) ->
      nl = if @setup.compress then '' else '\n'
      # create output
      token.out = switch token.nesting
        when 1
          util.extend token,
            html:
              class: ['language', token.language]
          "<pre#{@htmlAttribs token}>\
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
