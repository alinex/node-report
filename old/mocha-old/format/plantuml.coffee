### eslint-env node, mocha ###
Report = require '../../../src/index'
test = require '../test'

describe "visual plantuml", ->
  @timeout 30000

  it "should create simple plantuml", (cb) ->
    report = new Report()
    report.plantuml "A -> B: Hello"
    test.report 'plantuml', report, """

      $$$ plantuml
      A -> B: Hello
      $$$

      """, null, cb

  it "should create sequence diagram", (cb) ->
    report = new Report()
    report.plantuml """
      participant User

      User -> A: DoWork
      activate A #FFBBBB

      A -> A: Internal call
      activate A #DarkSalmon

      A -> B: << createRequest >>
      activate B

      B --> A: RequestCreated
      deactivate B
      deactivate A
      A -> User: Done
      deactivate A
      """
    test.report 'plantuml-sequence', report, null, null, cb

  it "should create use case diagram", (cb) ->
    report = new Report()
    report.plantuml """
      :Main Admin: as Admin
      (Use the application) as (Use)

      User -> (Start)
      User --> (Use)

      Admin ---> (Use)

      note right of Admin : This is an example.

      note right of (Use)
        A note can also
        be on several lines
      end note

      note "This note is connected to several objects." as N2
      (Start) .. N2
      N2 .. (Use)
      """
    test.report 'plantuml-usecase', report, null, null, cb

  it "should create class diagram", (cb) ->
    report = new Report()
    report.plantuml """
      class Foo1 {
        You can use
        several lines
        ..
        as you want
        and group
        ==
        things together.
        __
        You can have as many groups
        as you want
        --
        End of class
      }

      class User {
        .. Simple Getter ..
        + getName()
        + getAddress()
        .. Some setter ..
        + setName()
        __ private data __
        int age
        -- encrypted --
        String password
      }
      """
    test.report 'plantuml-class', report, null, null, cb

  it "should create activity diagram (old syntax)", (cb) ->
    report = new Report()
    report.plantuml """
      (*) --> "Initialization"

      if "Some Test" then
        -->[true] "Some Activity"
        --> "Another activity"
        -right-> (*)
      else
        ->[false] "Something else"
        -->[Ending process] (*)
      endif
      """
    test.report 'plantuml-activity-old', report, null, null, cb

  it "should create activity diagram (new syntax)", (cb) ->
    report = new Report()
    report.plantuml """
      :Ready;
      :next(o)|
      :Receiving;
      split
       :nak(i)<
       :ack(o)>
      split again
       :ack(i)<
       :next(o)
       on several line|
       :i := i + 1]
       :ack(o)>
      split again
       :err(i)<
       :nak(o)>
      split again
       :foo/
      split again
       :i > 5}
      stop
      end split
      :finish;
      """
    test.report 'plantuml-activity-new', report, null, null, cb

  it "should create component diagram", (cb) ->
    report = new Report()
    report.plantuml """
      package "Some Group" {
        HTTP - [First Component]
        [Another Component]
      }

      node "Other Groups" {
        FTP - [Second Component]
        [First Component] --> FTP
      }

      cloud {
        [Example 1]
      }


      database "MySql" {
        folder "This is my folder" {
          [Folder 3]
        }
        frame "Foo" {
          [Frame 4]
        }
      }

      [Another Component] --> [Example 1]
      [Example 1] --> [Folder 3]
      [Folder 3] --> [Frame 4]
      """
    test.report 'plantuml-component', report, null, null, cb

  it "should create state diagram", (cb) ->
    report = new Report()
    report.plantuml """
      scale 350 width
      [*] --> NotShooting

      state NotShooting {
        [*] --> Idle
        Idle --> Configuring : EvConfig
        Configuring --> Idle : EvConfig
      }

      state Configuring {
        [*] --> NewValueSelection
        NewValueSelection --> NewValuePreview : EvNewValue
        NewValuePreview --> NewValueSelection : EvNewValueRejected
        NewValuePreview --> NewValueSelection : EvNewValueSaved

        state NewValuePreview {
           State1 -> State2
        }

      }
      """
    test.report 'plantuml-state', report, null, null, cb

  it "should create deployment diagram", (cb) ->
    report = new Report()
    report.plantuml """
      artifact artifact
      actor actor
      folder folder
      node node
      frame frame
      cloud cloud
      database database
      storage storage
      agent agent
      usecase usecase
      component component
      boundary boundary
      control control
      entity entity
      interface interface
      """
    test.report 'plantuml-deployment', report, null, null, cb

  it "should create object diagram", (cb) ->
    report = new Report()
    report.plantuml """
      object user {
        name = "Dummy"
        id = 123
      }
      """
    test.report 'plantuml-object', report, null, null, cb

  it "should create wireframe", (cb) ->
    report = new Report()
    report.plantuml """
      salt
      {+
      {/ <b>General | Fullscreen | Behavior | Saving }
      {
      	{ Open image in: | ^Smart Mode^ }
      	[X] Smooth images when zoomed
      	[X] Confirm image deletion
      	[ ] Show hidden images
      }
      [Close]
      }
      """
    test.report 'plantuml-wireframe', report, null, null, cb
