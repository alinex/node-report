###
Configuration
===================================================
This configuration will set the defaukt for the reports but you may always give
other options on initialization of a new format.


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
      type: 'string'
      values: ['md']
    width:
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
      type: 'string'
      values: ['text']
    width:
      type: 'integer'
      min: 40
      default: 100
    ascii_art:
      type: 'boolean'
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
      type: 'string'
      values: ['html']


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
        ]
      ]
