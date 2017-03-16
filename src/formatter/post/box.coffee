# Headings
# =================================================


# Transformer rules
#
# @type {Object<Transformer>} rules to set output text in token
module.exports =

  md_marker:
    format: 'md'
    type: 'box'
    fn: (num, token) ->
      token.parent.marker ?= ':::'
      token.parent.marker += ':' while ~token.collect.indexOf token.parent.marker

  md_container:
    format: 'md'
    type: 'container'
    fn: (num, token) ->
      token.collect += "#{token.marker}\n"

  md_box:
    format: 'md'
    type: 'box'
    fn: (num, token) ->
      token.out = "\n#{token.parent.marker} #{token.box} #{token.title}"

  html:
    format: 'html'
    type: 'container'
    fn: (num, token) ->
      util.extend token,
        html:
          class: ['container']
      nl = if @setup.compress then '' else '\n'
      token.out = switch token.nesting
        when 1 then "<div#{@htmlAttribs token}>#{nl}"
        when -1 then "</div>#{nl}"

#<input name="tabs1" class="tab tab1" id="tab1" checked="" type="radio">
#<label for="tab1" class="detail" title="Switch tab">Details</label>
#<div class="tab-content tab-content1 detail">
#<p>Some more details here…</p>
#</div>

  text_width:
    format: 'text'
    type: 'box'
    fn: (num, token) ->
      token.parent.width ?= 0
      for line in token.collect.split /\n/
        width = line.length
        token.parent.width = width if width > token.parent.width

#╔══╗
#╟──╢
#║  ║
#╠══╣
#║  ║
#╟──╢
#║  ║
#╚══╝

################################
# Title                        #
#------------------------------#
# XXXX                         #
################################
# Title                        #
#------------------------------#
# XXXX                         #
################################
