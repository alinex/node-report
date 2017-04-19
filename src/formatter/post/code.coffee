# Headings
# =================================================


chalk = require 'chalk'
hljs = null # load on demand
util = require 'alinex-util'


# Setup ansi colors
# -------------------------------------------------
colors =
  comment: chalk.gray
  quote: chalk.gray

  subst: chalk.red.bold
  'selector-tag': chalk.red.bold
  'builtin-name': chalk.red.bold
  section: chalk.red.bold
  name: chalk.red.bold
  deletion: chalk.red.bold

  class: chalk.magenta
  doctag: chalk.magenta
  formula: chalk.magenta
  keyword: chalk.magenta.bold

  variable: chalk.yellow
  number: chalk.yellow
  attr: chalk.yellow
  type: chalk.yellow
  'selector-class': chalk.yellow
  'selector-attr': chalk.yellow
  'selector-pseudo': chalk.yellow
  'template-variable': chalk.yellow
  built_in: chalk.yellow.bold
  title: chalk.yellow.bold

  string: chalk.green
  attribute: chalk.green
  regexp: chalk.green.bold
  addition: chalk.green.bold

  bullet: chalk.blue.bold

  function: chalk.cyan
  literal: chalk.cyan.bold
  link: chalk.cyan.bold
  symbol: chalk.cyan.bold
  'selector-id': chalk.cyan.bold
  meta: chalk.cyan
  'meta-keyword': chalk.cyan.bold

  code: chalk.white.bold
  _: chalk.white.bold
  params: chalk.white.bold
  'template-tag': chalk.white.bold
  xml: chalk.white
  tag: chalk.white

  strong: chalk.bold
  emphasis: chalk.italic


# Exports
# -------------------------------------------------

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
      token.out = "\n#{marker} #{token.language}\n"
      token.collect = "#{token.collect}\n#{marker}\n"

  text:
    format: 'text'
    type: 'code'
    fn: (num, token) ->
      if @setup.ansi_escape
        # syntax highlighting
        hljs ?= require 'highlight.js'
        unless hljs.getLanguage token.language
          console.error "Could not highlight #{token.language} language!"
        else
          try
            chalk = new chalk.constructor {enabled: true}
            token.collect = hljs.highlight token.language, token.collect, true
            .value
            .replace /<span class="hljs-([\w-]+)">([^<]*?)<\/span>/g, (_, e, c) ->
              if colors[e] then colors[e] c else "<<<=== #{e}: #{c}===>>>"
            .replace /<span class="hljs-([\w-]+)">([^<]*?)<\/span>/g, (_, e, c) ->
              if colors[e] then colors[e] c else "<<<=== #{e}: #{c}===>>>"
            .replace /<span class="hljs-([\w-]+)">([^<]*?)<\/span>/g, (_, e, c) ->
              if colors[e] then colors[e] c else "<<<=== #{e}: #{c}===>>>"
            .replace /<span class="\w+">([^<]*?)<\/span>/g, '$1'
          token.collect = util.string.htmlDecode token.collect
      # indent
      token.collect = '    ' + token.collect.replace /\n/g, "\n    " # indent text

  html:
    format: 'html'
    type: 'code'
    fn: (num, token) ->
      # syntax highlighting
      hljs ?= require 'highlight.js'
      unless hljs.getLanguage token.language
        console.error "Could not highlight #{token.language} language!"
        return
      try
        token.collect = hljs.highlight(token.language, token.collect, true).value
      # break code on newlines
      token.collect = token.collect
      .replace ///
        (<span.*?>)
        (
          [\s\S]*?
          <span\ class="hljs-doctag">@\w+</span>
          [\s\S]*?
        )
        <\/span>
        ///g, (_, span, text) ->
        span + text.replace(/\n/g, "</span>\n#{span}") + '</span>'
      .replace /\n/g, '</code>\n<code>'
