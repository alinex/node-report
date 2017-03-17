# Headings
# =================================================


util = require 'alinex-util'
chalk = require 'chalk'


COLORS =
  info: 'cyan'
  ok: 'green'
  warning: 'yellow'
  alert: 'red'


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
      width = token.title.length
      token.parent.width = width if width > token.parent.width
      for line in token.collect.split /\n/
        width = line.length
        token.parent.width = width if width > token.parent.width

  text_container:
    format: 'text'
    type: 'container'
    fn: (num, token) ->
      # top
      chalk = new chalk.constructor {enabled: @setup.ansi_escape ? false}
      first = @tokens.get num + 1
      color = chalk[COLORS[first.box] ? 'white']
      top = if @setup.ascii_art then '╔═╗' else '###'
      top = color top[0] + util.string.repeat(top[1], token.width + 2) + top[2]
      # bottom
      [lnum] = @tokens.findEnd num, token
      last = @tokens.get lnum - 1
      [_, last] = @tokens.findStart lnum - 1, last
      color = chalk[COLORS[last.box] ? 'white']
      bottom = if @setup.ascii_art then '╚═╝' else '###'
      bottom = color bottom[0] + util.string.repeat(bottom[1], token.width + 2) + bottom[2]
      # work on boxes
      title = if @setup.ascii_art then '╟─╢' else '#-#'
      divider = if @setup.ascii_art then '╠═╣' else '#=#'
      content = if @setup.ascii_art then '║ ║' else '# #'
      title = title[0] + util.string.repeat(title[1], token.width + 2) + title[2]
      divider = divider[0] + util.string.repeat(divider[1], token.width + 2) + divider[2]
      first = true
      for n, t of @tokens.contains 'box', num, token
        color = chalk[COLORS[t.box] ? 'white']
        collect = t.collect.trim().split /\n/
        .map (e) -> util.string.rpad e, token.width
        .join color "#{content[1..2]}\n#{content[0..1]}"
        t.collect = "#{color content[0]} #{collect} #{color content[2]}" + '\n'
        heading = chalk.bold util.string.rpad t.title, token.width
        t.out = color content[0..1] + heading + content[1..2]
        t.out += '\n' + color(title) + '\n'
        if first
          first = false
        else
          t.out = color(divider) + '\n' + t.out
      # recalculate collect
      @tokens.collect num, token
      token.collect = "\n#{top}\n#{token.collect}#{bottom}\n"
