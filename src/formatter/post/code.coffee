# Headings
# =================================================


hljs = null # load on demand


# Transformer rules
#
# @type {Object<Transformer>} rules to set output text in token
module.exports =

  md:
    format: 'md'
    type: 'code'
    fn: (num, token) ->
      marker1 = '```'
      marker2 = '~~~'
      loop
        unless ~token.collect.indexOf marker1
          marker = marker1
          break
        unless ~token.collect.indexOf marker2
          marker = marker2
          break
        marker1 += '`'
        marker2 += '~'
      token.out = "#{marker} #{token.language}\n"
      token.collect = "#{token.collect}\n#{marker}\n"

  html:
    format: 'html'
    type: 'code'
    fn: (num, token) ->
      # syntax highlighting
      hljs ?= require 'highlight.js'
      return unless hljs.getLanguage token.language
      try
        token.collect = hljs.highlight(token.language, token.collect, true).value
      # brek code on newlines
      token.collect = token.collect.replace /\n/g , '</code>\n<code>'
