#!/bin/bash

TOMCAT=apache-tomcat-8.0.23
TOMCAT_WEBAPPS=$TOMCAT/webapps
TOMCAT_CONFIG=$TOMCAT/conf/server.xml
TOMCAT_START=$TOMCAT/bin/startup.sh
TOMCAT_ARCHIVE=$TOMCAT.tar.gz
TOMCAT_URL=http://archive.apache.org/dist/tomcat/tomcat-8/v8.0.23/bin/apache-tomcat-8.0.23.tar.gz

if [ ! -e $TOMCAT ]; then
    if [ ! -r $TOMCAT_ARCHIVE ]; then
            wget $TOMCAT_URL
    fi

    if [ ! -r $TOMCAT_ARCHIVE ]; then
        echo "Tomcat could not be downloaded." 1>&2
        echo "Verify that eiter curl or wget is installed." 1>&2
        echo "If they are, check your internet connection and try again." 1>&2
        echo "You may also download $TOMCAT_ARCHIVE and place it in this folder." 1>&2
        exit 1
    fi

  tar -zxf $TOMCAT_ARCHIVE
    rm $TOMCAT_ARCHIVE
fi

if [ ! -w $TOMCAT -o ! -w $TOMCAT_WEBAPPS ]; then
    echo "$TOMCAT and $TOMCAT_WEBAPPS must be writable." 1>&2
    exit 1
fi

# place tomcat customizations here

$TOMCAT_START
                        
exit 0