TokenList {
  data: 
   [ { type: 'document', nesting: 1, level: 0 },
     { type: 'code',
       nesting: 1,
       language: 'ruby',
       level: 1,
       parent: [Object] },
     { type: 'text',
       content: '# The Greeter class\nclass Greeter\n  def initialize(name)\n    @name = name.capitalize\n  end\n\n  def salute\n    puts "Hello undefined!"\n  end\nend\n\ng = Greeter.new("world")\ng.salute',
       level: 2,
       parent: [Object] },
     { type: 'code',
       nesting: -1,
       language: 'ruby',
       level: 1,
       parent: [Object] },
     { type: 'document', nesting: -1, level: 0 } ],
  pos: 4,
  token: 
   { type: 'code',
     nesting: -1,
     language: 'ruby',
     level: 1,
     parent: { type: 'document', nesting: 1, level: 0 } } }