#/usr/bin/env bash
# this is meant to be run on the dev machine
# not the production server
#
# to just grab the database:
# cap backup:download:db
#
source .env
echo ------- start backup -------
date
echo ----------------------------
bundle exec cap backup:download:all
echo ------- finish backup ------
date
echo ----------------------------

