#!/bin/sh
###Add Coinmarketcap api key
key="add CMC api key"
base_currency="EUR"
currencies="1,1027"

cachedir=~/.cache/rbn
cachefile=${0##*/}-$1

if [ ! -d $cachedir ]; then
    mkdir -p $cachedir
fi
if [ ! -f $cachedir/$cachefile ]; then
    touch $cachedir/$cachefile
fi
cacheage=$(($(date +%s) - $(stat -c '%Y' "$cachedir/$cachefile")))

if [ $cacheage -gt 1740 ] || [ ! -s $cachedir/$cachefile ]; then
     rm $cachedir/$cachefile
     touch $cachedir/$cachefile

	url="https://pro-api.coinmarketcap.com/v2/cryptocurrency/quotes/latest?CMC_PRO_API_KEY=${key}&convert=${base_currency}&id=${currencies}"
	data=$(curl -s ${url} )

	echo ${data} | jq '."data"' | jq '."1"' | jq '."symbol"'  > $cachedir/$cachefile
	echo ${data} | jq '."data"' | jq '."1"' | jq '."quote"' | jq '."EUR"' | jq '."price"' >> $cachedir/$cachefile

	echo ${data} | jq '."data"' | jq '."1027"' | jq '."symbol"' >> $cachedir/$cachefile
	echo ${data} | jq '."data"' | jq '."1027"' | jq '."quote"' | jq '."EUR"' | jq '."price"' >> $cachedir/$cachefile
fi

BTC=($(cat $cachedir/$cachefile))

BTC[0]=${BTC[0]//'"'}
BTC[1]=${BTC[1]%.*}

ETH[0]=${BTC[2]//'"'}
ETH[1]=${BTC[3]%.*}

echo -e "{\"text\":\""${BTC[0]} : ${BTC[1]}"\", \"alt\":\""${BTC[0]}"\", \"tooltip\":\""${BTC[0]}: ${BTC[1]} ${ETH[0]}: ${ETH[1]}"\"}"
