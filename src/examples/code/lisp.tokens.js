TokenList {
  data: 
   [ { type: 'document', nesting: 1, level: 0 },
     { type: 'code',
       nesting: 1,
       language: 'lisp',
       level: 1,
       parent: [Object] },
     { type: 'text',
       content: '#!/usr/bin/env csi\n\n(defun prompt-for-cd ()\n   "Prompts\n    for CD"\n   (prompt-read "Title" 1.53 1 2/4 1.7 1.7e0 2.9E-4 +42 -7 #b001 #b001/100 #o777 #O777 #xabc55 #c(0 -5.6))\n   (prompt-read "Artist" &rest)\n   (or (parse-integer (prompt-read "Rating") :junk-allowed t) 0)\n  (if x (format t "yes") (format t "no" nil) ;and here comment\n  )\n  ;; second line comment\n  \'(+ 1 2)\n  (defvar *lines*)                ; list of all lines\n  (position-if-not #\'sys::whitespacep line :start beg))\n  (quote (privet 1 2 3))\n  \'(hello world)\n  (* 5 7)\n  (1 2 34 5)\n  (:use "aaaa")\n  (let ((x 10) (y 20))\n    (print (+ x y))\n  )',
       level: 2,
       parent: [Object] },
     { type: 'code',
       nesting: -1,
       language: 'lisp',
       level: 1,
       parent: [Object] },
     { type: 'document', nesting: -1, level: 0 } ],
  pos: 4,
  token: 
   { type: 'code',
     nesting: -1,
     language: 'lisp',
     level: 1,
     parent: { type: 'document', nesting: 1, level: 0 } } }