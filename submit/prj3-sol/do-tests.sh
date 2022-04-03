#!/bin/sh

if [ $# -lt 1 ]
then
    echo "usage: $0 TESTS_FILE [TEST_NAME...]"
    exit 1
fi

TESTS_FILE=$1
shift

if [ $# -eq 0 ]
then
    prolog -t run_tests $TESTS_FILE
else
    tests=`echo $@ | tr ' ' ','`
    prolog -t "run_tests([$tests])" $TESTS_FILE
fi

