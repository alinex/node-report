# Blockquote
# =================================================


util = require 'alinex-util'


# Transformer rules
#
# @type {Object<Transformer>} rules to set output text in token
module.exports =

  container_count:
    format: 'html'
    type: 'container'
    nesting: 1
    fn: (num, token) ->
      token.count = 0
      @containerCount ?= 0
      token.num = ++@containerCount

  box_count:
    format: 'html'
    type: 'box'
    nesting: 1
    fn: (num, token) ->
      token.num = ++token.parent.count

  container_indent:
    format: 'text'
    type: 'container'
    nesting: 1
    fn: (num, token) ->
      token.indent = (token.parent.indent ? 0) + 4
      token.count = 0

  box_indent:
    format: 'text'
    type: 'box'
    nesting: 1
    fn: (num, token) ->
      token.indent = token.parent.indent

  html_container:
    format: 'html'
    type: 'container'
    fn: (num, token) ->
      util.extend token,
        html:
          class: ['box-container']
      nl = if @setup.compress then '' else '\n'
      token.out = switch token.nesting
        when 1 then "<div#{@htmlAttribs token, ['selected', 'size']}>#{nl}"
        when -1 then "</div>#{nl}"

  html_box:
    format: 'html'
    type: 'box'
    fn: (num, token) ->
      if token.nesting is 1
        util.extend token,
          html:
            class: ['box', "box#{token.num}", token.box]
        # check for compressed display
        showCompressed = true
        n = num
        tags = ['preformatted', 'code', 'table']
        loop
          t = @tokens.get ++n
          continue if t.level > token.level + 1 # to deep
          break if t.level is token.level
          continue unless t.nesting is 1
          unless t.type in tags
            showCompressed = false
            break
          tags = []
        token.html.class.push 'pre' if showCompressed
      # output box
      nl = if @setup.compress then '' else '\n'
      token.out = switch token.nesting
        when 1 then "<div#{@htmlAttribs token, ['selected']}>#{nl}"
        when -1 then "</div>#{nl}"
