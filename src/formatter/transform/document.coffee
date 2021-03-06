# Document
# =================================================


moment = require 'moment'
fs = require 'fs'
deasync = require 'deasync'
async = require 'async'
util = require 'alinex-util'
Config = require 'alinex-config'


stylesCache = {}


# Helper
# ------------------------------------------------

# @param {Object} setup of the html format
# @return {String} to be included in head section
htmlStyle = deasync (setup, cb) ->
  nl = if setup.compress then '' else '\n'
  Config.typeSearch 'template', (err, map) ->
    return cb err if err
    async.map util.array.unique(setup.style), (style, cb) ->
      url = if typeof style is 'object' then style.url else style
      return cb null, stylesCache[url] if stylesCache[url]
      # external reference
      unless map[url]
        stylesCache[url] = if typeof style is 'object'
          attr = Object.keys(style).map (k) -> "#{k}=\"#{style[k]}\""
          .join ' '
          "<link rel=\"stylesheet\" #{attr} />#{nl}"
        else
          "<link rel=\"stylesheet\" href=\"#{url}\" />#{nl}"
        return cb null, stylesCache[url]
      # include internal style
      fs.readFile map[style], 'utf8', (err, content) ->
        return cb err if err
        stylesCache[style] = "<style type=\"text/css\">#{content}</style>#{nl}"
        cb null, stylesCache[url]
    , (err, results) ->
      cb err, results.join ''


# Transformer rules
# ------------------------------------------------
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
          headBegin = @setup.head_begin
          if token.html?.lang
            headBegin = headBegin.replace /<html>/, "<html lang=\"#{token.html.lang}\">"
          header = headBegin + nl
          header += "<title>#{token.html?.title ? token.title}</title>#{nl}"
          header += htmlStyle @setup
          header += "#{@setup.head_end}#{nl}\
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
      #console.log token.out
