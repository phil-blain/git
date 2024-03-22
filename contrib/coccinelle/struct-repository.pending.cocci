// structs containing a struct repository*
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
identifier f != handle_revision_pseudo_opt;
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

// structs containing one of the structs above
// (struct repository* is a member of a member)
@@
identifier f;
identifier p;
@@
  f(..., struct patch_ids *p, ...) {<...
- the_repository
+ p->diffopts->repo
  ...>}

@@
identifier f;
identifier p;
@@
  f(..., struct checkout *p, ...) {<...
- the_repository
+ p->istate->repo
  ...>}

@@
identifier f;
identifier p;
@@
  f(..., struct split_index *p, ...) {<...
- the_repository
+ p->base->repo
  ...>}

// note: dst-index->repo should be the same as src_index->repo (check this?)
@@
identifier f;
identifier p;
@@
  f(..., struct unpack_trees_options *p, ...) {<...
- the_repository
+ p->dst_index->repo
  ...>}

@@
identifier f;
identifier p;
@@
  f(..., struct ref_cache *p, ...) {<...
- the_repository
+ p->ref_store->repo
  ...>}

@@
identifier f;
identifier p;
@@
  f(..., struct ref_transaction *p, ...) {<...
- the_repository
+ p->ref_store->repo
  ...>}

@@
identifier f;
identifier p;
@@
  f(..., struct rev_list_info *p, ...) {<...
- the_repository
+ p->revs->repo
  ...>}

@@
identifier f;
identifier p;
@@
  f(..., struct pretty_print_context *p, ...) {<...
- the_repository
+ p->rev->repo
  ...>}

@@
identifier f;
identifier p;
@@
  f(..., struct ref_array *p, ...) {<...
- the_repository
+ p->revs->repo
  ...>}

@@
identifier f;
identifier p;
@@
  f(..., struct replay_opts *p, ...) {<...
- the_repository
+ p->revs->repo
  ...>}

@@
identifier f;
identifier p;
@@
  f(..., struct submodule_entry_list *p, ...) {<...
- the_repository
+ p->entries->repo
  ...>}

// structs containing one of the structs above
// (struct repository* is a member of a member of a member)
@@
identifier f;
identifier p;
@@
  f(..., struct ref_dir *p, ...) {<...
- the_repository
+ p->cache->ref_store->repo
  ...>}
