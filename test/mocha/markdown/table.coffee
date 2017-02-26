### eslint-env node, mocha ###
test = require '../test'
async = require 'async'

Report = require '../../../src'
before (cb) -> Report.init cb

describe "markdown table", ->

  it "should create simple table", (cb) ->
    test.markdown null, """
    | First Header | Second Header |
    | ------------ | ------------- |
    | Content Cell | Content Cell  |
    | Content Cell | Content Cell  |
    """, [
      {type: 'document', nesting: 1}
      {type: 'table', nesting: 1}
      {type: 'thead', nesting: 1}
      {type: 'tr', nesting: 1}
      {type: 'th', nesting: 1}
      {type: 'text', content: 'First Header'}
      {type: 'th', nesting: -1}
      {type: 'th', nesting: 1}
      {type: 'text', content: 'Second Header'}
      {type: 'th', nesting: -1}
      {type: 'tr', nesting: -1}
      {type: 'thead', nesting: -1}
      {type: 'tbody', nesting: 1}
      {type: 'tr', nesting: 1}
      {type: 'td', nesting: 1}
      {type: 'text', content: 'Content Cell'}
      {type: 'td', nesting: -1}
      {type: 'td', nesting: 1}
      {type: 'text', content: 'Content Cell'}
      {type: 'td', nesting: -1}
      {type: 'tr', nesting: -1}
      {type: 'tr', nesting: 1}
      {type: 'td', nesting: 1}
      {type: 'text', content: 'Content Cell'}
      {type: 'td', nesting: -1}
      {type: 'td', nesting: 1}
      {type: 'text', content: 'Content Cell'}
      {type: 'td', nesting: -1}
      {type: 'tr', nesting: -1}
      {type: 'tbody', nesting: -1}
      {type: 'table', nesting: -1}
      {type: 'document', nesting: -1}
    ], null, cb

  it "should work without the pipes at the start and end", (cb) ->
    test.markdown null, """
      First Header | Second Header
      ------------ | ------------- |
    | Content Cell | Content Cell
      Content Cell | Content Cell  |
    """, [
      {type: 'document', nesting: 1}
      {type: 'table', nesting: 1}
      {type: 'thead', nesting: 1}
      {type: 'tr', nesting: 1}
      {type: 'th', nesting: 1}
      {type: 'text', content: 'First Header'}
      {type: 'th', nesting: -1}
      {type: 'th', nesting: 1}
      {type: 'text', content: 'Second Header'}
      {type: 'th', nesting: -1}
      {type: 'tr', nesting: -1}
      {type: 'thead', nesting: -1}
      {type: 'tbody', nesting: 1}
      {type: 'tr', nesting: 1}
      {type: 'td', nesting: 1}
      {type: 'text', content: 'Content Cell'}
      {type: 'td', nesting: -1}
      {type: 'td', nesting: 1}
      {type: 'text', content: 'Content Cell'}
      {type: 'td', nesting: -1}
      {type: 'tr', nesting: -1}
      {type: 'tr', nesting: 1}
      {type: 'td', nesting: 1}
      {type: 'text', content: 'Content Cell'}
      {type: 'td', nesting: -1}
      {type: 'td', nesting: 1}
      {type: 'text', content: 'Content Cell'}
      {type: 'td', nesting: -1}
      {type: 'tr', nesting: -1}
      {type: 'tbody', nesting: -1}
      {type: 'table', nesting: -1}
      {type: 'document', nesting: -1}
    ], null, cb

  it "should work with varying width of cells", (cb) ->
    test.markdown null, """
    First Header | Second Header
    --- | ------
    a | Content Cell
    Content Cell | Content Cell
    """, [
      {type: 'document', nesting: 1}
      {type: 'table', nesting: 1}
      {type: 'thead', nesting: 1}
      {type: 'tr', nesting: 1}
      {type: 'th', nesting: 1}
      {type: 'text', content: 'First Header'}
      {type: 'th', nesting: -1}
      {type: 'th', nesting: 1}
      {type: 'text', content: 'Second Header'}
      {type: 'th', nesting: -1}
      {type: 'tr', nesting: -1}
      {type: 'thead', nesting: -1}
      {type: 'tbody', nesting: 1}
      {type: 'tr', nesting: 1}
      {type: 'td', nesting: 1}
      {type: 'text', content: 'a'}
      {type: 'td', nesting: -1}
      {type: 'td', nesting: 1}
      {type: 'text', content: 'Content Cell'}
      {type: 'td', nesting: -1}
      {type: 'tr', nesting: -1}
      {type: 'tr', nesting: 1}
      {type: 'td', nesting: 1}
      {type: 'text', content: 'Content Cell'}
      {type: 'td', nesting: -1}
      {type: 'td', nesting: 1}
      {type: 'text', content: 'Content Cell'}
      {type: 'td', nesting: -1}
      {type: 'tr', nesting: -1}
      {type: 'tbody', nesting: -1}
      {type: 'table', nesting: -1}
      {type: 'document', nesting: -1}
    ], null, cb

  it "should allow empty cells", (cb) ->
    test.markdown null, """
    First Header | Second Header | Third Header
    --- | ------ | ---
    a || Content Cell
    Content Cell | Content Cell
    """, [
      {type: 'document', nesting: 1}
      {type: 'table', nesting: 1}
      {type: 'thead', nesting: 1}
      {type: 'tr', nesting: 1}
      {type: 'th', nesting: 1}
      {type: 'text', content: 'First Header'}
      {type: 'th', nesting: -1}
      {type: 'th', nesting: 1}
      {type: 'text', content: 'Second Header'}
      {type: 'th', nesting: -1}
      {type: 'th', nesting: 1}
      {type: 'text', content: 'Third Header'}
      {type: 'th', nesting: -1}
      {type: 'tr', nesting: -1}
      {type: 'thead', nesting: -1}
      {type: 'tbody', nesting: 1}
      {type: 'tr', nesting: 1}
      {type: 'td', nesting: 1}
      {type: 'text', content: 'a'}
      {type: 'td', nesting: -1}
      {type: 'td', nesting: 1}
      {type: 'td', nesting: -1}
      {type: 'td', nesting: 1}
      {type: 'text', content: 'Content Cell'}
      {type: 'td', nesting: -1}
      {type: 'tr', nesting: -1}
      {type: 'tr', nesting: 1}
      {type: 'td', nesting: 1}
      {type: 'text', content: 'Content Cell'}
      {type: 'td', nesting: -1}
      {type: 'td', nesting: 1}
      {type: 'text', content: 'Content Cell'}
      {type: 'td', nesting: -1}
      {type: 'td', nesting: 1}
      {type: 'td', nesting: -1}
      {type: 'tr', nesting: -1}
      {type: 'tbody', nesting: -1}
      {type: 'table', nesting: -1}
      {type: 'document', nesting: -1}
    ], null, cb

  it "should fail if header separator row has no dashes or too less columns", (cb) ->
    test.markdown null, """
    First Header | Second Header | Third header
    - | -
    a | b | c
    """, [
      {type: 'document', nesting: 1}
      {type: 'paragraph', nesting: 1}
      {type: 'text', content: 'First Header | Second Header | Third header'}
      {type: 'paragraph', nesting: -1}
      {type: 'list', nesting: 1}
      {type: 'item', nesting: 1}
      {type: 'paragraph', nesting: 1}
      {type: 'text', content: '| -'}
      {type: 'softbreak'}
      {type: 'text', content: 'a | b | c'}
      {type: 'paragraph', nesting: -1}
      {type: 'item', nesting: -1}
      {type: 'list', nesting: -1}
      {type: 'document', nesting: -1}
    ], null, cb

  it "should allow inline formatting", (cb) ->
    test.markdown null, """
    | First Header | Second Header |
    | ------------ | ------------- |
    | `Fixed` | Content Cell  |
    | _Content_ **Cell** | Content Cell  |
    """, [
      {type: 'document', nesting: 1}
      {type: 'table', nesting: 1}
      {type: 'thead', nesting: 1}
      {type: 'tr', nesting: 1}
      {type: 'th', nesting: 1}
      {type: 'text', content: 'First Header'}
      {type: 'th', nesting: -1}
      {type: 'th', nesting: 1}
      {type: 'text', content: 'Second Header'}
      {type: 'th', nesting: -1}
      {type: 'tr', nesting: -1}
      {type: 'thead', nesting: -1}
      {type: 'tbody', nesting: 1}
      {type: 'tr', nesting: 1}
      {type: 'td', nesting: 1}
      {type: 'fixed', nesting: 1}
      {type: 'text', content: 'Fixed'}
      {type: 'fixed', nesting: -1}
      {type: 'td', nesting: -1}
      {type: 'td', nesting: 1}
      {type: 'text', content: 'Content Cell'}
      {type: 'td', nesting: -1}
      {type: 'tr', nesting: -1}
      {type: 'tr', nesting: 1}
      {type: 'td', nesting: 1}
      {type: 'emphasis', nesting: 1}
      {type: 'text', content: 'Content'}
      {type: 'emphasis', nesting: -1}
      {type: 'text', content: ' '}
      {type: 'strong', nesting: 1}
      {type: 'text', content: 'Cell'}
      {type: 'strong', nesting: -1}
      {type: 'td', nesting: -1}
      {type: 'td', nesting: 1}
      {type: 'text', content: 'Content Cell'}
      {type: 'td', nesting: -1}
      {type: 'tr', nesting: -1}
      {type: 'tbody', nesting: -1}
      {type: 'table', nesting: -1}
      {type: 'document', nesting: -1}
    ], null, cb

  it "should create simple table", (cb) ->
    test.markdown null, """
    | Left-aligned | Center-aligned | Right-aligned |
    | :---         |     :---:      |          ---: |
    | git status   | git status     | git status    |
    | git diff     | git diff       | git diff      |
    """, [
      {type: 'document', nesting: 1}
      {type: 'table', nesting: 1}
      {type: 'thead', nesting: 1}
      {type: 'tr', nesting: 1}
      {type: 'th', nesting: 1, align: 'left'}
      {type: 'text', content: 'Left-aligned'}
      {type: 'th', nesting: -1}
      {type: 'th', nesting: 1, align: 'center'}
      {type: 'text', content: 'Center-aligned'}
      {type: 'th', nesting: -1}
      {type: 'th', nesting: 1, align: 'right'}
      {type: 'text', content: 'Right-aligned'}
      {type: 'th', nesting: -1}
      {type: 'tr', nesting: -1}
      {type: 'thead', nesting: -1}
      {type: 'tbody', nesting: 1}
      {type: 'tr', nesting: 1}
      {type: 'td', nesting: 1}
      {type: 'text', content: 'git status'}
      {type: 'td', nesting: -1}
      {type: 'td', nesting: 1}
      {type: 'text', content: 'git status'}
      {type: 'td', nesting: -1}
      {type: 'td', nesting: 1}
      {type: 'text', content: 'git status'}
      {type: 'td', nesting: -1}
      {type: 'tr', nesting: -1}
      {type: 'tr', nesting: 1}
      {type: 'td', nesting: 1}
      {type: 'text', content: 'git diff'}
      {type: 'td', nesting: -1}
      {type: 'td', nesting: 1}
      {type: 'text', content: 'git diff'}
      {type: 'td', nesting: -1}
      {type: 'td', nesting: 1}
      {type: 'text', content: 'git diff'}
      {type: 'td', nesting: -1}
      {type: 'tr', nesting: -1}
      {type: 'tbody', nesting: -1}
      {type: 'table', nesting: -1}
      {type: 'document', nesting: -1}
    ], null, cb

  it "should allow inline formatting", (cb) ->
    test.markdown null, """
    | Name     | Character |
    | ---      | ---       |
    | Backtick | `         |
    | Pipe     | \\|       |
    """, [
      {type: 'document', nesting: 1}
      {type: 'table', nesting: 1}
      {type: 'thead', nesting: 1}
      {type: 'tr', nesting: 1}
      {type: 'th', nesting: 1}
      {type: 'text', content: 'Name'}
      {type: 'th', nesting: -1}
      {type: 'th', nesting: 1}
      {type: 'text', content: 'Character'}
      {type: 'th', nesting: -1}
      {type: 'tr', nesting: -1}
      {type: 'thead', nesting: -1}
      {type: 'tbody', nesting: 1}
      {type: 'tr', nesting: 1}
      {type: 'td', nesting: 1}
      {type: 'text', content: 'Backtick'}
      {type: 'td', nesting: -1}
      {type: 'td', nesting: 1}
      {type: 'text', content: '`'}
      {type: 'td', nesting: -1}
      {type: 'tr', nesting: -1}
      {type: 'tr', nesting: 1}
      {type: 'td', nesting: 1}
      {type: 'text', content: 'Pipe'}
      {type: 'td', nesting: -1}
      {type: 'td', nesting: 1}
      {type: 'text', content: '|'}
      {type: 'td', nesting: -1}
      {type: 'tr', nesting: -1}
      {type: 'tbody', nesting: -1}
      {type: 'table', nesting: -1}
      {type: 'document', nesting: -1}
    ], null, cb
