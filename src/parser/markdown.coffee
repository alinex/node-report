# Markdown Parser
# =================================================
# This module is using the [markdownIt](http://markdown-it.github.io) parser which
# is base on [CommonMark Specification](http://spec.commonmark.org).


# Node Modules
# -------------------------------------------------
debug = require('debug') 'report:parse:markdown'
chalk = require 'chalk'
markdownIt = null # load on demand
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
    markdownIt = require('markdown-it')
      html: true
      linkify: true
#      typographer: true
  # parse and convert tokens
  tree = markdownIt.parse text, {} # empty env
  @tokens.insert tree2tokens tree
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
  list_item: (t) -> t.type = 'item'
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
    t.language = l if l = Config.get('/report/code/language')[t.language]
    list.push node2token t
    list.push
      type: 'text'
      content: util.string.rtrim content, '\n'
    t.nesting = -1
    list.push node2token t
    # return all tokens
    list

# Specify elements to copy from markdown token to report token.
copyAttributes =
  text: ['content']
  heading: ['heading']
  list: ['list', 'start']
  code: ['language']
  link: ['href', 'title']
  image: ['src', 'title']

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
