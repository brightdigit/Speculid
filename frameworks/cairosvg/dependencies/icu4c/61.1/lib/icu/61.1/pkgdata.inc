GENCCODE_ASSEMBLY_TYPE=-a gcc-darwin
SO=dylib
SOBJ=dylib
A=a
LIBPREFIX=lib
LIB_EXT_ORDER=.61.1.dylib
COMPILE=clang -DU_ATTRIBUTE_DEPRECATED=   -DU_HAVE_ATOMIC=1 -DU_HAVE_STRTOD_L=1 -DU_HAVE_XLOCALE_H=1  -O2 -std=c99 -Wall -pedantic -Wshadow -Wpointer-arith -Wmissing-prototypes -Wwrite-strings  -Qunused-arguments -Wno-parentheses-equality -fno-common -c
LIBFLAGS=-I/usr/local/Cellar/icu4c/61.1/include  -dynamic
GENLIB=clang -dynamiclib -dynamic -O2 -std=c99 -Wall -pedantic -Wshadow -Wpointer-arith -Wmissing-prototypes -Wwrite-strings  -Qunused-arguments -Wno-parentheses-equality  
LDICUDTFLAGS=
LD_SONAME=-Wl,-compatibility_version -Wl,61 -Wl,-current_version -Wl,61.1 -install_name
RPATH_FLAGS=
BIR_LDFLAGS=
AR=ar
ARFLAGS=r -c
RANLIB=ranlib
INSTALL_CMD=/usr/bin/install -c
