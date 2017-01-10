# Headings
# =================================================


# Transformer rules
#
# @type {Object<Transformer>} rules to set output text in token
module.exports =

  markdown:
    format: ['md', 'text']
    type: 'preformatted'
    fn: (num, token) ->
      return unless token.nesting is 1
      # indent with four spaces on start
      token.out = '    '

  html:
    format: 'html'
    type: 'preformatted'
    fn: (num, token) ->
      nl = if @setup.compress then '' else '\n'
      token.out = switch token.nesting
        when 1 then "<pre><code>"
        when -1 then "</code></pre>#{nl}"
        else "<pre><code></code></pre>#{nl}"
