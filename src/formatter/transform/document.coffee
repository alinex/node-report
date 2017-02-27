# Document
# =================================================


moment = require 'moment'
util = require 'alinex-util'


# Transformer rules
#
# @type {Object<Transformer>} rules to set output text in token
module.exports =

  html:
    format: 'html'
    type: 'document'
    fn: (num, token) ->
      nl = if @setup.compress then '' else '\n'
      # write output
      token.out = switch token.nesting
        when 1
          "<!DOCTYPE html>#{nl}\
          <html>#{nl}\
          <head><title>#{token.title}</title>#{@setup.head_end}#{nl}\
          #{@setup.body_begin}#{nl}\
          "
        when -1
          "#{@setup.body_end}#{nl}\
          </html>"

  roff:
    format: 'roff'
    type: 'document'
    nesting: 1
    fn: (num, token) ->
      return unless token.title?
      token.out = ".TH \"#{token.title?.toUpperCase()}\" \"\"
      \"#{moment().format 'MMMM YYYY'}\" \"\" \"\"\n"

  text:
    format: 'text'
    type: 'document'
    fn: (num, token) ->
      # write output
      token.out = switch token.nesting
        when 1 then @setup.begin ? ''
        when -1 then @setup.end ? ''

  latex:
    format: 'latex'
    type: 'document'
    fn: (num, token) ->
      # write output
      token.out = switch token.nesting
        when 1
          """
          \\documentclass{article}
          \\title{#{token.title}}
          \\begin{document}
          """
        when -1
          "\n\\end{document}"

  rtf:
    format: 'rtf'
    type: 'document'
    fn: (num, token) ->
      # write output
      token.out = switch token.nesting
        when 1
          "{\\rtf1"
        when -1
          "}"

  textFooter:
    format: ['md', 'text']
    type: 'document'
    nesting: -1
    fn: (num, token) ->
      doc = @tokens.data[0]
      return unless doc.linkNames
      list = Object.keys doc.linkNames
      list.sort()
      # write output
      token.out = ''
      maxlen = 0
      for n in list
        maxlen = n.length if n.length > maxlen
      for n in list
        link = doc.linkNames[n]
        token.out += "\n" + util.string.rpad("[#{n}]:", maxlen + 3) + " <#{link[0]}>"
        token.out += " \"#{link[1].replace /(")/g, '\\$1'}\"" if link[1]
