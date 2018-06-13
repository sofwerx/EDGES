#!/bin/bash

set -eo pipefail

ES_HOST="${ES_HOST:-localhost:9200}"
ES_PROTO="${ES_PROTO:-https://}"
ES_INDEX="${ES_INDEX:-edges}"
ES_TYPE="${ES_TYPE:-_doc}"
CREDS=${CREDS:--u ${ES_USER}:${ES_PASSWORD}}

USER="${USER:-$(whoami)}"

#  "template": "${ES_INDEX}",
curl -k ${CREDS} -sL -H "Content-Type: application/json" -XPUT ${ES_PROTO}${ES_HOST}/_template/${ES_INDEX}_template --data-binary @- <<EOF || true
{
  "index_patterns": ["${ES_INDEX}"],
  "mappings": {
    "${ES_TYPE}": {
      "properties": {
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

for filename in $@ ; do

  if [ ! -f "$filename" ]; then
    echo Usage: $0 'filename(s)'
    exit 1
  fi

  count=$(jq '.edges | length' $filename)
  seq 0 $count | while read number ; do
    echo "processing $number of $count from $filename" 1>&2
    record="$(jq -c .edges[$number] $filename)"
    location=$(echo "$record" | jq -c ".location")
    lat=$(echo $location | jq ".latitude")
    lon=$(echo $location | jq ".longitude")
    timestamp=$(echo $location | jq ".timestamp")
    max=$(echo "$record" | jq ".powers | length")
    seq 0 $max | while read index ; do
      power=$(echo "$record" | jq ".powers[$index].power")
      frequency=$(echo "$record" | jq ".powers[$index].freq")

      if [ "$power" != null -a "$frequency" != null ]; then
        cat <<EOF
{ "index" : { "_index" : "${ES_INDEX}", "_type" : "${ES_TYPE}", "_id": "${timestamp}_${index}_${frequency}_${power}" } }
{ "frequency" : $frequency, "power" : $power, "geo" : { "lat" : $lat, "lon" : $lon }, "location" : $location, "created" : $timestamp }
EOF
      fi

    done | curl -k ${CREDS} -sL -H "Content-Type: application/x-ndjson" -XPOST ${ES_PROTO}${ES_HOST}/${ES_INDEX}/${ES_TYPE}/_bulk --data-binary @- > /dev/null 2>&1
  done

done
