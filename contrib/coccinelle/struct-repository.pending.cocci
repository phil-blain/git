// structs containing a struct repository*
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
  f(..., struct grep_opt *p, ...) {<...
- the_repository
+ p->repo
  ...>}

@@
identifier f;
identifier p;
@@
  f(..., struct merge_options *p, ...) {<...
- the_repository
+ p->repo
  ...>}

@@
identifier f;
identifier p;
@@
  f(..., struct notes_merge_options *p, ...) {<...
- the_repository
+ p->repo
  ...>}

@@
identifier f;
identifier p;
@@
  f(..., struct packing_data *p, ...) {<...
- the_repository
+ p->repo
  ...>}

@@
identifier f;
identifier p;
@@
  f(..., struct index_state *p, ...) {<...
- the_repository
+ p->repo
  ...>}

@@
identifier f;
identifier p;
@@
  f(..., struct ref_store *p, ...) {<...
- the_repository
+ p->repo
  ...>}

@@
identifier f;
identifier p;
@@
  f(..., struct rev_info *p, ...) {<...
- the_repository
+ p->repo
  ...>}

@@
identifier f;
identifier p;
@@
  f(..., struct wt_status *p, ...) {<...
- the_repository
+ p->repo
  ...>}
