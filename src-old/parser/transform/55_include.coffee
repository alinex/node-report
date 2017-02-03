# Include
# =================================================


path = require 'path'
fs = require 'fs'


# use @basedir for relative links
# change @basedir on post content for include


# Transformer rules
#
# @type {Object<Transformer>} rules to transform text into tokens
module.exports =

  text:
    state: ['m-block']
    re: ///
      ^(\n?       # 1: start of line
        \ {0,3}   # indented by 1-3 spaces (optional)
      )           # end of start
      \[\#INCLUDE\]\(
      ([^\n]+)    # 2: source URL
      \)[^\n]*
      (\n|$)      # 3: end of line
      /// # one line
    fn: (m) ->
      if m[2].match /^/
        throw new Error "web resource includes not supported, yet"
# deasync request
#        content =
      else
        # load content from file
        url = path.resolve m[2], @basedir
        content = fs.readFileSync url
      # opening
      @insert null,
        type: 'include'
        content: content
        basedir: path.dirname url
      # done
      m[0].length
