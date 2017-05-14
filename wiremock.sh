#
# Launches the wiremock jar, for running wiremock (wiremock.org) as a standalone process.
#
# Downloaded this script on May 13, 2017 from this url:
# http://allegro.tech/2016/10/self-contained-UI-tests-for-ios-applications.html
#

#!/bin/sh

WIREMOCK_DIR=`dirname $0`
MAPPINGS_DIR="$WIREMOCK_DIR"
PORT=8080
START=true
STOP=false
RECORD=false
API_URL="https://our.api.url"

function usage
{
    echo "Usage:"
    echo "\twiremock.sh -k|r [-h] [-m <mappings_dir>]"
    echo
    echo "\t-k --kill - stop server"
    echo "\t-m --mappings <mappings_dir> - start server with mocks from <mappings_dir>"
    echo "\t-r --record - start wiremock in recording mode"
    echo "\t-h --help - this screen"
}

while [ -n "$1" ]
do
    case $1 in
        -m | --mappings )
            shift
            MAPPINGS_DIR="$1"
            ;;
        -k | --kill )
            START=false
            STOP=true
            RECORD=false
            ;;
        -r | --record )
            START=false
            STOP=true
            RECORD=false
            ;;
        -h | --help )
            usage
            exit
            ;;
        * )
            usage
            exit 1
    esac
    shift
done

if [ "$START" == true ]
then
    echo "Starting Wiremock in play mode on port $PORT with mappings from $MAPPINGS_DIR"
    java -jar $WIREMOCK_DIR/wiremock.jar --verbose --port $PORT --root-dir $MAPPINGS_DIR &
elif [ "$STOP" == true ]
then
    echo "Stopping Wiremock on localhost:$PORT & $AUTH_PORT"
    curl -X POST --data '' "http://localhost:$PORT/__admin/shutdown"
elif [ "$RECORD" == true ]
then
    echo "Starting Wiremock in record mode on port $PORT"
    echo "Storing mappings to $MAPPINGS_DIR"
    java -jar $WIREMOCK_DIR/wiremock.jar --proxy-all "$API_URL" --record-mappings --verbose --port $PORT --root-dir $MAPPINGS_DIR &
fi