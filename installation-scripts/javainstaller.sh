#!/bin/bash
major_version="8"
target="/usr/lib/jvm/java-8-oracle"
arch="linux-x64"

# This URL is for the major version 8.
download_page="http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html"

download_url=$(curl -s "$download_page" | \
        awk "/downloads\['/ && ! /demos/ && /\['files'\]/ && /$arch/ && /\.tar\.gz/" | \
        grep -o 'http.*\.tar\.gz')

filename=$(awk -F'\/' '{print $NF}' <<< "$download_url")

if [ -f "$finename" ]; then
        echo "File $filename exist"
else
        echo "Download " $filename " for installing"

wget --no-cookies --header \
    "Cookie: oraclelicense=accept-securebackup-cookie" \
	"$download_url"

        echo "Downloading Complete..."
fi

# Check what options were provided
JDK_ARCHIVE=$filename
# Check if the script is running with root permissions
if [ `id -u` -ne 0 ]; then
   echo "The script must be run as root! (you can use sudo)"
   exit 1
fi

#   Is the file containing JDK?
#   Also obtain JDK version using the occassion
JDK_VERSION=`tar -tf $JDK_ARCHIVE | egrep '^[^/]+/$' | head -c -2` 2>> /dev/null

# Begin Java installation

# Extract the archive
echo -n "Extracting the archive... "
JDK_LOCATION=/usr/local/java/$JDK_VERSION
mkdir -p /usr/local/java
tar xzf $JDK_ARCHIVE -C /usr/local/java
echo "OK"

# Update /etc/profile
echo -n "Updating /etc/profile ... "
cat >> /etc/profile <<EOF
JAVA_HOME=$JDK_LOCATION
JRE_HOME=$JDK_LOCATION/jre
PATH=$PATH:$JDK_LOCATION/bin:$JDK_LOCATION/jre/bin
export JAVA_HOME
export JRE_HOME
export PATH
EOF
echo "OK"

# Update system to use Oracle Java by default
echo -n "Updating system alternatives... "
update-alternatives --install "/usr/bin/java" "java" "$JDK_LOCATION/jre/bin/java" 1 >> /dev/null
update-alternatives --install "/usr/bin/javac" "javac" "$JDK_LOCATION/bin/javac" 1 >> /dev/null
update-alternatives --set java $JDK_LOCATION/jre/bin/java >> /dev/null
update-alternatives --set javac $JDK_LOCATION/bin/javac >> /dev/null

echo "OK"

# Verify and exit installation
echo -n "Verifying Java installation... "
JAVA_CHECK=`java -version 2>&1`
if [[ "$JAVA_CHECK" == *"Java(TM) SE Runtime Environment"* ]]; then
   echo "OK"
   echo
   echo "Java is successfully installed!"
   echo
   java -version
   echo
else
   echo "FAILED"
   echo
   echo "Java installation failed!"
   echo
   exit 1
fi

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