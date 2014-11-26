#!/bin/sh -e
if [ ! $SRCROOT/sqlite3.c -nt $SRCROOT/configure ] ; then
    ./configure --enable-tempstore=yes --with-crypto-lib=commoncrypto CFLAGS="-DSQLITE_HAS_CODEC -DSQLITE_TEMP_STORE=2"
    make sqlite3.c
fi
