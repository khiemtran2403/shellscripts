#!/bin/bash

TOMCAT=apache-tomcat-8.0.23
TOMCAT_LOCATION=/usr/local/$TOMCAT
TOMCAT_ARCHIVE=$TOMCAT.tar.gz
TOMCAT_WEBAPPS=$TOMCAT_LOCATION/webapps
TOMCAT_START=$TOMCAT_LOCATION/bin/startup.sh
TOMCAT_URL=http://archive.apache.org/dist/tomcat/tomcat-8/v8.0.23/bin/apache-tomcat-8.0.23.tar.gz

wget $TOMCAT_URL

tar xzf $TOMCAT_ARCHIVE -C /usr/local
rm $TOMCAT_ARCHIVE

# place tomcat customizations here

$TOMCAT_START
                        
exit 0