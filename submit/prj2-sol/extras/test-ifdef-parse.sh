#!/bin/sh

SCRIPT_DIR=`dirname $0`
SCRIPT="./ifdef.scm"

if [ $# -ne 1 ]
then
   echo "usage: $0 TESTS_DIR"
   exit 1
fi

TESTS_DIR=$1

stat=0

for f in $TESTS_DIR/*.parse.json
do
    input=`dirname $f`/`basename $f .parse.json`.defs
    echo -n "parse `basename $input` ... "
    ret=`$SCRIPT parse < $input`
    if [ "$ret" != '#t' ]
    then
	stat=1
	echo FAIL
    else
	echo ok
    fi
    #echo $ret
done

for f in $TESTS_DIR/*-err.defs
do
    echo -n "parse `basename $f` ... "
    ret=`$SCRIPT parse  <$f`
    if [ "$ret" != '#f' ]
    then
	echo "FAIL: expected #f for `basename $f`"
	stat=1
    else
	echo "ok: failed as expected"
    fi
done

exit $stat
