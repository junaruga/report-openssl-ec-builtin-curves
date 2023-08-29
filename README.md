# report-openssl-ec-builtin-curves

Set the `OPENSSL_DIR` in `Makefile`.

```
$ make
```

Run the program in non-FIPS and FIPS cases.

```
$ make run-non-fips >& run-non-fips.log

$ make run-fips >& run-fips.log
```
