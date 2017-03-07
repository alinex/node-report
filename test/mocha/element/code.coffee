### eslint-env node, mocha ###
test = require '../test'
async = require 'async'

Report = require '../../../src'
before (cb) -> Report.init cb

describe "code", ->

  describe "examples", ->
    @timeout 30000

    it "should make example for bash", (cb) ->
      test.markdown 'code/bash', """
        ``` bash
        #!/bin/bash

        ###### CONFIG

        ACCEPTED_HOSTS="/root/.hag_accepted.conf"
        BE_VERBOSE=false

        if [ "$UID" -ne 0 ]
        then
         echo "Superuser rights required"
         exit 2
        fi

        genApacheConf(){
         echo -e "# Host ${HOME_DIR}$1/$2 :"
        }
        ```
      """, null, true, cb

    it "should make example for coffeescript", (cb) ->
      test.markdown 'code/coffeescript', """
        ``` coffee
        grade = (student, period=(if b? then 7 else 6)) ->
          if student.excellentWork
            "A+"
          else if student.okayStuff
            if student.triedHard then "B" else "B-"
          else
            "C"

        class Animal extends Being
          constructor: (@name) ->

          move: (meters) ->
            alert @name + " moved \#{meters}m."
        ```
      """, null, true, cb

    it "should make example for c++", (cb) ->
      test.markdown 'code/cpp', """
        ``` cpp
        #include <iostream>

        int main(int argc, char *argv[]) {

          /* An annoying "Hello World" example */
          for (auto i = 0; i < 0xFFFF; i++)
            cout << "Hello, World!" << endl;

          char c = '\\n';
          unordered_map <string, vector<string> > m;
          m["key"] = "\\\\\\\\"; // this is an error

          return -2e3 + 12l;
        }
        ```
      """, null, true, cb

    it "should make example for css", (cb) ->
      test.markdown 'code/css', """
        ``` css
        @font-face {
          font-family: Chunkfive; src: url('Chunkfive.otf');
        }

        body, .usertext {
          color: #F0F0F0; background: #600;
          font-family: Chunkfive, sans;
        }

        @import url(print.css);
        @media print {
          a[href^=http]::after {
            content: attr(href)
          }
        }
        ```
      """, null, true, cb

    it "should make example for ini", (cb) ->
      test.markdown 'code/ini', """
        ``` ini
        ; boilerplate
        [package]
        name = "some_name"
        authors = ["Author"]
        description = "This is \
        a description"

        [[lib]]
        name = ${NAME}
        default = True
        auto = no
        counter = 1_000
        ```
      """, null, true, cb

    it "should make example for java", (cb) ->
      test.markdown 'code/java', """
        ``` java
        /**
         * @author John Smith <john.smith@example.com>
        */
        package l2f.gameserver.model;

        public abstract class L2Char extends L2Object {
          public static final Short ERROR = 0x0001;

          public void moveTo(int x, int y, int z) {
            _ai = null;
            log("Should not be called");
            if (1 > 5) { // wtf!?
              return;
            }
          }
        }
        ```
      """, null, true, cb

    it "should make example for javascript", (cb) ->
      test.markdown 'code/javascript', """
        ``` javascript
        function $initHighlight(block, cls) {
          try {
            if (cls.search(/\\bno\-highlight\\b/) != -1)
              return process(block, true, 0x0F) +
                     ` class="${cls}"`;
          } catch (e) {
            /* handle exception */
          }
          for (var i = 0 / 2; i < classes.length; i++) {
            if (checkCondition(classes[i]) === undefined)
              console.log('undefined');
          }
        }

        export  $initHighlight;
        ```
      """, null, true, cb

    it "should make example for json", (cb) ->
      test.markdown 'code/json', """
        ``` json
        [
          {
            "title": "apples",
            "count": [12000, 20000],
            "description": {"text": "...", "sensitive": false}
          },
          {
            "title": "oranges",
            "count": [17500, null],
            "description": {"text": "...", "sensitive": false}
          }
        ]
        ```
      """, null, true, cb

    it "should make example for markdown", (cb) ->
      test.markdown 'code/markdown', """
        ``` markdown
        # hello world

        you can write text [with links](http://example.com) inline or [link references][1].

        * one _thing_ has *em*phasis
        * two __things__ are **bold**

        [1]: http://example.com

        ---

        hello world
        ===========

        <this_is inline="xml"></this_is>

        > markdown is so cool

            so are code segments

        1. one thing (yeah!)
        2. two thing `i can write code`, and `more` wipee!
        ```
      """, null, true, cb

    it "should make example for perl", (cb) ->
      test.markdown 'code/perl', """
        ``` perl
        # loads object
        sub load
        {
          my $flds = $c->db_load($id,@_) || do {
            Carp::carp "Can`t load (class: $c, id: $id): '$!'"; return undef
          };
          my $o = $c->_perl_new();
          $id12 = $id / 24 / 3600;
          $o->{'ID'} = $id12 + 123;
          #$o->{'SHCUT'} = $flds->{'SHCUT'};
          my $p = $o->props;
          my $vt;
          $string =~ m/^sought_text$/;
          $items = split //, 'abc';
          $string //= "bar";
          for my $key (keys %$p)
          {
            if(${$vt.'::property'}) {
              $o->{$key . '_real'} = $flds->{$key};
              tie $o->{$key}, 'CMSBuilder::Property', $o, $key;
            }
          }
          $o->save if delete $o->{'_save_after_load'};

          # GH-117
          my $g = glob("/usr/bin/*");

          return $o;
        }

        __DATA__
        @@ layouts/default.html.ep
        <!DOCTYPE html>
        <html>
          <head><title><%= title %></title></head>
          <body><%= content %></body>
        </html>
        __END__

        =head1 NAME
        POD till the end of file
        ```
      """, null, true, cb

    it "should make example for php", (cb) ->
      test.markdown 'code/php', """
        ``` php
        require_once 'Zend/Uri/Http.php';

        namespace Location\\Web;

        interface Factory
        {
            static function _factory();
        }

        abstract class URI extends BaseURI implements Factory
        {
            abstract function test();

            public static $st1 = 1;
            const ME = "Yo";
            var $list = NULL;
            private $var;

            /**
             * Returns a URI
             *
             * @return URI
             */
            static public function _factory($stats = array(), $uri = 'http')
            {
                echo __METHOD__;
                $uri = explode(':', $uri, 0b10);
                $schemeSpecific = isset($uri[1]) ? $uri[1] : '';
                $desc = 'Multi
        line description';

                // Security check
                if (!ctype_alnum($scheme)) {
                    throw new Zend_Uri_Exception('Illegal scheme');
                }

                $this->var = 0 - self::$st;
                $this->list = list(Array("1"=> 2, 2=>self::ME, 3 => \\Location\\Web\\URI::class));

                return [
                    'uri'   => $uri,
                    'value' => null,
                ];
            }
        }

        echo URI::ME . URI::$st1;

        __halt_compiler () ; datahere
        datahere
        datahere */
        datahere
        ```
      """, null, true, cb

    it "should make example for python", (cb) ->
      test.markdown 'code/python', """
        ``` python
        @requires_authorization
        def somefunc(param1='', param2=0):
            r'''A docstring'''
            if param1 > param2: # interesting
                print 'Gre\\'ater'
            return (param2 - param1 + 1 + 0b10l) or None

        class SomeClass:
            pass

        >>> message = '''interpreter
        ... prompt'''
      ```
      """, null, true, cb

    it "should make example for sql", (cb) ->
      test.markdown 'code/sql', """
        ``` sql
        CREATE TABLE "topic" (
            "id" serial NOT NULL PRIMARY KEY,
            "forum_id" integer NOT NULL,
            "subject" varchar(255) NOT NULL
        );
        ALTER TABLE "topic"
        ADD CONSTRAINT forum_id FOREIGN KEY ("forum_id")
        REFERENCES "forum" ("id");

        -- Initials
        insert into "topic" ("forum_id", "subject")
        values (2, 'D''artagnian');
        ```
      """, null, true, cb

    it "should make example for html", (cb) ->
      test.markdown 'code/html', """
        ``` html
        <!DOCTYPE html>
        <title>Title</title>

        <style>body {width: 500px;}</style>

        <script type="application/javascript">
          function $init() {return true;}
        </script>

        <body>
          <p checked class="title" id='title'>Title</p>
          <!-- here goes the rest of the page -->
        </body>
        ```
      """, null, true, cb

    it "should make example for handlebars", (cb) ->
      test.markdown 'code/handlebars', """
        ``` handlebars
        <div class="entry">
          {{!-- only show if author exists --}}
          {{#if author}}
            <h1>{{firstName}} {{lastName}}</h1>
          {{/if}}
        </div>
        ```
      """, null, true, cb

    it "should make example for stylus", (cb) ->
      test.markdown 'code/stylus', """
        ``` stylus
        @import "nib"

        // variables
        $green = #008000
        $green_dark = darken($green, 10)

        // mixin/function
        container()
          max-width 980px

        // mixin/function with parameters
        buttonBG($color = green)
          if $color == green
            background-color #008000
          else if $color == red
            background-color #B22222

        button
          buttonBG(red)

        #content, .content
          font Tahoma, Chunkfive, sans-serif
          background url('hatch.png')
          color #F0F0F0 !important
          width 100%
        ```
      """, null, true, cb

    it "should make example for less", (cb) ->
      test.markdown 'code/less', """
        ``` less
        @import "fruits";

        @rhythm: 1.5em;

        @media screen and (min-resolution: 2dppx) {
            body {font-size: 125%}
        }

        section > .foo + #bar:hover [href*="less"] {
            margin:     @rhythm 0 0 @rhythm;
            padding:    calc(5% + 20px);
            background: #f00ba7 url(http://placehold.alpha-centauri/42.png) no-repeat;
            background-image: linear-gradient(-135deg, wheat, fuchsia) !important ;
            background-blend-mode: multiply;
        }

        @font-face {
            font-family: /* ? */ 'Omega';
            src: url('../fonts/omega-webfont.woff?v=2.0.2');
        }

        .icon-baz::before {
            display:     inline-block;
            font-family: "Omega", Alpha, sans-serif;
            content:     "\\f085";
            color:       rgba(98, 76 /* or 54 */, 231, .75);
        }
        ```
      """, null, true, cb

  describe "api", ->

    it "should create code text section", (cb) ->
      # create report
      report = new Report()
      report.code 'text = \'foo\';', 'js'
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'code', nesting: 1, language: 'javascript'}
        {type: 'text', content: 'text = \'foo\';'}
        {type: 'code', nesting: -1}
        {type: 'document', nesting: -1}
      ], [
        {format: 'md', text: '``` javascript\ntext = \'foo\';\n```'}
        {format: 'text', re: /foo/}
        {format: 'html', text: "<pre><code>text = &#39;foo&#39;;</code></pre>\n"}
        {format: 'man', text: '.P\n.RS 2\n.nf\ntext = \'foo\';\n.fi\n.RE'}
      ], cb

    it "should create in multiple steps", (cb) ->
      # create report
      report = new Report()
      report.code true, 'js'
      report.text 'text = \'foo\';'
      report.code false
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'code', nesting: 1, language: 'javascript'}
        {type: 'text', content: 'text = \'foo\';'}
        {type: 'code', nesting: -1}
        {type: 'document', nesting: -1}
      ], [
        {format: 'md', text: '``` javascript\ntext = \'foo\';\n```'}
        {format: 'text', re: /foo/}
        {format: 'html', text: "<pre><code>text = &#39;foo&#39;;</code></pre>\n"}
        {format: 'man', text: '.P\n.RS 2\n.nf\ntext = \'foo\';\n.fi\n.RE'}
      ], cb
