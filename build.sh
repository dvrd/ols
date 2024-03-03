#!/usr/bin/env bash

if [[ $1 == "CI" ]]
then
    shift

    export PATH=$PATH:$PWD/Odin

    if ! odin test tests -collection:src=src -o:speed "$@"; then
        echo "Ols tests failed"
        exit 1
    fi

	if ! tools/odinfmt/tests.sh; then
        echo "Odinfmt tests failed"
        #darwin bug in snapshot
        #exit 1
    fi
fi

if [[ $1 == "CI_NO_TESTS" ]]
then
    shift

    export PATH=$PATH:$PWD/Odin
fi

if [[ $1 == "single_test" ]]
then
    shift

    if ! odin test tests -collection:src=src -test-name:"$*"; then
        echo "Test failed"
        exit 1
    fi

	exit 0
fi

if [[ $1 == "test" ]]
then
    shift

	if ! odin test tests -collection:src=src "$@"
    then
        echo "Test failed"
        exit 1
    fi

	exit 0
fi

if [[ $1 == "debug" ]]
then
    shift

    odin build src/ -collection:src=src -out:ols -use-separate-modules -debug "$@"

    exit 0
fi


odin build src/ -collection:src=src -out:ols -o:speed "$@"
