# Plugin to add graphics
# ====================================================


# Node Modules
# -------------------------------------------

debug = require('debug') 'report:fontawesome'
# alinex modules


# Init plugin in markdown-it
# -------------------------------------------

module.exports = (md) ->
  debug "Init plugin..."
  # add parser rules
  md.inline.ruler.push 'fontawesome', parser
  # add render rules
  md.renderer.rules.fontawesome = renderer


# Parser
# -------------------------------------------

parser = (state, startLine, endLine, silent) ->
  # slowwww... maybe use an advanced regexp engine for this
  match = state.src.slice(state.pos).match /^\:(fa-[\w\-]+(\s+(fa|text)-[\w\-]+)*)\:/
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
  names = tokens[id].meta.match[1].split /\s(?=fa-stack)/
  return '<i class="fa ' + tokens[id].meta.match[1] + '"></i>' if names.length is 1
  html = """<span class="#{names[0]}">"""
  html += """<i class="fa #{e}"></i>""" for e in names[1..]
  html + "</span>"
