# Whitespace Replacement
# =================================================


# Config
# -------------------------------------------------

# List of replacement rules to cleanup text for better parsing.
#
# @type {Array<Array>} list of replacements
CLEANUP = [
  [/\r\n|\r|\u2424/g, '\n'] # replace carriage return and unicode newlines
#  [/\u00a0/g, ' ']          # replace other whitechar with space
  [/\u0000/g, '\ufffd']     # replace \0 as non visible replacement char
]


# Methods
# -------------------------------------------------

# @param {String} t as text to be optimized
# @return {String} optimized text
cleanup = (t) ->
  for r in CLEANUP
    t = t.replace r[0], r[1]
  t


# Parser Domain
# -------------------------------------------------
# Specify for which parser domain to run which function.
module.exports =
  m: cleanup
