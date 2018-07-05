#!/bin/bash
# This script sends a very simple AS4 message to a specified endpoint.
# This script has been tested on MacOS 17.5.0 and has some dependencies
# Dependencies:
# - date
# - uuidgen
# - tr
# - xsltproc
# - curl
# - printf
# - cat
# - tee
#
# Usage:
# ./send.sh http://localhost:8080/domibus/services/msh
# ./send.sh http://localhost:8080/domibus/services/msh | xmllint --format -


function Usage {
    echo "Usage:"
    echo "./send.sh http://localhost:8080/domibus/services/msh"
    echo "./send.sh http://localhost:8080/domibus/services/msh | xmllint --format -"
    exit 1
}

if (( $# != 1 )); then
    Usage
fi

# setup directory for storing sent messages
mkdir messages &>/dev/null

# initialise variables
endpoint=$1
br="\r\n"
boundary="MIME_boundary"
timestamp=`date -u +"%Y-%m-%dT%H:%M:%SZ"`
messageId=`uuidgen|tr [:upper:] [:lower:]`
conversationId=`uuidgen|tr [:upper:] [:lower:]`
as4Header=messages/$messageId.xml

# generate an AS4 header
xsltproc \
    --stringparam timestamp $timestamp \
    --stringparam messageId $messageId \
    --stringparam conversationId $conversationId \
    soap_header.xslt soap_header_template.xml \
    > $as4Header

# generate the body, as per RFC2045 line separator is CRLF
printf "${br}--$boundary" > post
printf "${br}Content-Type: application/xml" >> post
printf "${br}Content-ID: <soap-header>" >> post
printf "${br}Content-Disposition: attachment; filename=${conversationId}_${messageId}_as4header.xml" >> post
# An empty line is required between headers and body
printf "${br}${br}" >> post
cat $as4Header >> post
printf "${br}--$boundary" >> post
printf "${br}Content-Type: application/xml" >> post
printf "${br}Content-ID: payload" >> post
printf "${br}Content-Disposition: attachment; filename=${conversationId}_${messageId}_payload" >> post
# An empty line is required between headers and body
printf "${br}${br}" >> post
cat  payload >> post
printf "${br}--$boundary--" >> post

curl -v -L -X POST \
-H "Content-Type: multipart/related; type=\"application/xml\"; boundary=$boundary; start=\"<soap-header>\"" \
${endpoint} --data-binary @post | tee messages/${messageId}_response.xml
