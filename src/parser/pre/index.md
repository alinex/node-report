Pre Optimizations
=================================================
This optimization methods are run before parsing the source and may change it.

The possible domains are:
- `m` for markdown parsing
- `mh` for markdown with html allowed
- `h` for html parsing


Mofdules
-------------------------------------------------
Each module will export an object containing functions for one or multiple
domains. They will get the complete source text to manipulate and return if
defined.
