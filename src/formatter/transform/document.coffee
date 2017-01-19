# Headings
# =================================================


moment = require 'moment'


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
          <head><title>#{token.data?.title}</title>#{@setup.head_end}#{nl}\
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
      return unless token.data?.title?
      token.out = ".TH \"#{token.data?.title.toUpperCase()}\" \"\"
      \"#{moment().format 'MMMM YYYY'}\" \"\" \"\""

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
          \\title{#{token.data?.title}}
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
