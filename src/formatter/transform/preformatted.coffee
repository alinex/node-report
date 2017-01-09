# Headings
# =================================================

util = require 'alinex-util'


# Transformer rules
#
# @type {Object<Transformer>} rules to set output text in token
module.exports =

  markdown:
    format: 'md'
    type: 'preformatted'
    fn: (num, token) ->
      token.out = "#{util.string.repeat '-', @setup.width}\n"

  text:
    format: 'text'
    type: 'preformatted'
    fn: (num, token) ->
      token.out = "#{util.string.repeat '─', @setup.width}\n"

  html:
    format: 'html'
    type: 'preformatted'
    fn: (num, token) ->
      nl = if @setup.compress then '' else '\n'
      token.out = "<pre><code>#{token.data.text}</code></pre>#{nl}"
      nl = if @setup.compress then '' else '\n'
      token.out = switch token.nesting
        when 1 then "<p>"
        when -1 then "</p>#{nl}"
        else "<p />#{nl}"

  roff:
    format: 'roff'
    type: 'preformatted'
    fn: (num, token) ->
      token.out = ".HR\n"
