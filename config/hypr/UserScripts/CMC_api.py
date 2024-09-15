#!/usr/bin/env python3

import requests,json,os
###Add Coin marketcap API key
key="CMC API key"
base_currency="EUR"
currencies="1,1027"

req="https://pro-api.coinmarketcap.com/v2/cryptocurrency/quotes/latest?CMC_PRO_API_KEY="+key+"&convert="+base_currency+"&id="+currencies
response = requests.get(req)
data=response.json()

##print( data['data']['1']['symbol']) 
##print( data['data']['1']['quote']['EUR']['price'] )

##print( data['data']['1027']['symbol'])
##print( data['data']['1027']['quote']['EUR']['price'] )

btc=data['data']['1']['symbol']
btc_val=int(data['data']['1']['quote']['EUR']['price'])

eth=data['data']['1027']['symbol']
eth_val=int(data['data']['1027']['quote']['EUR']['price'])



tooltip_text = str.format(
   "{}\n{}",
    f"{btc} : {btc_val} €",
    f"{eth} : {eth_val} €",
)

# print waybar module data
out_data = {
    "text": f"{btc} : {btc_val} €",
    "alt": f"{btc} : {btc_val} €",
    "tooltip": tooltip_text,
}

print(json.dumps(out_data), flush=True)

response_data=f"{btc}:{btc_val}\n" + \
f"{eth}:{eth_val}\n"

try:
    with open(os.path.expanduser("~/.cache/.CMC_cache"), "w") as file:
        file.write(response_data)
except:
    pass
