### eslint-env node, mocha ###
Report = require '../../../src/index'
test = require '../test'

describe.only "signs", ->
  @timeout 10000

  it "should add typograph signs", (cb) ->
    report = new Report()
    report.h3 "classic typographs:"
    report.ul [
      "copyright:   (c) (C)"
      "registeres:  (r) (R) "
      "trademark:   (tm) (TM) "
      "paragraph:   (p) (P) "
      "math:        +-"
    ]
    test.report 'signs-typograph', report, """

      ### classic typographs:

      - copyright:   (c) (C)
      - registeres:  (r) (R)
      - trademark:   (tm) (TM)
      - paragraph:   (p) (P)
      - math:        +-

      """, """
      <body><h3 id="classic-typographs">classic typographs:</h3>
      <ul>
      <li>copyright:   © ©</li>
      <li>registeres:  ® ®</li>
      <li>trademark:   ™ ™</li>
      <li>paragraph:   § §</li>
      <li>math:        ±</li>
      </ul>
      </body>
      """, cb

  it "should add emoji images", (cb) ->
    report = new Report()
    report.h3 "emoji:"
    report.ul [
      """angry:            :angry:            >:(     >:-("""
      """blush:            :blush:            :")     :-")"""
      """broken_heart:     :broken_heart:     </3     <\\3"""
      """confused:         :confused:         :/      :-/"""
      """cry:              :cry:              :,(   :,-("""
      """frowning:         :frowning:         :(      :-("""
      """heart:            :heart:            <3"""
      """imp:              :imp:              ]:(     ]:-("""
      """innocent:         :innocent:         o:)   O:)   o:-)   O:-)   0:)   0:-)"""
      """joy:              :joy:              :,)      :,-)   :,D      :,-D"""
      """kissing:          :kissing:          :*      :-*"""
      """laughing:         :laughing:         x-)     X-)"""
      """neutral_face:     :neutral_face:     :|      :-|"""
      """open_mouth:       :open_mouth:       :o      :-o     :O      :-O"""
      """rage:             :rage:             :@      :-@"""
      """smile:            :smile:            :D      :-D"""
      """smiley:           :smiley:           :)      :-)"""
      """smiling_imp:      :smiling_imp:      ]:)     ]:-)"""
      """sob:              :sob:              ;(     ;-("""
      """stuck_out_tongue: :stuck_out_tongue: :P      :-P"""
      """sunglasses:       :sunglasses:       8-)     B-)"""
      """sweat:            :sweat:            ,:(     ,:-("""
      """sweat_smile:      :sweat_smile:      ,:)     ,:-)"""
      """unamused:         :unamused:         :s   :-S   :z   :-Z   :$   :-$"""
      """wink:             :wink:             ;)      ;-)"""
    ]
    test.report 'signs-emoji', report, """

      ### emoji:

      - angry:            :angry:            >:(     >:-(
      - blush:            :blush:            :")     :-")
      - broken_heart:     :broken_heart:     </3     <\\3
      - confused:         :confused:         :/      :-/
      - cry:              :cry:              :,(   :,-(
      - frowning:         :frowning:         :(      :-(
      - heart:            :heart:            <3
      - imp:              :imp:              ]:(     ]:-(
      - innocent:         :innocent:         o:)   O:)   o:-)   O:-)   0:)   0:-)
      - joy:              :joy:              :,)      :,-)   :,D      :,-D
      - kissing:          :kissing:          :*      :-*
      - laughing:         :laughing:         x-)     X-)
      - neutral_face:     :neutral_face:     :|      :-|
      - open_mouth:       :open_mouth:       :o      :-o     :O      :-O
      - rage:             :rage:             :@      :-@
      - smile:            :smile:            :D      :-D
      - smiley:           :smiley:           :)      :-)
      - smiling_imp:      :smiling_imp:      ]:)     ]:-)
      - sob:              :sob:              ;(     ;-(
      - stuck_out_tongue: :stuck_out_tongue: :P      :-P
      - sunglasses:       :sunglasses:       8-)     B-)
      - sweat:            :sweat:            ,:(     ,:-(
      - sweat_smile:      :sweat_smile:      ,:)     ,:-)
      - unamused:         :unamused:         :s   :-S   :z   :-Z   :$   :-$
      - wink:             :wink:             ;)      ;-)

      """, """
      <body><h3 id="emoji">emoji:</h3>
      <ul>
      <li>angry:            <img class="emoji" draggable="false" alt="😠" src="https://twemoji.maxcdn.com/72x72/1f620.png">            <img class="emoji" draggable="false" alt="😠" src="https://twemoji.maxcdn.com/72x72/1f620.png">     <img class="emoji" draggable="false" alt="😠" src="https://twemoji.maxcdn.com/72x72/1f620.png"></li>
      <li>blush:            <img class="emoji" draggable="false" alt="😊" src="https://twemoji.maxcdn.com/72x72/1f60a.png">            <img class="emoji" draggable="false" alt="😊" src="https://twemoji.maxcdn.com/72x72/1f60a.png">     <img class="emoji" draggable="false" alt="😊" src="https://twemoji.maxcdn.com/72x72/1f60a.png"></li>
      <li>broken_heart:     <img class="emoji" draggable="false" alt="💔" src="https://twemoji.maxcdn.com/72x72/1f494.png">     <img class="emoji" draggable="false" alt="💔" src="https://twemoji.maxcdn.com/72x72/1f494.png">     <img class="emoji" draggable="false" alt="💔" src="https://twemoji.maxcdn.com/72x72/1f494.png"></li>
      <li>confused:         <img class="emoji" draggable="false" alt="😕" src="https://twemoji.maxcdn.com/72x72/1f615.png">         <img class="emoji" draggable="false" alt="😕" src="https://twemoji.maxcdn.com/72x72/1f615.png">      <img class="emoji" draggable="false" alt="😕" src="https://twemoji.maxcdn.com/72x72/1f615.png"></li>
      <li>cry:              <img class="emoji" draggable="false" alt="😢" src="https://twemoji.maxcdn.com/72x72/1f622.png">              <img class="emoji" draggable="false" alt="😢" src="https://twemoji.maxcdn.com/72x72/1f622.png">   <img class="emoji" draggable="false" alt="😢" src="https://twemoji.maxcdn.com/72x72/1f622.png"></li>
      <li>frowning:         <img class="emoji" draggable="false" alt="😦" src="https://twemoji.maxcdn.com/72x72/1f626.png">         <img class="emoji" draggable="false" alt="😦" src="https://twemoji.maxcdn.com/72x72/1f626.png">      <img class="emoji" draggable="false" alt="😦" src="https://twemoji.maxcdn.com/72x72/1f626.png"></li>
      <li>heart:            <img class="emoji" draggable="false" alt="❤️" src="https://twemoji.maxcdn.com/72x72/2764.png">            <img class="emoji" draggable="false" alt="❤️" src="https://twemoji.maxcdn.com/72x72/2764.png"></li>
      <li>imp:              <img class="emoji" draggable="false" alt="👿" src="https://twemoji.maxcdn.com/72x72/1f47f.png">              <img class="emoji" draggable="false" alt="👿" src="https://twemoji.maxcdn.com/72x72/1f47f.png">     <img class="emoji" draggable="false" alt="👿" src="https://twemoji.maxcdn.com/72x72/1f47f.png"></li>
      <li>innocent:         <img class="emoji" draggable="false" alt="😇" src="https://twemoji.maxcdn.com/72x72/1f607.png">         <img class="emoji" draggable="false" alt="😇" src="https://twemoji.maxcdn.com/72x72/1f607.png">   <img class="emoji" draggable="false" alt="😇" src="https://twemoji.maxcdn.com/72x72/1f607.png">   <img class="emoji" draggable="false" alt="😇" src="https://twemoji.maxcdn.com/72x72/1f607.png">   <img class="emoji" draggable="false" alt="😇" src="https://twemoji.maxcdn.com/72x72/1f607.png">   <img class="emoji" draggable="false" alt="😇" src="https://twemoji.maxcdn.com/72x72/1f607.png">   <img class="emoji" draggable="false" alt="😇" src="https://twemoji.maxcdn.com/72x72/1f607.png"></li>
      <li>joy:              <img class="emoji" draggable="false" alt="😂" src="https://twemoji.maxcdn.com/72x72/1f602.png">              <img class="emoji" draggable="false" alt="😂" src="https://twemoji.maxcdn.com/72x72/1f602.png">      <img class="emoji" draggable="false" alt="😂" src="https://twemoji.maxcdn.com/72x72/1f602.png">   <img class="emoji" draggable="false" alt="😂" src="https://twemoji.maxcdn.com/72x72/1f602.png">      <img class="emoji" draggable="false" alt="😂" src="https://twemoji.maxcdn.com/72x72/1f602.png"></li>
      <li>kissing:          <img class="emoji" draggable="false" alt="😗" src="https://twemoji.maxcdn.com/72x72/1f617.png">          <img class="emoji" draggable="false" alt="😗" src="https://twemoji.maxcdn.com/72x72/1f617.png">      <img class="emoji" draggable="false" alt="😗" src="https://twemoji.maxcdn.com/72x72/1f617.png"></li>
      <li>laughing:         <img class="emoji" draggable="false" alt="😆" src="https://twemoji.maxcdn.com/72x72/1f606.png">         <img class="emoji" draggable="false" alt="😆" src="https://twemoji.maxcdn.com/72x72/1f606.png">     <img class="emoji" draggable="false" alt="😆" src="https://twemoji.maxcdn.com/72x72/1f606.png"></li>
      <li>neutral_face:     <img class="emoji" draggable="false" alt="😐" src="https://twemoji.maxcdn.com/72x72/1f610.png">     <img class="emoji" draggable="false" alt="😐" src="https://twemoji.maxcdn.com/72x72/1f610.png">      <img class="emoji" draggable="false" alt="😐" src="https://twemoji.maxcdn.com/72x72/1f610.png"></li>
      <li>open_mouth:       <img class="emoji" draggable="false" alt="😮" src="https://twemoji.maxcdn.com/72x72/1f62e.png">       <img class="emoji" draggable="false" alt="😮" src="https://twemoji.maxcdn.com/72x72/1f62e.png">      <img class="emoji" draggable="false" alt="😮" src="https://twemoji.maxcdn.com/72x72/1f62e.png">     <img class="emoji" draggable="false" alt="😮" src="https://twemoji.maxcdn.com/72x72/1f62e.png">      <img class="emoji" draggable="false" alt="😮" src="https://twemoji.maxcdn.com/72x72/1f62e.png"></li>
      <li>rage:             <img class="emoji" draggable="false" alt="😡" src="https://twemoji.maxcdn.com/72x72/1f621.png">             <img class="emoji" draggable="false" alt="😡" src="https://twemoji.maxcdn.com/72x72/1f621.png">      <img class="emoji" draggable="false" alt="😡" src="https://twemoji.maxcdn.com/72x72/1f621.png"></li>
      <li>smile:            <img class="emoji" draggable="false" alt="😄" src="https://twemoji.maxcdn.com/72x72/1f604.png">            <img class="emoji" draggable="false" alt="😄" src="https://twemoji.maxcdn.com/72x72/1f604.png">      <img class="emoji" draggable="false" alt="😄" src="https://twemoji.maxcdn.com/72x72/1f604.png"></li>
      <li>smiley:           <img class="emoji" draggable="false" alt="😃" src="https://twemoji.maxcdn.com/72x72/1f603.png">           <img class="emoji" draggable="false" alt="😃" src="https://twemoji.maxcdn.com/72x72/1f603.png">      <img class="emoji" draggable="false" alt="😃" src="https://twemoji.maxcdn.com/72x72/1f603.png"></li>
      <li>smiling_imp:      <img class="emoji" draggable="false" alt="😈" src="https://twemoji.maxcdn.com/72x72/1f608.png">      <img class="emoji" draggable="false" alt="😈" src="https://twemoji.maxcdn.com/72x72/1f608.png">     <img class="emoji" draggable="false" alt="😈" src="https://twemoji.maxcdn.com/72x72/1f608.png"></li>
      <li>sob:              <img class="emoji" draggable="false" alt="😭" src="https://twemoji.maxcdn.com/72x72/1f62d.png">              <img class="emoji" draggable="false" alt="😭" src="https://twemoji.maxcdn.com/72x72/1f62d.png">     <img class="emoji" draggable="false" alt="😭" src="https://twemoji.maxcdn.com/72x72/1f62d.png"></li>
      <li>stuck_out_tongue: <img class="emoji" draggable="false" alt="😛" src="https://twemoji.maxcdn.com/72x72/1f61b.png"> <img class="emoji" draggable="false" alt="😛" src="https://twemoji.maxcdn.com/72x72/1f61b.png">      <img class="emoji" draggable="false" alt="😛" src="https://twemoji.maxcdn.com/72x72/1f61b.png"></li>
      <li>sunglasses:       <img class="emoji" draggable="false" alt="😎" src="https://twemoji.maxcdn.com/72x72/1f60e.png">       <img class="emoji" draggable="false" alt="😎" src="https://twemoji.maxcdn.com/72x72/1f60e.png">     <img class="emoji" draggable="false" alt="😎" src="https://twemoji.maxcdn.com/72x72/1f60e.png"></li>
      <li>sweat:            <img class="emoji" draggable="false" alt="😓" src="https://twemoji.maxcdn.com/72x72/1f613.png">            <img class="emoji" draggable="false" alt="😓" src="https://twemoji.maxcdn.com/72x72/1f613.png">     <img class="emoji" draggable="false" alt="😓" src="https://twemoji.maxcdn.com/72x72/1f613.png"></li>
      <li>sweat_smile:      <img class="emoji" draggable="false" alt="😅" src="https://twemoji.maxcdn.com/72x72/1f605.png">      <img class="emoji" draggable="false" alt="😅" src="https://twemoji.maxcdn.com/72x72/1f605.png">     <img class="emoji" draggable="false" alt="😅" src="https://twemoji.maxcdn.com/72x72/1f605.png"></li>
      <li>unamused:         <img class="emoji" draggable="false" alt="😒" src="https://twemoji.maxcdn.com/72x72/1f612.png">         <img class="emoji" draggable="false" alt="😒" src="https://twemoji.maxcdn.com/72x72/1f612.png">   <img class="emoji" draggable="false" alt="😒" src="https://twemoji.maxcdn.com/72x72/1f612.png">   <img class="emoji" draggable="false" alt="😒" src="https://twemoji.maxcdn.com/72x72/1f612.png">   <img class="emoji" draggable="false" alt="😒" src="https://twemoji.maxcdn.com/72x72/1f612.png">   <img class="emoji" draggable="false" alt="😒" src="https://twemoji.maxcdn.com/72x72/1f612.png">   <img class="emoji" draggable="false" alt="😒" src="https://twemoji.maxcdn.com/72x72/1f612.png"></li>
      <li>wink:             <img class="emoji" draggable="false" alt="😉" src="https://twemoji.maxcdn.com/72x72/1f609.png">             <img class="emoji" draggable="false" alt="😉" src="https://twemoji.maxcdn.com/72x72/1f609.png">      <img class="emoji" draggable="false" alt="😉" src="https://twemoji.maxcdn.com/72x72/1f609.png"></li>
      </ul>
      </body>
      """, cb

  it "should add fontawesome signs", (cb) ->
    report = new Report()
    report.h3 "fontawesome:"
    report.p "basic icons:   :fa-flag:    :fa-camera-retro:"
    report.p "larger icons:  :fa-camera-retro fa-lg: :fa-camera-retro fa-2x: :fa-camera-retro fa-3x:"
    report.p "fixed width:   :fa-home fa-fw:   :fa-pencil fa-fw:"
    report.ul [
      "<!-- {ul:.fa-ul}-->"
      "list symbols:  :fa-li fa-check-square:"
    ]
    report.p ":fa-quote-left fa-3x fa-pull-left fa-border:
      ...tomorrow we will run faster, stretch out our arms farther...
      And then one fine morning— So we beat on, boats against the
      current, borne back ceaselessly into the past."
    report.p "animated icons:    :fa-spinner fa-spin fa-2x fa-fw:
      :fa-circle-o-notch fa-spin fa-2x fa-fw:
      :fa-refresh fa-spin fa-2x fa-fw:
      :fa-cog fa-spin fa-2x fa-fw:
      :fa-spinner fa-pulse fa-2x fa-fw:"
    report.p "flipped and rotated:   :fa-shield: normal
      :fa-shield fa-rotate-90: fa-rotate-90
      :fa-shield fa-rotate-180: fa-rotate-180
      :fa-shield fa-rotate-270: fa-rotate-270
      :fa-shield fa-flip-horizontal: fa-flip-horizontal
      :fa-shield fa-flip-vertical: fa-flip-vertical"
    report.p "stacked icons:
      :fa-stack fa-lg fa-stack-2x fa-square-o fa-stack-1x fa-twitter:
      :fa-stack fa-lg fa-stack-2x fa-circle fa-stack-1x fa-flag fa-inverse:
      :fa-stack fa-lg fa-stack-2x fa-square fa-stack-1x fa-terminal fa-inverse:
      :fa-stack fa-lg fa-stack-1x fa-camera fa-stack-2x fa-ban text-danger:"
    test.report 'signs-fontawesome', report, """

      ### fontawesome:

      basic icons:   :fa-flag:    :fa-camera-retro:

      larger icons:  :fa-camera-retro fa-lg: :fa-camera-retro fa-2x: :fa-camera-retro
      fa-3x:

      fixed width:   :fa-home fa-fw:   :fa-pencil fa-fw:

      - <!-- {ul:.fa-ul}-->
      - list symbols:  :fa-li fa-check-square:

      :fa-quote-left fa-3x fa-pull-left fa-border: ...tomorrow we will run faster,
      stretch out our arms farther... And then one fine morning— So we beat on, boats
      against the current, borne back ceaselessly into the past.

      animated icons:    :fa-spinner fa-spin fa-2x fa-fw: :fa-circle-o-notch fa-spin
      fa-2x fa-fw: :fa-refresh fa-spin fa-2x fa-fw: :fa-cog fa-spin fa-2x fa-fw:
      :fa-spinner fa-pulse fa-2x fa-fw:

      flipped and rotated:   :fa-shield: normal :fa-shield fa-rotate-90: fa-rotate-90
      :fa-shield fa-rotate-180: fa-rotate-180 :fa-shield fa-rotate-270: fa-rotate-270
      :fa-shield fa-flip-horizontal: fa-flip-horizontal :fa-shield fa-flip-vertical:
      fa-flip-vertical

      stacked icons: :fa-stack fa-lg fa-stack-2x fa-square-o fa-stack-1x fa-twitter:
      :fa-stack fa-lg fa-stack-2x fa-circle fa-stack-1x fa-flag fa-inverse: :fa-stack
      fa-lg fa-stack-2x fa-square fa-stack-1x fa-terminal fa-inverse: :fa-stack fa-lg
      fa-stack-1x fa-camera fa-stack-2x fa-ban text-danger:

      """, """
      <body><h3 id="fontawesome">fontawesome:</h3>
      <p>basic icons:   <i class="fa fa-flag"></i>    <i class="fa fa-camera-retro"></i></p>
      <p>larger icons:  <i class="fa fa-camera-retro fa-lg"></i> <i class="fa fa-camera-retro fa-2x"></i> <i class="fa fa-camera-retro
      fa-3x"></i></p>
      <p>fixed width:   <i class="fa fa-home fa-fw"></i>   <i class="fa fa-pencil fa-fw"></i></p>
      <ul class="fa-ul">
      <li></li>
      <li>list symbols:  <i class="fa fa-li fa-check-square"></i></li>
      </ul>
      <p><i class="fa fa-quote-left fa-3x fa-pull-left fa-border"></i> …tomorrow we will run faster,
      stretch out our arms farther… And then one fine morning— So we beat on, boats
      against the current, borne back ceaselessly into the past.</p>
      <p>animated icons:    <i class="fa fa-spinner fa-spin fa-2x fa-fw"></i> <i class="fa fa-circle-o-notch fa-spin
      fa-2x fa-fw"></i> <i class="fa fa-refresh fa-spin fa-2x fa-fw"></i> <i class="fa fa-cog fa-spin fa-2x fa-fw"></i>
      <i class="fa fa-spinner fa-pulse fa-2x fa-fw"></i></p>
      <p>flipped and rotated:   <i class="fa fa-shield"></i> normal <i class="fa fa-shield fa-rotate-90"></i> fa-rotate-90
      <i class="fa fa-shield fa-rotate-180"></i> fa-rotate-180 <i class="fa fa-shield fa-rotate-270"></i> fa-rotate-270
      <i class="fa fa-shield fa-flip-horizontal"></i> fa-flip-horizontal <i class="fa fa-shield fa-flip-vertical"></i>
      fa-flip-vertical</p>
      <p>stacked icons: <span class="fa-stack fa-lg"><i class="fa fa-stack-2x fa-square-o"></i><i class="fa fa-stack-1x fa-twitter"></i></span>
      <span class="fa-stack fa-lg"><i class="fa fa-stack-2x fa-circle"></i><i class="fa fa-stack-1x fa-flag fa-inverse"></i></span> <span class="fa-stack
      fa-lg"><i class="fa fa-stack-2x fa-square"></i><i class="fa fa-stack-1x fa-terminal fa-inverse"></i></span> <span class="fa-stack fa-lg"><i class="fa fa-stack-1x fa-camera"></i><i class="fa fa-stack-2x fa-ban text-danger"></i></span></p>
      </body>
      """, cb
