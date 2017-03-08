### eslint-env node, mocha ###
test = require '../test'
async = require 'async'

Report = require '../../../src'
before (cb) -> Report.init cb

describe "code", ->

  describe "examples", ->
    @timeout 30000

    it "should make example for asciidoc", (cb) ->
      test.markdown 'code/asciidoc', """
        ``` asciidoc
        Hello, World!
        ============
        Author Name, <author@domain.foo>

        you can write text http://example.com[with links], optionally
        using an explicit link:http://example.com[link prefix].

        * single quotes around a phrase place 'emphasis'
        ** alternatively, you can put underlines around a phrase to add _emphasis_
        * astericks around a phrase make the text *bold*
        * pluses around a phrase make it +monospaced+
        * `smart' quotes using a leading backtick and trailing single quote
        ** use two of each for double ``smart'' quotes

        - escape characters are supported
        - you can escape a quote inside emphasized text like 'here\'s johnny!'

        term:: definition
         another term:: another definition

        // this is just a comment

        Let's make a break.

        '''

        ////
        we'll be right with you

        after this brief interruption.
        ////

        == We're back!

        Want to see a image::images/tiger.png[Tiger]?

        .Nested highlighting
        ++++
        <this_is inline="xml"></this_is>
        ++++

        ____
        asciidoc is so powerful.
        ____

        another quote:

        [quote, Sir Arthur Conan Doyle, The Adventures of Sherlock Holmes]
        ____
        When you have eliminated all which is impossible, then whatever remains, however improbable, must be the truth.
        ____

        Getting Literal
        ---------------

         want to get literal? prefix a line with a space.

        ....
        I'll join that party, too.
        ....

        . one thing (yeah!)
        . two thing `i can write code`, and `more` wipee!

        NOTE: AsciiDoc is quite cool, you should try it.
        ```
      """, null, true, cb

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

    it "should make example for c#", (cb) ->
      test.markdown 'code/csharp', """
        ``` csharp
        using System;

        #pragma warning disable 414, 3021

        /// <summary>Main task</summary>
        async Task<int, int> AccessTheWebAsync()
        {
            Console.WriteLine("Hello, World!");
            string urlContents = await getStringTask;
            return urlContents.Length;
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

    it "should make example for diff", (cb) ->
      test.markdown 'code/diff', """
        ``` diff
        Index: languages/ini.js
        ===================================================================
        --- languages/ini.js    (revision 199)
        +++ languages/ini.js    (revision 200)
        @@ -1,8 +1,7 @@
         hljs.LANGUAGES.ini =
         {
           case_insensitive: true,
        -  defaultMode:
        -  {
        +  defaultMode: {
             contains: ['comment', 'title', 'setting'],
             illegal: '[^\\\\s]'
           },

        *** /path/to/original timestamp
        --- /path/to/new      timestamp
        ***************
        *** 1,3 ****
        --- 1,9 ----
        + This is an important
        + notice! It should
        + therefore be located at
        + the beginning of this
        + document!

        ! compress the size of the
        ! changes.

          It is important to spell
        ```
      """, null, true, cb

    it "should make example for go", (cb) ->
      test.markdown 'code/go', """
        ``` go
        package main

        import "fmt"

        func main() {
            ch := make(chan float64)
            ch <- 1.0e10    // magic number
            x, ok := <- ch
            defer fmt.Println(`exitting now\\`)
            go println(len("hello world!"))
            return
        }
        ```
      """, null, true, cb

    it "should make example for groovy", (cb) ->
      test.markdown 'code/groovy', """
        ```` groovy
        #!/usr/bin/env groovy
        package model

        import groovy.transform.CompileStatic
        import java.util.List as MyList

        trait Distributable {
            void distribute(String version) {}
        }

        @CompileStatic
        class Distribution implements Distributable {
            double number = 1234.234 / 567
            def otherNumber = 3 / 4
            boolean archivable = condition ?: true
            def ternary = a ? b : c
            String name = "Guillaume"
            Closure description = null
            List<DownloadPackage> packages = []
            String regex = ~/.*foo.*/
            String multi = '''
                multi line string
            ''' + ""\"
                now with double quotes and ${gstring}
            ""\" + $/
                even with dollar slashy strings
            /$

            /**
             * description method
             * @param cl the closure
             */
            void description(Closure cl) { this.description = cl }

            void version(String name, Closure versionSpec) {
                def closure = { println "hi" } as Runnable

                MyList ml = [1, 2, [a: 1, b:2,c :3]]
                for (ch in "name") {}

                // single line comment
                DownloadPackage pkg = new DownloadPackage(version: name)

                check that: true

                label:
                def clone = versionSpec.rehydrate(pkg, pkg, pkg)
                /*
                    now clone() in a multiline comment
                */
                clone()
                packages.add(pkg)

                assert 4 / 2 == 2
            }
        }
        ````
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

    it "should make example for http", (cb) ->
      test.markdown 'code/http', """
        ``` http
        POST /task?id=1 HTTP/1.1
        Host: example.org
        Content-Type: application/json; charset=utf-8
        Content-Length: 137

        {
          "status": "ok",
          "extended": true,
          "results": [
            {"value": 0, "type": "int64"},
            {"value": 1.0e+3, "type": "decimal"}
          ]
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

    it "should make example for lisp", (cb) ->
      test.markdown 'code/lisp', """
        ``` lisp
        #!/usr/bin/env csi

        (defun prompt-for-cd ()
           "Prompts
            for CD"
           (prompt-read "Title" 1.53 1 2/4 1.7 1.7e0 2.9E-4 +42 -7 #b001 #b001/100 #o777 #O777 #xabc55 #c(0 -5.6))
           (prompt-read "Artist" &rest)
           (or (parse-integer (prompt-read "Rating") :junk-allowed t) 0)
          (if x (format t "yes") (format t "no" nil) ;and here comment
          )
          ;; second line comment
          '(+ 1 2)
          (defvar *lines*)                ; list of all lines
          (position-if-not #'sys::whitespacep line :start beg))
          (quote (privet 1 2 3))
          '(hello world)
          (* 5 7)
          (1 2 34 5)
          (:use "aaaa")
          (let ((x 10) (y 20))
            (print (+ x y))
          )
        ```
      """, null, true, cb

    it "should make example for lua", (cb) ->
      test.markdown 'code/lua', """
        ``` lua
        --[[
        Simple signal/slot implementation
        ]]
        local signal_mt = {
            __index = {
                register = table.insert
            }
        }
        function signal_mt.__index:emit(... --[[ Comment in params ]])
            for _, slot in ipairs(self) do
                slot(self, ...)
            end
        end
        local function create_signal()
            return setmetatable({}, signal_mt)
        end

        -- Signal test
        local signal = create_signal()
        signal:register(function(signal, ...)
            print(...)
        end)
        signal:emit('Answer to Life, the Universe, and Everything:', 42)

        --[==[ [=[ [[
        Nested ]]
        multi-line ]=]
        comment ]==]
        [==[ Nested
        [=[ multi-line
        [[ string
        ]] ]=] ]==]
        ```
      """, null, true, cb

    it "should make example for makefile", (cb) ->
      test.markdown 'code/makefile', """
        ``` makefile
        # Makefile

        BUILDDIR      = _build
        EXTRAS       ?= $(BUILDDIR)/extras

        .PHONY: main clean

        main:
        	@echo "Building main facility..."
        	build_main $(BUILDDIR)

        clean:
        	rm -rf $(BUILDDIR)/*
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

    it "should make example for ruby", (cb) ->
      test.markdown 'code/ruby', """
        ``` ruby
        # The Greeter class
        class Greeter
          def initialize(name)
            @name = name.capitalize
          end

          def salute
            puts "Hello #{@name}!"
          end
        end

        g = Greeter.new("world")
        g.salute
        ```
      """, null, true, cb

    it "should make example for scala", (cb) ->
      test.markdown 'code/scala', """
        ``` scala
        /**
         * A person has a name and an age.
         */
        case class Person(name: String, age: Int)

        abstract class Vertical extends CaseJeu
        case class Haut(a: Int) extends Vertical
        case class Bas(name: String, b: Double) extends Vertical

        sealed trait Ior[+A, +B]
        case class Left[A](a: A) extends Ior[A, Nothing]
        case class Right[B](b: B) extends Ior[Nothing, B]
        case class Both[A, B](a: A, b: B) extends Ior[A, B]

        trait Functor[F[_]] {
          def map[A, B](fa: F[A], f: A => B): F[B]
        }

        // beware Int.MinValue
        def absoluteValue(n: Int): Int =
          if (n < 0) -n else n

        def interp(n: Int): String =
          s"there are $n ${color} balloons.\\n"

        type ξ[A] = (A, A)

        trait Hist { lhs =>
          def ⊕(rhs: Hist): Hist
        }

        def gsum[A: Ring](as: Seq[A]): A =
          as.foldLeft(Ring[A].zero)(_ + _)

        val actions: List[Symbol] =
          'init :: 'read :: 'write :: 'close :: Nil

        trait Cake {
          type T;
          type Q
          val things: Seq[T]

          abstract class Spindler

          def spindle(s: Spindler, ts: Seq[T], reversed: Boolean = false): Seq[Q]
        }

        val colors = Map(
          "red"       -> 0xFF0000,
          "turquoise" -> 0x00FFFF,
          "black"     -> 0x000000,
          "orange"    -> 0xFF8040,
          "brown"     -> 0x804000)

        lazy val ns = for {
          x <- 0 until 100
          y <- 0 until 100
        } yield (x + y) * 33.33
        ```
      """, null, true, cb

    it "should make example for scheme", (cb) ->
      test.markdown 'code/scheme', """
        ``` scheme
        ;; Calculation of Hofstadter's male and female sequences as a list of pairs

        (define (hofstadter-male-female n)
        (letrec ((female (lambda (n)
                   (if (= n 0)
                   1
                   (- n (male (female (- n 1)))))))
             (male (lambda (n)
                 (if (= n 0)
                     0
                     (- n (female (male (- n 1))))))))
          (let loop ((i 0))
            (if (> i n)
            '()
            (cons (cons (female i)
                    (male i))
              (loop (+ i 1)))))))

        (hofstadter-male-female 8)

        (define (find-first func lst)
        (call-with-current-continuation
         (lambda (return-immediately)
           (for-each (lambda (x)
               (if (func x)
                   (return-immediately x)))
                 lst)
           #f)))
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

    it "should make example for tex", (cb) ->
      test.markdown 'code/tex', """
        ``` tex
        \\documentclass{article}
        \\usepackage[koi8-r]{inputenc}
        \\hoffset=0pt
        \\voffset=.3em
        \\tolerance=400
        \\newcommand{\\eTiX}{\\TeX}
        \\begin{document}
        \\section*{Highlight.js}
        \\begin{table}[c|c]
        $\\frac 12\\, + \\, \\frac 1{x^3}\\text{Hello \\! world}$ & \\textbf{Goodbye\\~ world} \\\\\\eTiX $ \\pi=400 $
        \\end{table}
        Ch\\'erie, \\c{c}a ne me pla\\^\\i t pas! % comment \\b
        G\\"otterd\\"ammerung~45\\%=34.
        $$
            \\int\\limits_{0}^{\\pi}\\frac{4}{x-7}=3
        $$
        \\end{document}
        ```
      """, null, true, cb

    it "should make example for typescript", (cb) ->
      test.markdown 'code/typescript', """
        ``` typescript
        class MyClass {
          public static myValue: string;
          constructor(init: string) {
            this.myValue = init;
          }
        }
        import fs = require("fs");
        module MyModule {
          export interface MyInterface extends Other {
            myProperty: any;
          }
        }
        declare magicNumber number;
        myArray.forEach(() => { }); // fat arrow syntax
        ```
      """, null, true, cb

    it "should make example for xml", (cb) ->
      test.markdown 'code/xml', """
        ``` xml
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

    it "should make example for yaml", (cb) ->
      test.markdown 'code/yaml', """
        ``` yaml
        ---
        # comment
        string_1: "Bar"
        string_2: 'bar'
        string_3: bar
        inline_keys_ignored: sompath/name/file.jpg
        keywords_in_yaml:
          - true
          - false
          - TRUE
          - FALSE
          - 21
          - 21.0
          - !!str 123
        "quoted_key": &foobar
          bar: foo
          foo:
          "foo": bar

        reference: *foobar

        multiline_1: |
          Multiline
          String
        multiline_2: >
          Multiline
          String
        multiline_3: "
          Multiline string
          "

        ansible_variables: "foo {{variable}}"

        array_nested:
        - a
        - b: 1
          c: 2
        - b
        - comment
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
