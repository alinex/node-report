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
      level = 1
      for link, t of @tokens.data[0].heading
        continue unless t.title # ignore empty headings
        while level < t.heading
          token.out += "<ul>#{nl}"
          level++
        while level > t.heading
          token.out += "</ul>#{nl}"
          level--
        token.out += "<li><a href=\"##{link}\">#{t.title}</a></li>#{nl}"
      while level > 0
        token.out += "</ul>#{nl}"
        level--

#
#<li><a href="#my-text">My text</a></li>
#<li><a href="#other-opinions">Other opinions</a>
#<ul>
#<li><a href="#my-parents">My parents</a></li>
#<li><a href="#my-friends">My friends</a></li>
#</ul>
