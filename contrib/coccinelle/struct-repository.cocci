// structs containing a struct repository*
@@
identifier f;
identifier p;
@@
  f(..., struct add_i_state *p, ...) {<...
- the_repository
+ p->r
  ...>}

@@
identifier f;
identifier p;
@@
  f(..., struct apply_state *p, ...) {<...
- the_repository
+ p->repo
  ...>}

@@
identifier f;
identifier p;
@@
  f(..., struct archiver_args *p, ...) {<...
- the_repository
+ p->repo
  ...>}

@@
identifier f;
identifier p;
@@
  f(..., struct blame_scoreboard *p, ...) {<...
- the_repository
+ p->repo
  ...>}

@@
identifier f;
identifier p;
@@
  f(..., struct diff_options *p, ...) {<...
- the_repository
+ p->repo
  ...>}

@@
identifier f;
identifier p;
@@
  f(..., struct grep_source *p, ...) {<...
- the_repository
+ p->repo
  ...>}

@@
identifier f;
identifier p;
@@
  f(..., struct submodule_tree_entry *p, ...) {<...
- the_repository
+ p->repo
  ...>}
