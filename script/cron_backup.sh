#/usr/bin/env bash
# this is meant to be run on the dev machine
# not the production server
#
# to just grab the database:
# cap backup:download:db
#
cd /home/aleak/lr/BAMRU-Private
source .env
echo "||||||||||||||||||||||||||||"
echo ------- start backup -------
date
echo PWD is `pwd`
echo APP_NAME is $APP_NAME
echo ----------------------------
bundle exec cap backup:download:all
echo ------- finish backup ------
date
echo ----------------------------

