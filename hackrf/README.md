# hackrf

This is a quick-and-dirty attempt at using `hackrf_sweep` to scan the spectrum, pull out the loudest RF sources, and store them along with location.

# powers.sh

The output of this is a JSON file in the current directory starting with the prefix `edges-` and followed by the current date+timestamp.

# es-import.sh

The above output JSON file(s) can be passed as a commandline argument to the `es-import.sh` script, which will post the data to an ElasticSearch index.

This script is idempotent. It may be run multiple times on the same JSON files without issue.

Because the `_id` of each document are an amalgam of the timestamp, index, frequency, and power, the index operation will not generate duplicates.

