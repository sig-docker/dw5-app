#Dockerfile for Degreeworks 5 ApplicantAPI container
FROM openjdk:8

# parameterized environment variables
# removed for testing
#    SERVER_SERVLET_CONTEXT_PATH=/${APP_NAME} \

ENV SERVER_PORT=8443 \
    SERVER_SSL_KEY_STORE=/usr/local/ssl/selfSigned.jks \
    SERVER_SSL_KEY_STORE_PASSWORD=doesntmatter \
    SERVER_SSL_KEYSTORETYPE=JKS \
    SERVER_SSL_KEYALIAS=selfsigned \
    JAVA_OPTIONS="-Xms1024m -Xmx1024m" \
    DEBUG=false \
    DEPLOY_LOCATION=/usr/local/dwapp \
    LOGGING_FILE=/usr/local/dwapp/logs/dwapp.log \
    DW_DATAPOOL_INITIAL_SIZE=10 \
    DW_DATAPOOL_MIN_IDLE=10 \
    DW_DATAPOOL_MAX_IDLE=10 \
    DW_DATAPOOL_MAX_ACTIVE=300 \
    DW_DATAPOOL_TIME_BETWEEN_EVICTION_RUNS_MILLIS=1800000 \
    DW_DATAPOOL_REMOVE_ABANDONED=true \
    DW_DATAPOOL_REMOVE_ABANDONED_TIMEOUT=120 \
    DW_DATAPOOL_VALIDATION_QUERY="select 1 from dual" \
    DW_DATAPOOL_TEST_WHILE_IDLE=true \
    DW_DATAPOOL_TEST_ON_BORROW=true

# ApplicantAPI directory and file
RUN mkdir -p $DEPLOY_LOCATION \
 && mkdir -p $DEPLOY_LOCATION/logs \
 && mkdir -p $(dirname $SERVER_SSL_KEY_STORE) \
 && apt-get update -y  \
 && apt-get install -y xtail \
 && apt-get clean autoclean -y \
 && apt-get autoremove -y \
 && rm -rf /var/lib/apt/lists/* \
 && keytool -genkey -dname "cn=DW5, ou=Docker, o=TheGreatUnknown, c=US" -keyalg RSA -alias $SERVER_SSL_KEYALIAS -keystore $SERVER_SSL_KEY_STORE -keypass $SERVER_SSL_KEY_STORE_PASSWORD -storepass $SERVER_SSL_KEY_STORE_PASSWORD -validity 1800 -keysize 2048

COPY run.sh /run.sh
COPY binaries/*.jar $DEPLOY_LOCATION

EXPOSE 8443
CMD /bin/bash /run.sh
