# Table of Contents
# =================================================


TOC_DEFAULT = 'Table of Contents'


# Transformer rules
#
# @type {Object<Transformer>} rules to set output text in token
module.exports =

  md:
    format: 'md'
    type: 'toc'
    fn: (num, token) ->
      token.out = if token.title
        "\n@[toc](#{token.title})\n"
      else
        "\n@[toc]\n"

  html:
    format: 'html'
    type: 'toc'
    fn: (num, token) ->
      nl = if @setup.compress then '' else '\n'
      token.out = "<ul class=\"table-of-contents\" aria-hidden=\"true\">#{nl}" +
      "<header>Index<a href=\"#top\" class=\"fa fa-arrow-up toplink\"></a></header>#{nl}"
      start = level = @setup.toc?.startLevel ? 1
      for link, t of @tokens.data[0].heading
        continue if start > t.heading
        continue unless t.title # ignore empty headings
        while level < t.heading
          token.out += "<ul>#{nl}"
          level++
        while level > t.heading
          token.out += "</ul>#{nl}"
          level--
        token.out += "<li><a href=\"##{link}\">#{t.title}</a></li>#{nl}"
      while level >= start
        token.out += "</ul>#{nl}"
        level--
