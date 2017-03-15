# Style settings
# =================================================


util = require 'alinex-util'


shortcut =
  q: 'blockquote'
  b: 'strong'
  bold: 'strong'
  em: 'emphasis'
  italic: 'emphasis'
  tt: 'fixed'
  h: 'heading'
  img: 'image'
  a: 'link'
  ul: 'list'
  ol: 'list'
  li: 'item'
  p: 'paragraph'
  pre: 'preformatted'
  s: 'strikethrough'
  hr: 'thematic_break'


# Transformer rules
#
# @type {Object<Transformer>} rules to set output text in token
module.exports =

  html:
    format: 'html'
    type: 'style'
    fn: (num, token) ->
      return unless token.format is 'html'
      # extract style information
      html = {}
      [_, target, depth, attrs] = token.content.match ///
        ^:?\s*     # kramdown syntax
        (?:
          (\w+)     # 1: target
          (\^\d*)?  # 2: negative offset
        :\s*)?
        ([\s\S]*)   # 3: attributes
        $
      ///
      if depth
        depth = if depth is '^' then 1 else Number depth.substr 1
      if target
        target = shortcut[target] ? target
      while attrs.length
        if m = attrs.match /^\s*\.([\w-]+)/
          html['class'] ?= []
          html['class'].push m[1]
        else if m = attrs.match /^\s*#([\w-]+)/
          html['id'] = m[1]
        else if m = attrs.match /^\s*([\w-]+)="([^"]*)"/
          html[m[1]] = m[2]
        else if m = attrs.match /^\s*([\w-]+)='([^']*)'/
          html[m[1]] = m[2]
        else if m = attrs.match /^\s*([\w-]+)=([^\ ]*)/
          html[m[1]] = m[2]
        else if m = attrs.match /^\s*([\w-]+)/
          html[m[1]] = ''
        else break
        attrs = attrs.substr m[0].length
      # find target and apply
      prev = []
      n = num
      while n
        t = @tokens.get --n
        continue if t.nesting isnt 1 and t.type not in ['thematic_break']
        prev.push t
      if target
        prev = prev.filter (e) -> e.type is target
      if target = prev[depth ? 0]
        util.extend target,
          html: html
