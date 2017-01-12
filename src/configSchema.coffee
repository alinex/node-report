###
Configuration
===================================================
This configuration will set the defaukt for the reports but you may always give
other options on initialization of a new format.
###

extension =
  title: "File Extension"
  description: "the default file extension"
  type: 'string'
  mandatory: true


###
Formats
---------------------------------------------------
Multiple settings for various formats may be defined but they all go back to one
of the basic format types:
###

# #3 Markdown Setup (format/<name>/)
#
# {@schema #keys/format/entries/0/or/0}
md =
  title: "Markdown Text Setup"
  description: "the definition of markdown formats"
  type: 'object'
  allowedKeys: true
  keys:
    type:
      title: "Base Format"
      description: "the base format used for conversion"
      type: 'string'
      values: ['md']
    extension: extension
    width:
      title: "Character Width"
      description: "the maximum number of characters per line"
      type: 'integer'
      min: 40
      default: 100

# #3 Text Setup (format/<name>/)
#
# {@schema #keys/format/entries/0/or/1}
text =
  title: "Plain Text Setup"
  description: "the definition of text formats"
  type: 'object'
  allowedKeys: true
  keys:
    type:
      title: "Base Format"
      description: "the base format used for conversion"
      type: 'string'
      values: ['text']
    extension: extension
    width:
      title: "Character Width"
      description: "the maximum number of characters per line"
      type: 'integer'
      min: 40
      default: 100
    ascii_art:
      title: "Use ASCII Art"
      description: "a flag to use ASCII art characters for formatting"
      type: 'boolean'
      optional: true
    begin:
      title: "Document Header"
      description: "the text used as document header"
      type: 'string'
      optional: true
    end:
      title: "Document Footer"
      description: "the text used as document footer"
      type: 'string'
      optional: true

# #3 HTML Setup (format/<name>/)
#
# {@schema #keys/format/entries/0/or/2}
html =
  title: "HTML Text Setup"
  description: "the definition of html formats"
  type: 'object'
  allowedKeys: true
  keys:
    type:
      title: "Base Format"
      description: "the base format used for conversion"
      type: 'string'
      values: ['html']
    extension: extension
    compress:
      title: "Compress"
      description: "a flag to output in compressed form without unneccessary newlines..."
      type: 'boolean'
      optional: true
    head_end:
      title: "Ending Head Section"
      description: "the html code used to end the head part"
      type: 'string'
      default: '</head>'
    body_begin:
      title: "Start Body Section"
      description: "the html code used to begin the body part"
      type: 'string'
      default: '<body>'
    body_end:
      title: "Ending Body Section"
      description: "the html code used to end the body part"
      type: 'string'
      default: '</body>'

# #3 ROFF Setup (format/<name>/)
#
# {@schema #keys/format/entries/0/or/3}
roff =
  title: "ROFF Setup"
  description: "the definition of roff formats"
  type: 'object'
  allowedKeys: true
  keys:
    type:
      title: "Base Format"
      description: "the base format used for conversion"
      type: 'string'
      values: ['roff']
    extension: extension

# #3 AsciiDoc Setup (format/<name>/)
#
# {@schema #keys/format/entries/0/or/4}
adoc =
  title: "AsciiDoc Setup"
  description: "the definition of AsciiDoc formats"
  type: 'object'
  allowedKeys: true
  keys:
    type:
      title: "Base Format"
      description: "the base format used for conversion"
      type: 'string'
      values: ['adoc']
    extension: extension

# #3 LaTeX Setup (format/<name>/)
#
# {@schema #keys/format/entries/0/or/5}
latex =
  title: "LaTeX Setup"
  description: "the definition of latex formats"
  type: 'object'
  allowedKeys: true
  keys:
    type:
      title: "Base Format"
      description: "the base format used for conversion"
      type: 'string'
      values: ['latex']
    extension: extension
    convert:
      title: "Conversion"
      description: "a possible conversion to run on the resulting format"
      type: 'object'
      keys:
        type:
          title: "Conversion Type"
          description: "the type to convert output into"
          type: 'string'
          values: ['dvi', 'pdf']

# #3 RTF Setup (format/<name>/)
#
# {@schema #keys/format/entries/0/or/6}
rtf =
  title: "RTF Setup"
  description: "the definition of rtf formats"
  type: 'object'
  allowedKeys: true
  keys:
    type:
      title: "Base Format"
      description: "the base format used for conversion"
      type: 'string'
      values: ['rtf']
    extension: extension


# Complete config
# -----------------------------------------------------------
# All three parts together are exported as the complete configuration structure.
module.exports =
  title: "Report Settings"
  description: "the setup for report generation"
  type: 'object'
  allowedKeys: true
  keys:
    format:
      title: "Format Options"
      description: "the default options for each format"
      type: 'object'
      entries: [
        type: 'or'
        or: [
          md
          text
          html
          roff
          adoc
          latex
          rtf
        ]
      ]
