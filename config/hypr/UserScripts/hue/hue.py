#!/usr/bin/env python3

import time, sys, json
from python_hue_v2 import Hue, BridgeFinder
from pathlib import Path


finder = BridgeFinder()
time.sleep(1)  # wait for search
# Get server by mdns
host_name = finder.get_bridge_server_lists()[0]  # Here we use first Hue Bridge

key = Path(__file__).with_name('appkey.txt')
with key.open('r') as f:
    app_key = f.readlines()

# or hue = Hue('ip address','app-key')
hue = Hue(host_name, app_key[0])  # create Hue instance

##print('Hue python script')

def lights(id):
  ##  print("Turning "+id+" All lights")

    lights = hue.lights

    if id == 'off':
        for light in lights:
          #  print(light.on)
            light.on = False
            light.brightness = 10.00
            
            out_data = {
                "text": f" Lights off",
                "tooltip": " Lights",
            }
            
            print(json.dumps(out_data))


    else:
        for light in lights:
           # print(light.on)
            light.on = True
            light.brightness = 20.00
            
            out_data = {
                "text": f" Lights on",
                "tooltip": " lights",
            }

            print(json.dumps(out_data))

def scenes(id):
    scenes = hue.scenes
    
    #for scene in scenes:
    #    print(scene.id)
    #    print( json.dumps(scene.data_dict, indent=4))
        
    scene = scenes[int(id)]
    
    ##print( scene.id )
    scene_data = (json.dumps(scene.data_dict, indent=4))
    ##print(scene_data)
    
    data = json.loads(scene_data)
    print(data['metadata']['name'])

    scene.recall(action='active')

def rooms():
    rooms = hue.rooms
    print(rooms)

def group_lights(id, val):
    grouped_lights = hue.grouped_lights
    
    group = grouped_lights[int(id)]
    print(group.type)
    
    if val == 'off': 
        group.set_state(on=False, brightness=10, duration_ms=1) # Feature in version 2.0.1
    else:
        group.set_state(on=True, brightness=10, duration_ms=1) # Feature in version 2.0.1

def brightness(id):
    lights = hue.lights

    for light in lights:
        ##print(light.on)
        if light.on == True:
            #light.on = True
            light.brightness = float(id)


def main():
    if len(sys.argv) < 2:
        lights('off')
        exit(0)
    else:
        func_name = sys.argv[1]
        id = sys.argv[2]
        
        if(func_name == 'group_lights'):
            val = sys.argv[3]
            group_lights(id,val) ##turn on or off a group off lights group id 0 all groups 1 is first group and so on
    
        elif(func_name == 'lights'):
            lights(id) ##turn all lights on or off
        
        elif(func_name == 'scenes'):
            scenes(id) ##activate a scene by giving id to scene 
        
        elif(func_name == 'br'):
            brightness(id) 

if __name__ == "__main__":
    main()
