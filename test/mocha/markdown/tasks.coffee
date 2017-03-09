### eslint-env node, mocha ###
test = require '../test'
async = require 'async'

Report = require '../../../src'
before (cb) -> Report.init cb

describe "markdown tasks", ->

  it "should add bullet list", (cb) ->
    test.markdown null, """
      - [ ] Mercury
      - [x] Venus
      - [x] Earth (Orbit/Moon)
      - [x] Mars
      - Jupiter
      - [ ] Saturn
      - [ ] Uranus
      - [ ] Neptune
      - [ ] Comet Haley
      """, [
      {type: 'document', nesting: 1}
      {type: 'list', nesting: 1, list: 'bullet'}
      {type: 'item', nesting: 1, task: false}
      {type: 'paragraph', nesting: 1}, {type: 'text', content: 'Mercury'}, {type: 'paragraph', nesting: -1}
      {type: 'item', nesting: -1}
      {type: 'item', nesting: 1, task: true}
      {type: 'paragraph', nesting: 1}, {type: 'text', content: 'Venus'}, {type: 'paragraph', nesting: -1}
      {type: 'item', nesting: -1}
      {type: 'item', nesting: 1, task: true}
      {type: 'paragraph', nesting: 1}, {type: 'text', content: 'Earth (Orbit/Moon)'}, {type: 'paragraph', nesting: -1}
      {type: 'item', nesting: -1}
      {type: 'item', nesting: 1, task: true}
      {type: 'paragraph', nesting: 1}, {type: 'text', content: 'Mars'}, {type: 'paragraph', nesting: -1}
      {type: 'item', nesting: -1}
      {type: 'item', nesting: 1, task: undefined}
      {type: 'paragraph', nesting: 1}, {type: 'text', content: 'Jupiter'}, {type: 'paragraph', nesting: -1}
      {type: 'item', nesting: -1}
      {type: 'item', nesting: 1, task: false}
      {type: 'paragraph', nesting: 1}, {type: 'text', content: 'Saturn'}, {type: 'paragraph', nesting: -1}
      {type: 'item', nesting: -1}
      {type: 'item', nesting: 1, task: false}
      {type: 'paragraph', nesting: 1}, {type: 'text', content: 'Uranus'}, {type: 'paragraph', nesting: -1}
      {type: 'item', nesting: -1}
      {type: 'item', nesting: 1, task: false}
      {type: 'paragraph', nesting: 1}, {type: 'text', content: 'Neptune'}, {type: 'paragraph', nesting: -1}
      {type: 'item', nesting: -1}
      {type: 'item', nesting: 1, task: false}
      {type: 'paragraph', nesting: 1}, {type: 'text', content: 'Comet Haley'}, {type: 'paragraph', nesting: -1}
      {type: 'item', nesting: -1}
      {type: 'list', nesting: -1}
      {type: 'document', nesting: -1}
    ], null, cb

  it "should add ordered list", (cb) ->
    test.markdown null, """
      1. [ ] Mercury
      2. [x] Venus
      3. [x] Earth (Orbit/Moon)
      4. [x] Mars
      5. Jupiter
      6. [ ] Saturn
      7. [ ] Uranus
      8. [ ] Neptune
      9. [ ] Comet Haley
      """, [
      {type: 'document', nesting: 1}
      {type: 'list', nesting: 1, list: 'ordered'}
      {type: 'item', nesting: 1, task: false}
      {type: 'paragraph', nesting: 1}, {type: 'text', content: 'Mercury'}, {type: 'paragraph', nesting: -1}
      {type: 'item', nesting: -1}
      {type: 'item', nesting: 1, task: true}
      {type: 'paragraph', nesting: 1}, {type: 'text', content: 'Venus'}, {type: 'paragraph', nesting: -1}
      {type: 'item', nesting: -1}
      {type: 'item', nesting: 1, task: true}
      {type: 'paragraph', nesting: 1}, {type: 'text', content: 'Earth (Orbit/Moon)'}, {type: 'paragraph', nesting: -1}
      {type: 'item', nesting: -1}
      {type: 'item', nesting: 1, task: true}
      {type: 'paragraph', nesting: 1}, {type: 'text', content: 'Mars'}, {type: 'paragraph', nesting: -1}
      {type: 'item', nesting: -1}
      {type: 'item', nesting: 1, task: undefined}
      {type: 'paragraph', nesting: 1}, {type: 'text', content: 'Jupiter'}, {type: 'paragraph', nesting: -1}
      {type: 'item', nesting: -1}
      {type: 'item', nesting: 1, task: false}
      {type: 'paragraph', nesting: 1}, {type: 'text', content: 'Saturn'}, {type: 'paragraph', nesting: -1}
      {type: 'item', nesting: -1}
      {type: 'item', nesting: 1, task: false}
      {type: 'paragraph', nesting: 1}, {type: 'text', content: 'Uranus'}, {type: 'paragraph', nesting: -1}
      {type: 'item', nesting: -1}
      {type: 'item', nesting: 1, task: false}
      {type: 'paragraph', nesting: 1}, {type: 'text', content: 'Neptune'}, {type: 'paragraph', nesting: -1}
      {type: 'item', nesting: -1}
      {type: 'item', nesting: 1, task: false}
      {type: 'paragraph', nesting: 1}, {type: 'text', content: 'Comet Haley'}, {type: 'paragraph', nesting: -1}
      {type: 'item', nesting: -1}
      {type: 'list', nesting: -1}
      {type: 'document', nesting: -1}
    ], null, cb
