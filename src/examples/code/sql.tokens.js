TokenList {
  data: 
   [ { type: 'document', nesting: 1, level: 0 },
     { type: 'code',
       nesting: 1,
       language: 'sql',
       level: 1,
       parent: [Object] },
     { type: 'text',
       content: 'CREATE TABLE "topic" (\n    "id" serial NOT NULL PRIMARY KEY,\n    "forum_id" integer NOT NULL,\n    "subject" varchar(255) NOT NULL\n);\nALTER TABLE "topic"\nADD CONSTRAINT forum_id FOREIGN KEY ("forum_id")\nREFERENCES "forum" ("id");\n\n-- Initials\ninsert into "topic" ("forum_id", "subject")\nvalues (2, \'D\'\'artagnian\');',
       level: 2,
       parent: [Object] },
     { type: 'code',
       nesting: -1,
       language: 'sql',
       level: 1,
       parent: [Object] },
     { type: 'document', nesting: -1, level: 0 } ],
  pos: 4,
  token: 
   { type: 'code',
     nesting: -1,
     language: 'sql',
     level: 1,
     parent: { type: 'document', nesting: 1, level: 0 } } }