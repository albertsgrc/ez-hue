# ez-hue

A simple easy to use Javascript interface to the Philips Hue API

## Installation

`npm install ez-hue`

## Example usage

```coffeescript
{ Api, LightGroup } = require '..'

# TODO: Get your username following the steps on https://developers.meethue.com/documentation/getting-started
#       You can get your bridge IP address running (new Api).hostname
USERNAME = "your-username"

# if you don't know the bridge IP and want the Api to the get it for ya
api = new Api { username: USERNAME } # IP on api.hostname
# or, if you know it
api = new Api { username: USERNAME, hostname: '192.168.1.128' }



# GETTING ALL LIGHTS
lights = api.getLights() # lights.array contains an array with the lights, lights.object contains the lights indexed by name



# TURNING ON/OFF
lights.turnOff() # Turn off all lights
lights.turnOn() # Turn them back on
lights.Bola.turnOff() # Turn off only light with name 'Bola'



# SETTING BRIGHTNESS
lights.setBrightness(0.7) # Set brightness of all lights to 70%
lights.Bola.setBrightness(1) # Set light with name 'Bola' to full brightness, note that lights also has all properties that the lights.object has



# SETTING COLOR
lights.setColor 'FF5500' # Set color of all lights to #FF5500.
                         # See https://github.com/One-com/one-color for all available color formats
lights.Bola.setColor 'orange' # Set color of light with name 'Bola' to orange
lights.LivingRoom1.setColor 'rgb(124, 96, 200)' # Set color of light with name 'LivingRoom1' to rgb(124, 96, 200)



# LIGHT GROUPS
# Create a light group to to perform operations on all of them at the same time. The value returned by api.getLights() is also a LightGroup
bedRoomLights = new LightGroup [ lights.bedRoomTable, lights.bedRoomCeiling ] # bedRoomLights.bedRoomTable, bedRoomLights.bedRoomCeiling
# or, if you want to give them new names (otherwise takes name from lights.bedRoomCeiling.name)
bedRoomLights = new LightGroup { table: lights.bedRoomTable, ceiling: lights.bedRoomCeiling }

bedRoomLights.turnOff() # Going to sleep boi
bedRoomLights.table.turnOn().setBrightness(0.5).setColor('LightYellow') # Nevermind I'll read a book

# Add/remove
bedRoomLights.add(lights.bedRoomStrip, 'strip') # Add light with name 'bedRoomStrip' to the group and alias it to 'strip' (alias is optional, otherwise takes same name)
bedRoomLights.remove('strip') # Remove it from the group



# Note that because light names are used as keys you should not
# have any duplicate light names in your setup. You can change the light
# names in the Hue Mobile App or Website (https://my.meethue.com)

# Also, note that light groups and operations on lights (turnOn, setBrightness, etc.)
# are both properties of the light group. This means you cannot have any light
# named 'turnOn', or 'setColor' and so on, although that would be weird.

### LIGHT PROPERTIES
Every light, for instance lights.Bola in this example, contains this properties
(values are just an example).

{
  api: Api from new Api to which the light belongs
  lightId: '2', # Light id generated by the Hue Api
  state:
   { on: true,
     bri: 254,
     hue: 9785,
     sat: 254,
     effect: 'none',
     xy: [ 0.4921, 0.458 ],
     ct: 424,
     alert: 'none',
     colormode: 'xy',
     reachable: true },
  type: 'Extended color light',
  name: 'Bola',
  modelid: 'LCT010',
  manufacturername: 'Philips',
  uniqueid: 'XX:XX:XX:XX:XX:XX:XX:XX-XX',
  swversion: '1.15.2_r19181',
  swconfigid: 'F921C859',
  productid: 'Philips-LCT010-1-A19ECLv4'
}
###

# Random shiet boi
do randomMadness = (lights) ->
    COLOR_CHARACTERS = "abcdef0123456789"

    pickRandom = (from) -> from[Math.round(Math.random()*(from.length-1))]
    randomInRange = (a, b) -> Math.random()*(b-a) + a
    randomTime = -> Math.floor randomInRange(100,5000)

    f = (light) ->
        light.setBrightness(Math.random())
             .setColor((pickRandom(COLOR_CHARACTERS) for i in [0...6]).join(""))

        setTimeout((-> f(light)), randomTime())

    lights.turnOn()
    f light for light in lights.array
```
