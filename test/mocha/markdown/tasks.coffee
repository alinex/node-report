### eslint-env node, mocha ###
test = require '../test'
async = require 'async'

Report = require '../../../src'
before (cb) -> Report.init cb

describe.skip "markdown tasks", ->

  it "should add simple list", (cb) ->
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
      {type: 'item', nesting: 1}
      {type: 'paragraph', nesting: 1}
      {type: 'text', content: 'one'}
      {type: 'paragraph', nesting: -1}
      {type: 'paragraph', nesting: 1}
      {type: 'text', content: 'two'}
      {type: 'paragraph', nesting: -1}
      {type: 'item', nesting: -1}
      {type: 'list', nesting: -1}
      {type: 'document', nesting: -1}
    ], null, cb

#<ul class="contains-task-list">
#<li class="task-list-item"><input class="task-list-item-checkbox" disabled="" type="checkbox"> one</li>
#<li class="task-list-item"><input class="task-list-item-checkbox" checked="" disabled="" type="checkbox"> two</li>
#<li>test</li>
#</ul>
