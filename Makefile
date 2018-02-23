CFLAGS += --std=c++11

ERLANG_PATH = $(shell erl -eval 'io:format("~s", [lists:concat([code:root_dir(), "/erts-", erlang:system_info(version), "/include"])])' -s init stop -noshell)
CFLAGS += -I$(ERLANG_PATH)

LIB_NAME = priv/slug_nif.so
ifneq ($(OS),Windows_NT)
	CFLAGS += -fPIC

	ifeq ($(shell uname),Darwin)
		LDFLAGS += -dynamiclib -undefined dynamic_lookup
	endif
endif

LDFLAGS += -shared
LDFLAGS += `pkg-config --libs --cflags icu-uc icu-io`

NIF_SRC=\
	c_src/slug_nif.c\
	c_src/slug.c

all: $(LIB_NAME)

$(LIB_NAME): $(NIF_SRC)
	mkdir -p priv
	$(CXX) -o $@ $^ $(CFLAGS) $(LDFLAGS)

clean:
	rm -f priv

.PHONY: all clean
