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
Parser Options
---------------------------------------------------
Some of the parsers may be configured to follow specific rules or not.
###

# #3 Markdown Parser (parser/md/)
#
# {@schema #keys/parser/keys/md}
mdParser =
  title: "Markdown Parser"
  description: "the definition of markdown parsing options"
  type: 'object'
  allowedKeys: true
  keys:
    html:
      title: "Enable HTML"
      description: "a flag to allow interpretation of html tags in source"
      type: 'boolean'
      default: true
    linkify:
      title: "Auto URL Detection"
      description: "a flag to automatically convert URL like text"
      type: 'boolean'
      default: true


###
Output Formats
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
    keep_soft_breaks:
      title: "Keep Soft Breaks"
      description: "a flag to define if soft breaks (if existent) should be kept as is"
      type: 'boolean'
      default: true
    use_references:
      title: "Use References"
      description: "a flag to use references at the end of document for links"
      type: 'boolean'
      default: true

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
    ansi_escape:
      title: "Use ANSI Escapes"
      description: "a flag to enable ANSI escape sequences to enable colors and simple text styles"
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
      description: "a flag to output in compressed form without unnecessary newlines..."
      type: 'boolean'
      optional: true
    keep_breaks:
      title: "Keep Breaks"
      description: "a flag to also keep soft breaks like done for hard breaks"
      type: 'boolean'
      optional: true
    head_begin:
      title: "Start Head Section"
      description: "the html code used to start the head part"
      type: 'string'
      default: '<!DOCTYPE html>\n<html>\n<head>'
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
    style:
      title: "Style Sheet"
      description: "the references to the stylesheets to load"
      type: 'array'
      toArray: true
      default: ['report/default.css']
    convert:
      title: "Conversion"
      description: "a possible conversion to run on the resulting format"
      type: 'object'
      keys:
        type:
          title: "Conversion Type"
          description: "the type to convert output into"
          type: 'string'
          values: ['png', 'jpg', 'pdf']
        width:
          title: "Screen Width"
          description: "the screen size equals to the shot size in pixel"
          type: 'integer'
        height:
          title: "Screen Height"
          description: "the screen size also used as minimal shot height in pixel"
          type: 'integer'
        capture:
          title: "Conversion Type"
          description: "the type to convert output into"
          type: 'string'

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
    code:
      title: "Code Processing"
      description: "the specification for code highlighting and execution"
      type: 'object'
      allowedKeys: true
      keys:
        alias:
          title: "Language Alias"
          description: "the possible alias (short names) for some languages"
          type: 'object'
          entries: [
            title: "Language"
            description: "the real language name to use"
            type: 'string'
            minLength: 1
          ]
        title:
          title: "Language Title"
          description: "the title to be used in header"
          type: 'object'
          entries: [
            title: "Title"
            description: "the title to use"
            type: 'string'
            minLength: 1
          ]
    parser:
      title: "Parser Options"
      description: "the default options for each format"
      type: 'object'
      allowedKeys: true
      keys:
        md: mdParser
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
