TokenList {
  data: 
   [ { type: 'document', nesting: 1, level: 0 },
     { type: 'code',
       nesting: 1,
       language: 'stylus',
       level: 1,
       parent: [Object] },
     { type: 'text',
       content: '@import "nib"\n\n// variables\n$green = #008000\n$green_dark = darken($green, 10)\n\n// mixin/function\ncontainer()\n  max-width 980px\n\n// mixin/function with parameters\nbuttonBG($color = green)\n  if $color == green\n    background-color #008000\n  else if $color == red\n    background-color #B22222\n\nbutton\n  buttonBG(red)\n\n#content, .content\n  font Tahoma, Chunkfive, sans-serif\n  background url(\'hatch.png\')\n  color #F0F0F0 !important\n  width 100%',
       level: 2,
       parent: [Object] },
     { type: 'code',
       nesting: -1,
       language: 'stylus',
       level: 1,
       parent: [Object] },
     { type: 'document', nesting: -1, level: 0 } ],
  pos: 4,
  token: 
   { type: 'code',
     nesting: -1,
     language: 'stylus',
     level: 1,
     parent: { type: 'document', nesting: 1, level: 0 } } }