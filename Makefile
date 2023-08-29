CC = gcc
SRCS_EC_BUILTIN_CURVES = ec_builtin_curves.c
OBJS_EC_BUILTIN_CURVES = $(SRCS_EC_BUILTIN_CURVES:.c=.o)
# Customize the OpenSSL to compile with.
# Latest master branch
OPENSSL_DIR = /home/jaruga/.local/openssl-3.2.0-dev-fips-debug-cf712830b7
OPENSSL_INC_DIR = $(OPENSSL_DIR)/include
OPENSSL_LIB_DIR = $(OPENSSL_DIR)/lib
CFLAGS = -I $(OPENSSL_INC_DIR) -L $(OPENSSL_LIB_DIR) $(OPTFLAGS) $(DEBUGFLAGS)
OPTFLAGS = -O0
DEBUGFLAGS = -g3 -ggdb3 -gdwarf-5
LDFLAGS = -L $(OPENSSL_LIB_DIR)

EXE_EC_BUILTIN_CURVES = ec_builtin_curves
# For OpenSSL
EXE_ALL = $(EXE_EC_BUILTIN_CURVES)
LIBS = -lssl -lcrypto

.c.o :
	$(CC) -c $(CFLAGS) $< -o $@

.PHONY: all
all : $(EXE_ALL)

$(EXE_EC_BUILTIN_CURVES) : $(OBJS_EC_BUILTIN_CURVES)
	$(CC) $(LDFLAGS) $^ -o $@ $(LIBS)

.PHONY: clean
clean :
	rm -f *.o $(EXE_ALL)

.PHONY: run-non-fips
run-non-fips :
	OPENSSL_CONF_INCLUDE=$(OPENSSL_DIR)/ssl \
	OPENSSL_MODULES=$(OPENSSL_LIB_DIR)/ossl-modules \
	LD_LIBRARY_PATH=$(OPENSSL_LIB_DIR) \
	./ec_builtin_curves

.PHONY: run-fips
run-fips :
	OPENSSL_CONF=$(OPENSSL_DIR)/ssl/openssl_fips.cnf \
	OPENSSL_CONF_INCLUDE=$(OPENSSL_DIR)/ssl \
	OPENSSL_MODULES=$(OPENSSL_LIB_DIR)/ossl-modules \
	LD_LIBRARY_PATH=$(OPENSSL_LIB_DIR) \
	./ec_builtin_curves
