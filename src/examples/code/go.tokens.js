TokenList {
  data: 
   [ { type: 'document', nesting: 1, level: 0 },
     { type: 'code',
       nesting: 1,
       language: 'go',
       level: 1,
       parent: [Object] },
     { type: 'text',
       content: 'package main\n\nimport "fmt"\n\nfunc main() {\n    ch := make(chan float64)\n    ch <- 1.0e10    // magic number\n    x, ok := <- ch\n    defer fmt.Println(`exitting now\\`)\n    go println(len("hello world!"))\n    return\n}',
       level: 2,
       parent: [Object] },
     { type: 'code',
       nesting: -1,
       language: 'go',
       level: 1,
       parent: [Object] },
     { type: 'document', nesting: -1, level: 0 } ],
  pos: 4,
  token: 
   { type: 'code',
     nesting: -1,
     language: 'go',
     level: 1,
     parent: { type: 'document', nesting: 1, level: 0 } } }