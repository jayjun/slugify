## usage

### prerequisite

* ICU4C `v60.2`[http://site.icu-project.org/download/60] installed


### command

* ``` g++ -o slug_nif.so -undefined dynamic_lookup -dynamiclib slug.c slug_nif.c --std=c++11 `pkg-config --libs --cflags icu-uc icu-io` -I'/path/to/erlang/erts-9.2/include' ```
