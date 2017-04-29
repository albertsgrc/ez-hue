request = require 'sync-request'
Color = require 'onecolor'

module.exports = @

r = (args...) -> JSON.parse request(args...).getBody('utf8')

toXY = (color) ->
    [ red, green, blue ] = [ color.red(), color.green(), color.blue() ]

    [ X, Y, Z ] = [ red*0.664511 + green*0.154324 + blue*0.162028
                    red*0.283881 + green*0.668433 + blue*0.047685
                    red*0.000088 + green*0.072310 + blue*0.986039 ]

    xy = [ X/(X + Y + Z), Y/(X + Y + Z) ]

    { xy }

@Light = class Light
    constructor: (@api, light, @lightId) ->
        this[prop] = value for prop, value of light

    setState: (state) ->
        r 'PUT', @api.url("lights/#{@lightId}/state"), { json: state }
        @state[prop] = value for prop, value of state
        this

    turnOn: -> @setState { on: yes }
    turnOff: -> @setState { on: no }
    setColor: (color) -> @setState toXY(Color(color))
    setBrightness: (value) -> @setState { bri: Math.round value*254 }
    setTransitionTime: (value) -> @setState { transitiontime: value }
    setEffect: (value) -> @setState { effect: value }

@LightGroup = class LightGroup
    constructor: (lights) ->
        if Array.isArray lights
            @array = lights
            @object = {}
            @object[light.name] = light for light in @array
        else
            @array = (light for _, light of lights)
            @object = lights

        throw "Not a light" for light in @array when light not instanceof Light

        this[lightName] = light for lightName, light of @object

        for prop, value of new Light when typeof value is "function"
            do (prop) =>
                this[prop] = (args...) =>
                    for light in @array
                        light[prop](args...)

    remove: (lightName) ->
        @array.splice(@array.indexOf(@object[lightName]), 1)
        delete @object[lightName]
        delete @[lightName]

    add: (light, name) ->
        throw "First argument to LightGroup::add must be a Light!" if light not instanceof Light
        @array.push light
        @object[name ? light.name] = light
        @[name ? light.name] = light


@Api = class Api
    constructor: ({ @username, @hostname } = {}) ->
        unless @hostname?
            bridges = r 'GET', "https://www.meethue.com/api/nupnp"

            unless bridges?[0]?
                throw "Bridge not found"

            [ { internalipaddress: @hostname } ] = bridges

            console.log "Detected bridge #{@hostname}"

    url: (path) -> "http://#{@hostname}/api/#{@username}/#{path}"

    getLights: ->
        @lights = {}
        for lightId, light of r('GET', @url("lights"))
            @lights[light.name] = new Light(this, light, lightId)
        @lights = new LightGroup @lights
