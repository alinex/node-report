# Markdown Parser
# =================================================
# This module is using the [markdownIt](http://markdown-it.github.io) parser which
# is base on [CommonMark Specification](http://spec.commonmark.org).


# Node Modules
# -------------------------------------------------
debug = require('debug') 'report:parse:markdown'
chalk = require 'chalk'
markdownIt = null # load on demand
deflistPlugin = null # load on demand
tasksPlugin = null # load on demand
containerPlugin = null # load on demand
# include more alinex modules
util = require 'alinex-util'
Config = require 'alinex-config'


# Public
# -------------------------------------------------

# Add markdown to report.
#
# @param {String} text to be parsed
# @return {Report} instance itself for command concatenation
module.exports = (text) ->
  debug "parse and add: #{chalk.bold.yellow util.inspect text}"
  # init markdown-it
  unless markdownIt
    config = Config.get '/report/parser/md'
    containerPlugin ?= require 'markdown-it-container'
    markdownIt = require('markdown-it')
      html: config.html
      linkify: config.linkify
    .use tasksPlugin ?= require './tasks'
    .use deflistPlugin ?= require 'markdown-it-deflist'
    .use containerPlugin, 'detail'
    .use containerPlugin, 'info'
    .use containerPlugin, 'ok'
    .use containerPlugin, 'warning'
    .use containerPlugin, 'alert'
#      typographer: true
  # parse and convert tokens
  tree = markdownIt.parse text, {} # empty env
  @tokens.insert optimize tree2tokens tree
  this


# Internal Helper
# -------------------------------------------------

# Specify changes for the markdown-it tokens to be done before inserting.
# This will match the name including ..._open or also without it.
modify =

  text: (t) -> if t.content then t else []

  heading: (t) -> t.heading = Number t.tag[1]

  hr: (t) -> t.type = 'thematic_break'

  em: (t) -> t.type = 'emphasis'

  s: (t) -> t.type = 'strikethrough'

  bullet_list: (t) ->
    t.type = 'list'
    t.list = 'bullet'

  ordered_list: (t) ->
    t.type = 'list'
    t.list = 'ordered'
    t.start = 1
    if t.attrs
      for a in t.attrs
        t.start = a[1] if a[0] is 'start'
    null

  list_item: (t) ->
    t.type = 'item'
    if t.attrs
      for a in t.attrs
        t.task = a[1] if a[0] is 'task'

  link: (t) ->
    t.type = 'link'
    if t.attrs
      for a in t.attrs
        t.href = a[1] if a[0] is 'href'
        t.title = a[1] if a[0] is 'title'
    null

  image: (t) ->
    t.type = 'image'
    t.nesting = 1
    if t.attrs
      for a in t.attrs
        t.src = a[1] if a[0] is 'src'
        t.title = a[1] if a[0] is 'title'
    null

  code_inline: (t) ->
    list = []
    # add token itself
    content = t.content
    delete t.content
    t.type = 'fixed'
    t.nesting = 1
    list.push node2token t
    list.push
      type: 'text'
      content: content
    t.nesting = -1
    list.push node2token t
    # return all tokens
    list

  code_block: (t) ->
    list = []
    # add token itself
    content = t.content
    delete t.content
    t.type = 'preformatted'
    t.nesting = 1
    list.push node2token t
    list.push
      type: 'text'
      content: util.string.rtrim content, '\n'
    t.nesting = -1
    list.push node2token t
    # return all tokens
    list

  fence: (t) ->
    list = []
    # add token itself
    info = t.info.trim().split /\s+/ if t.info
    content = t.content
    delete t.content
    t.type = 'code'
    t.nesting = 1
    t.language = info?[0] ? 'text'
    t.language = l if l = Config.get('/report/code/alias')[t.language]
    list.push node2token t
    list.push
      type: 'text'
      content: util.string.rtrim content, '\n'
    t.nesting = -1
    list.push node2token t
    # return all tokens
    list

  html_block: (t) ->
    t.type = 'raw'
    t.format = 'html'
    t.block = true
    t.content = t.content.replace /\n$/, ''

  html_inline: (t) ->
    t.type = 'raw'
    t.format = 'html'
    t.content = t.content.replace /\n$/, ''

  th_open: (t) ->
    t.type = 'th'
    t.nesting = 1
    t.align = 'left'
    if t.attrs
      for a in t.attrs
        continue unless a[0] is 'style'
        continue unless align = a[1].match /text-align:(\w+)/
        t.align = align[1]
    null

# Specify elements to copy from markdown token to report token.
copyAttributes =
  text: ['content']
  heading: ['heading']
  list: ['list', 'start']
  item: ['task']
  code: ['language']
  link: ['href', 'title']
  image: ['src', 'title']
  raw: ['format', 'block', 'content']
  th: ['align']

# Convert markdown-it structure to report tokens.
#
# @param {Array<Object>} tree to be converted
# @param {Integer} level current parsing level
# @return {Array<Token>} list of report tokens
tree2tokens = (tree) ->
  list = []
  for t in tree
    debug 'FOUND', chalk.grey util.inspect(t).replace /\s*\n\s*/g, ' ' if debug
    unless t.type is 'inline'
      res = null
      # modify tokens
      res = modify[t.type] t if modify[t.type]
      continue if res?.length is 0
      if Array.isArray(res) and res[0].type
        # already transformed
        list = list.concat res
        continue
      # default
      t.type = t.type.replace /_(open|close)$/, ''
      res = modify[t.type] t if modify[t.type]
      continue if res?.length is 0
      if Array.isArray(res) and res[0].type
        # already transformed
        list = list.concat res
        continue
      # run default conversion of single token and add to list
      list.push node2token t
    # add children
    if t.children
      list = list.concat tree2tokens t.children
      # autoclose some tags
      if t.type is 'image'
        t.nesting = -1
        list.push node2token t
  list


node2token = (t) ->
  # run default conversion of single token
  token =
    type: t.type
    nesting: t.nesting ? 0
  # copy specific values
  token['hidden'] = true if t.hidden
  if list = copyAttributes[t.type]
    for e in list
      token[e] = t[e] if t[e]?
  token

# https://www.npmjs.com/package/markdown-it-decorate

# @html xxx
# -> @html xxx
# @html {xxx}
# {xxx}
# -> style html xxx
# xxx
# -> comment xxx
optimize = (list) ->
  # optimize list
  for t in list
    continue unless t.type is 'raw'
    continue unless m = t.content.match ///
      ^\s*                        # nothing before
      <!-{2,}\s*                  # start comment
      (?:@(html|text|roff)\s+)?   # 1: format
      (?:
        \{(\s*[\s\S]+?)\}\s*      # 2: style
        |([\s\S]+?)               # 3: content
      )
      \s*-{2,}>                   # end comment
      \s*$                        # nothing after
    ///
    [_, format, style, content] = m
    format ?= 'html' if style
    # divide into three elements
    unless format
      t.type = 'comment'
      delete t.format
      t.content = content
    else if style
      t.type = 'style'
      t.format = format
      t.content = style
    else
      t.format = format
      t.content = content
  # return list
  list
