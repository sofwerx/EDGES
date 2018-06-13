#!/bin/bash

set -eo pipefail

ES_HOST="${ES_HOST:-localhost:9200}"
ES_PROTO="${ES_PROTO:-https://}"
ES_INDEX="${ES_INDEX:-edges}"
ES_TYPE="${ES_TYPE:-_doc}"
CREDS=${CREDS:--u ${ES_USER}:${ES_PASSWORD}}

USER="${USER:-$(whoami)}"

filename="$1"

if [ ! -f "$filename" ]; then
  echo Usage: $0 filename
  exit 1
fi

#set -x
#curl -k ${CREDS} -sL -H "Content-Type: application/json" -XDELETE ${ES_PROTO}${ES_HOST}/${ES_INDEX}/${ES_TYPE} || true
#curl -k ${CREDS} -sL -H "Content-Type: application/json" -XDELETE ${ES_PROTO}${ES_HOST}/${ES_INDEX} || true
#curl -k ${CREDS} -sL -H "Content-Type: application/json" -XDELETE ${ES_PROTO}${ES_HOST}/_template/${ES_INDEX}_template || true
#
#curl -k ${CREDS} -sL -XGET ${ES_PROTO}${ES_HOST}"/_template/${ES_INDEX}_template?pretty"

#  "template": "${ES_INDEX}",
curl -k ${CREDS} -sL -H "Content-Type: application/json" -XPUT ${ES_PROTO}${ES_HOST}/_template/${ES_INDEX}_template --data-binary @- <<EOF || true
{
  "index_patterns": ["${ES_INDEX}"],
  "mappings": {
    "${ES_TYPE}": {
      "properties": {
        "id": { "type": "keyword" },
        "frequency": { "type": "long" },
        "power": { "type": "float" },
        "geo": { "type": "geo_point" },
        "created":  {
          "type":   "date", 
          "format": "strict_date_optional_time||epoch_millis"
        }
      }
    }
  }
}
EOF

#curl -k ${CREDS} -sL -XGET ${ES_PROTO}${ES_HOST}"/_template/${ES_INDEX}_template?pretty"

curl -k ${CREDS} -sL -H "Content-Type: application/json" -XPUT ${ES_PROTO}${ES_HOST}/_settings* --data-binary @- <<EOF || true
{
  "index": {
    "blocks": {
      "read_only_allow_delete": "false"
    }
  }
}
EOF

#set +x

count=$(jq '.edges | length' $filename)
seq 0 $count | while read number ; do
  location=$(jq -c ".edges[$number].location" $filename)
  lat=$(echo $location | jq ".latitude")
  lon=$(echo $location | jq ".longitude")
  timestamp=$(echo $location | jq ".timestamp")
  max=$(jq ".edges[$number].powers | length" $filename)
  seq 0 $max | while read index ; do
    power=$(jq ".edges[$number].powers[$index].power" $filename)
    frequency=$(jq ".edges[$number].powers[$index].freq" $filename)

    if [ "$power" != null -a "$frequency" != null ]; then
      curl -k ${CREDS} -sL -H "Content-Type: application/json" -XPOST ${ES_PROTO}${ES_HOST}/${ES_INDEX}/${ES_TYPE} --data-binary @- <<EOF
{
  "id": "${timestamp}_${index}_${USER}",
  "frequency": $frequency,
  "power": $power,
  "geo": {
    "lat": $lat,
    "lon": $lon
  },
  "location": $location,
  "created": $timestamp
}
EOF
      echo " ${timestamp}_${index}_${USER} "
    fi

  done
done
