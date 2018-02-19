#include <erl_nif.h>

extern const char* do_slugify(char* x);

static ERL_NIF_TERM slugify_nif(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[])
{
    char x[100];
    if (!enif_get_string(env, argv[0], x, 100, ERL_NIF_LATIN1)) {
	return enif_make_badarg(env);
    }
    const char* ret = do_slugify(x);
    return enif_make_string(env, ret, ERL_NIF_LATIN1);
}

static ErlNifFunc nif_funcs[] = {
    {"do_slugify", 1, slugify_nif}
};

ERL_NIF_INIT(Elixir.Slug2, nif_funcs, NULL, NULL, NULL, NULL)
