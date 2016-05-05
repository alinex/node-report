# markdown
markdown = require 'markdown-it'
mdAbbr = require 'markdown-it-abbr'
mdFootnote = require 'markdown-it-footnote'
mdToc = require 'markdown-it-toc-and-anchor'

# setup markdown it
md = markdown()
.use mdAbbr # abbreviations (auto added)
.use mdFootnote # footnotes (auto linked)
.use mdToc.default, # possibility to add TOC
  tocClassName: 'table-of-contents'
  tocFirstLevel: 2
  anchorLink: false
data = {}
content = "Put markdown here..."
html = md.render content, data

console.log html
