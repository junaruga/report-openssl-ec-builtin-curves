#include <stdio.h>
#include <stdlib.h>

#include <openssl/evp.h>
#include <openssl/provider.h>
#include <openssl/ec.h>
#include <openssl/objects.h>

static int print_provider(OSSL_PROVIDER *prov, void *unused)
{
    printf("  %s\n", OSSL_PROVIDER_get0_name(prov));
    return 1;
}

int main(int argc, char *argv[])
{
    int status = EXIT_SUCCESS;
    int fips_enabled = 0;
    EC_builtin_curve *curves = NULL;
    int n;
    int crv_len = EC_get_builtin_curves(NULL, 0);

    printf("Loaded providers:\n");
    OSSL_PROVIDER_do_all(NULL, &print_provider, NULL);
    fips_enabled = EVP_default_properties_is_fips_enabled(NULL);
    printf("FIPS enabled: %s\n", (fips_enabled) ? "yes" : "no");

    if (!(curves = calloc(sizeof(EC_builtin_curve), crv_len))) {
        status = EXIT_FAILURE;
        fprintf(stderr, "[DEBUG] Failed to allocate curves.\n");
        goto end;
    }

    if (!EC_get_builtin_curves(curves, crv_len)) {
        status = EXIT_FAILURE;
        fprintf(stderr, "[DEBUG] EC_get_builtin_curves failed.\n");
        goto end;
    }

    fprintf(stdout, "[DEBUG] crv_len: %d\n", crv_len);

    for (n = 0; n < crv_len; n++) {
        const int nid = curves[n].nid;
        const char *sname = OBJ_nid2sn(curves[n].nid);
        fprintf(stdout, "[DEBUG] curves: [%d, %s]\n", nid, sname);
    }
end:
    if (curves) {
        free(curves);
    }
    return status;
}
