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
