#!/bin/bash
set -e

[[ -d ../.cargo ]] || mkdir ../.cargo
printf "#autogenerated\n\n" > ../.cargo/config

exit 0 

export OPENSSL_LIB_DIR="$(grep  -o -m 1 '/[^"]*/OpenSSL/1.0.2j/[^"]*' ./conan_cargo_build.rs)"
export OPENSSL_DIR="$(dirname "$OPENSSL_LIB_DIR")"
export DEP_OPENSSL_VERSION="102"


for i in $(rustc --print target-list)
do 
	{ printf '[target.%s.openssl]\n' "$i";
	  printf 'rustc-link-search = ["%s"]\n' "native=$OPENSSL_LIB_DIR" ;
	  #printf 'include = "%s"\n' "$OPENSSL_DIR/include" ;
	  printf 'rustc-link-lib = ["static=ssl", "static=crypto"]\n'; #rustc-cfg = "ossl102"\nrustc-cfg = "ossl10x"
	  printf 'rustc-cfg=["ossl102"]\nversion = "102"\n\n\n';
	 } >> ../.cargo/config 
done
