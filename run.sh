#!/bin/bash

die () {
	echo "ERROR: $*"
	exit 1
}

[ -z "$DW_DATASOURCE_URL" ] && die "DW_DATASOURCE_URL not defined"
[ -z "$DW_DATASOURCE_USERNAME" ] && die "DW_DATASOURCE_USERNAME not defined"
[ -z "$DW_DATASOURCE_PASSWORD" ] && die "DW_DATASOURCE_PASSWORD not defined"

xtail $(dirname $LOGGING_FILE) &

JAR=$(ls $DEPLOY_LOCATION/*.jar |head -n 1)
export SERVER_SERVLET_CONTEXT_PATH=$(basename "$JAR" .jar)
export SERVLET_CONTEXT_PATH=$(basename "$JAR" .jar)

echo "Starting $JAR"
echo "Context Path (server_servlet): $SERVER_SERVLET_CONTEXT_PATH"
echo "Context Path (servlet): $SERVLET_CONTEXT_PATH"

echo "JAVA_OPTIONS: $JAVA_OPTIONS"

java $JAVA_OPTIONS -jar $JAR
