# markdown-it plugin to include other markdown
# =================================================


fs = require 'fs'
path = require 'path'


INCLUDE_RE = /([>\t\ ]*)@\[([\w_]*)\]\(([^\n]+?)\)/g

# Markdown-it extension
# ---------------------------------------

# Morph tokens in core chain.
#
# @param {MarkdownIt} md object to add parser rule
module.exports = (md) ->
  md.core.ruler.before 'normalize', 'include', parser

parser = (state) ->
  state.src = replace state.src

replace = (src, processed = []) ->
  src.replace INCLUDE_RE, (m, indent, param, source) ->
    # pack into specific element
    envelope = ['', '']
    if param
      param = param.split /\ /
      switch param[0]
        when 'code'
          envelope = ["#{indent}``` #{path.extname(source)[1..]}\n", "\n#{indent}```"]
        when 'pre'
          indent += '    '
    # get the content
    try
      throw new Error "Circular reference in include of #{source}!" if source in processed
      content = fs.readFileSync source, 'utf8'
      content = indent + content.trim().replace /\n/g, "\n#{indent}"
    catch error
      content = "==**ERROR: #{error.message}**=="
    # return markdown code
    envelope[0] + replace(content, processed.concat [source]) + envelope[1]
