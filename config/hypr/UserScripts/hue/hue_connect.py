import time
from python_hue_v2 import Hue, BridgeFinder

finder = BridgeFinder()
time.sleep(20)  # wait for search
# Get server by mdns
host_name = finder.get_bridge_server_lists()[0]  # Here we use first Hue Bridge

# If you don't have hue-app-key, press the button and call bridge.connect() (this only needs to be run a single time)
hue = Hue(host_name)
app_key = hue.bridge.connect() # you can get app_key and storage on disk

file_object = open('appkey.txt', 'w')
file_object.write(app_key)

file_object.close()

