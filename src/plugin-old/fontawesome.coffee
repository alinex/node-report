# Plugin to add graphics
# ====================================================


# Node Modules
# -------------------------------------------

debug = require('debug') 'report:fontawesome'
chalk = require 'chalk'
# alinex modules


# Setup
# -------------------------------------------

REGEXP = /^\:(fa-[\w\-]+(\s+(fa|text)-[\w\-]+)*)\:/
TEXT_REMOVE = [
  'fa-lg', 'fa-2x', 'fa-3x', 'fa-4x', 'fa-5x'
  'fa-pull-left', 'fa-pull-right', 'fa-border'
  'fa-spin', 'fa-fw'
  'fa-stack', 'fa-stack-1x', 'fa-stack-2x'
  'fa-flip-horizontal', 'fa-flip-vertical'
  'fa-rotate-90', 'fa-rotate-180', 'fa-rotate-270'
  'fa-inverse'
]


# Init plugin in markdown-it
# -------------------------------------------

module.exports = (md) ->
  debug "Init plugin..."
  # add parser rules
  md.inline.ruler.push 'fontawesome', parser
  # add render rules
  md.renderer.rules.fontawesome = renderer


# Convert to othher formats
# -------------------------------------------
module.exports.toText = (text) ->
  text.replace /\:(fa-[\w\-]+(\s+(fa|text)-[\w\-]+)*)\:/g, (match, def) ->
    parts = def.split /\s/
    text = parts.filter (e) ->
      return false if e.match /^text-/
      return false if e in TEXT_REMOVE
      true
    .map (e) -> e[3..]
    .join ' '
    "<#{text}>"

module.exports.toConsole = (text) ->
  text.replace /\:(fa-[\w\-]+(\s+(fa|text)-[\w\-]+)*)\:/g, (match, def) ->
    parts = def.split /\s/
    text = parts.filter (e) ->
      return false if e.match /^text-/
      return false if e in TEXT_REMOVE
      true
    .map (e) -> e[3..]
    .join ' '
    text = "<#{text}>"
    color = def.match(/(?:^|\s)text-(red|green|yellow|blue|magenta|cyan|gray)(?:\s|$)/)?[1]
    if color then chalk[color] text else text


# Parser
# -------------------------------------------

parser = (state, startLine, endLine, silent) ->
  # slowwww... maybe use an advanced regexp engine for this
  match = state.src.slice(state.pos).match REGEXP
  return false unless match
  # valid match found, now we need to advance cursor
  state.pos += match[0].length
  # don't insert any tokens in silent mode
  return true if silent
  token = state.push 'fontawesome', '', 0
  token.meta =
    match: match
  return true


# Renderer
# -------------------------------------------

renderer = (tokens, id) ->
  names = tokens[id].meta.match[1].split /(?:^|\s)(?=fa-stack)/
  return '<i class="fa ' + tokens[id].meta.match[1] + '"></i>' if names.length is 1
  # make stacked icons
  html = """<span class="fa-stack #{names[0]}">"""
  html += """<i class="fa #{e}"></i>""" for e in names[1..]
  html + "</span>"
