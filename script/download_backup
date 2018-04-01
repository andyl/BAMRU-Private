#/usr/bin/env bash
# this is meant to be run on the dev machine
# not the production server
#
# to just grab the database:
# cap backup:download:db
#
echo "||||||||||||||||||||||||||||"
echo ------- start backup -------
date
cd /home/aleak/lr/BAMRU-Private
echo PWD is `pwd`
echo USER is `whoami`
echo ----------------------------
. ./.env ; bundle exec cap backup:download:all
echo ------- finish backup ------
date
echo ----------------------------

