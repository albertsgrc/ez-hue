{ Api, LightGroup } = require '..'

# TODO: Get your username following the steps on
#       https://developers.meethue.com/documentation/getting-started
#       You can get your bridge IP address running (new Api).hostname
USERNAME = "your-username"

# if you don't know the bridge IP and want the Api to the get it
# for ya
api = new Api { username: USERNAME } # IP on api.hostname
# or, if you know it
api = new Api { username: USERNAME, hostname: '192.168.1.128' }



# GETTING ALL LIGHTS
lights = api.getLights() # lights.array contains an array with the
                         # lights, lights.object contains the lights
                         # indexed by name



# TURNING ON/OFF
lights.turnOn() # Turn on all lights
lights.turnOff() # Turn them off
lights.Bola.turnOn() # Turn on only light with name 'Bola',
                      # note that lights also has all properties that
                      # lights.object has (light names)



# SETTING BRIGHTNESS
lights.setBrightness 0.7 # Set brightness of all lights to 70%
lights.Bola.setBrightness 1 # Set light with name 'Bola' to
                            # full brightness



# SETTING COLOR
lights.setColor 'FF5500' # Set color of all lights to #FF5500.
lights.Bola.setColor 'orange' # Set color of light with name 'Bola'
                              # to orange
lights.LivingRoom1.setColor 'rgb(124, 96, 200)' # Set color of light
                                                # with name
                                                # 'LivingRoom1' to
                                                # rgb(124, 96, 200)



# SETTING TRANSITION TIME
lights.setTransitionTime 0 # Default is 4 (400ms). This means for a
                           # value of x, lights will take x*100ms to
                           # change state when an operation is
                           # applied to them



# LIGHT GROUPS
# Create a light group to perform operations on all its lights
# at the same time. The value returned by api.getLights() is also
# a LightGroup
bedRoomLights = new LightGroup [ lights.bedRoomTable
                                 lights.bedRoomCeiling ]
# bedRoomLights.bedRoomTable, bedRoomLights.bedRoomCeiling to access
# individual lights

# or, if you want to give them new names
bedRoomLights = new LightGroup { table: lights.bedRoomTable
                                 ceiling: lights.bedRoomCeiling }

bedRoomLights.turnOff() # Going to sleep boi
bedRoomLights.table
             .turnOn()
             .setBrightness(0.5)
             .setColor('LightYellow') # Nevermind I'll read a book

# Add/remove
bedRoomLights.add lights.bedRoomStrip, 'strip'  # Add light with name
                                                # 'bedRoomStrip' to
                                                # the group and alias
                                                # it to 'strip'
                                                # (alias is optional)
bedRoomLights.remove 'strip' # Remove it from the group



# RENAMING LIGHTS

lights.Bola.rename 'Ball' # Renames light Bola to Ball
lights.Ball.rename 'Bola' # Rename back to Bola.
                          # Notice that all the LightGroup instances
                          # are automatically updated with the
                          # new name. This means an array is kept
                          # with all the LightGroup instances.
                          # To disable this behaviour in case
                          # you continuously create and delete
                          # tons of lightGroups you can set
                          # LightGroup.automaticRename = off
                          # Now you can instead notify the rename to
                          # each LightGroup instance manually with
                          # myLightGroup.notifyRename('Ball', 'Bola')

# Random shiet boi
do randomMadness = (lights) ->
    COLOR_CHARS = "abcdef0123456789"

    pickRandom = (a) -> a[Math.round(Math.random()*(a.length-1))]
    randomInRange = (a, b) -> Math.random()*(b-a) + a
    randomTime = -> Math.floor randomInRange(100,5000)

    f = (light) ->
        light.setBrightness(Math.random())
             .setColor(
                (pickRandom(COLOR_CHARS) for i in [0...6]).join("")
             )

        setTimeout((-> f(light)), randomTime())

    lights.turnOn()
    f light for light in lights.array
