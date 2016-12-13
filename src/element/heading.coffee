
parser = null

exports.lexer =

  markdown:
    re: /^(\n*(#{1,6}) )([^\n]+)(?:\n|$)/
    token: (m) ->
      # opening
      tokens = [
        nesting: 1
        data: m[2].length
      ]
      # parse subtext
      parser ?= require '../parser'
      tokens = tokens.concat parser('markdown', m[3]).map (e) =>
        e.index += @index + m[1].length
      # closing
      tokens.push
        nesting: -1
        data: m[2].length
        index: @index + m[1].length + m[3].length

  html:
    re: /^<(\/)h([1-6])>/
    token: (m) ->
      nesting: if m[1] then -1 else 1
      data: parseInt m[2]

exports.pre = {}

exports.transform = {}

exports.post = {}
