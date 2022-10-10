#!/bin/sh

cd `dirname $0`

dir=../repo/migrations/
mkdir -p $dir
filename=`date "+%Y%m%d%H%M%S"`_$1.sql
file="${dir}${filename}"
touch $file
echo "* creating $(realpath $file)"
echo ""
echo Remember to update your repository by running migrations
echo ""

cd - > /dev/null
