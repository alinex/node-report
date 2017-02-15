# Headings
# =================================================

## https://en.wikipedia.org/wiki/ANSI_escape_code
##echo -e '\u001b[30;47mtest\u001b[39;49m'
#  { reset: { open: '\u001b[0m', close: '\u001b[0m', closeRe: /[0m/g },
#     bold: { open: '\u001b[1m', close: '\u001b[22m', closeRe: /[22m/g },
#     dim: { open: '\u001b[2m', close: '\u001b[22m', closeRe: /[22m/g },
#     italic: { open: '\u001b[3m', close: '\u001b[23m', closeRe: /[23m/g },
#     underline: { open: '\u001b[4m', close: '\u001b[24m', closeRe: /[24m/g },
#     inverse: { open: '\u001b[7m', close: '\u001b[27m', closeRe: /[27m/g },
#     hidden: { open: '\u001b[8m', close: '\u001b[28m', closeRe: /[28m/g },
#     strikethrough: { open: '\u001b[9m', close: '\u001b[29m', closeRe: /[29m/g },
#     black: { open: '\u001b[30m', close: '\u001b[39m', closeRe: /[39m/g },
#     red: { open: '\u001b[31m', close: '\u001b[39m', closeRe: /[39m/g },
#     green: { open: '\u001b[32m', close: '\u001b[39m', closeRe: /[39m/g },
#     yellow: { open: '\u001b[33m', close: '\u001b[39m', closeRe: /[39m/g },
#     blue: { open: '\u001b[34m', close: '\u001b[39m', closeRe: /[39m/g },
#     magenta: { open: '\u001b[35m', close: '\u001b[39m', closeRe: /[39m/g },
#     cyan: { open: '\u001b[36m', close: '\u001b[39m', closeRe: /[39m/g },
#     white: { open: '\u001b[37m', close: '\u001b[39m', closeRe: /[39m/g },
#     gray: { open: '\u001b[90m', close: '\u001b[39m', closeRe: /[39m/g },
#     grey: { open: '\u001b[90m', close: '\u001b[39m', closeRe: /[39m/g },
#     bgBlack: { open: '\u001b[40m', close: '\u001b[49m', closeRe: /[49m/g },
#     bgRed: { open: '\u001b[41m', close: '\u001b[49m', closeRe: /[49m/g },
#     bgGreen: { open: '\u001b[42m', close: '\u001b[49m', closeRe: /[49m/g },
#     bgYellow: { open: '\u001b[43m', close: '\u001b[49m', closeRe: /[49m/g },
#     bgBlue: { open: '\u001b[44m', close: '\u001b[49m', closeRe: /[49m/g },
#     bgMagenta: { open: '\u001b[45m', close: '\u001b[49m', closeRe: /[49m/g },
#     bgCyan: { open: '\u001b[46m', close: '\u001b[49m', closeRe: /[49m/g },
#     bgWhite: { open: '\u001b[47m', close: '\u001b[49m', closeRe: /[49m/g } },

# Transformer rules
#
# @type {Object<Transformer>} rules to set output text in token
module.exports =

  strong_md:
    format: 'md'
    type: 'strong'
    fn: (num, token) ->
      # set marker to use primarily as * but use _ if it may be compromising
      if token.nesting is 1
        last = @tokens.get num - 1
        [numEnd] = @tokens.findEnd num, token
        next = @tokens.get numEnd + 1
        token.marker = if last.nesting is 1 and last.type in ['emphasis', 'strong'] and \
          next.type in ['emphasis', 'strong'] and last.marker is '*' then '_' else '*'
      else
        [_, start] = @tokens.findStart num, token
        token.marker = start.marker

  emphasis_md:
    format: 'md'
    type: 'emphasis'
    fn: (num, token) ->
      # set marker to use primarily as * but use _ if it may be compromising
      if token.nesting is 1
        last = @tokens.get num - 1
        [numEnd] = @tokens.findEnd num, token
        next = @tokens.get numEnd + 1
        token.marker = if last.nesting is 1 and last.type in ['emphasis', 'strong'] and \
          next.type in ['emphasis', 'strong'] and last.marker is '*' then '_' else '*'
      else
        [_, start] = @tokens.findStart num, token
        token.marker = start.marker
