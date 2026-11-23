#!/bin/bash

DATE=$(date -u +%Y-%m-%d)
TIME=$(date -u +%H%M)

mkdir -p raw/$DATE
FILE=raw/$DATE/$TIME.json
KRAKEN_TIME=$(date -u +%Y-%m-%dT%H:%M:%SZ)
curl -s 'https://api.kraken.com/0/public/Depth?pair=XBTUSD&count=5' > kraken.json

BITSTAMP_TIME=$(date -u +%Y-%m-%dT%H:%M:%SZ)
curl -s 'https://www.bitstamp.net/api/v2/order_book/btcusd/' > bitstamp.json
if [ -e "$FILE" ]; then
    echo "File already exists"
    exit 1
fi

jq -n \
 --arg kt "$KRAKEN_TIME" \
 --arg bt "$BITSTAMP_TIME" \
 --slurpfile k kraken.json \
 --slurpfile b bitstamp.json \
  '{
    kraken_collected_at_utc: $kt,
    bitstamp_collected_at_utc: $bt,
    kraken: $k[0],
    bitstamp: {
    timestamp: $b[0].timestamp,
    microtimestamp: $b[0].microtimestamp,
    bids: $b[0].bids[:5],
    asks: $b[0].asks[:5]
    }
  }' > "$FILE"
rm kraken.json bitstamp.json
