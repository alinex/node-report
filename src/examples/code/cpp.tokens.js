TokenList {
  data: 
   [ { type: 'document', nesting: 1, level: 0 },
     { type: 'code',
       nesting: 1,
       language: 'cpp',
       level: 1,
       parent: [Object] },
     { type: 'text',
       content: '#include <iostream>\n\nint main(int argc, char *argv[]) {\n\n  /* An annoying "Hello World" example */\n  for (auto i = 0; i < 0xFFFF; i++)\n    cout << "Hello, World!" << endl;\n\n  char c = \'\\n\';\n  unordered_map <string, vector<string> > m;\n  m["key"] = "\\\\\\\\"; // this is an error\n\n  return -2e3 + 12l;\n}',
       level: 2,
       parent: [Object] },
     { type: 'code',
       nesting: -1,
       language: 'cpp',
       level: 1,
       parent: [Object] },
     { type: 'document', nesting: -1, level: 0 } ],
  pos: 4,
  token: 
   { type: 'code',
     nesting: -1,
     language: 'cpp',
     level: 1,
     parent: { type: 'document', nesting: 1, level: 0 } } }