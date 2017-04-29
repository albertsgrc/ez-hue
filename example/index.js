// Generated by CoffeeScript 1.12.4
var Api, LightGroup, USERNAME, api, bedRoomLights, lights, randomMadness, ref;

ref = require('..'), Api = ref.Api, LightGroup = ref.LightGroup;

USERNAME = "your-username";

api = new Api({
  username: USERNAME
});

api = new Api({
  username: USERNAME,
  hostname: '192.168.1.128'
});

lights = api.getLights();

lights.turnOff();

lights.turnOn();

lights.Bola.turnOff();

lights.setBrightness(0.7);

lights.Bola.setBrightness(1);

lights.setColor('FF5500');

lights.Bola.setColor('orange');

lights.LivingRoom1.setColor('rgb(124, 96, 200)');

lights.setTransitionTime(0);

bedRoomLights = new LightGroup([lights.bedRoomTable, lights.bedRoomCeiling]);

bedRoomLights = new LightGroup({
  table: lights.bedRoomTable({
    ceiling: lights.bedRoomCeiling
  })
});

bedRoomLights.turnOff();

bedRoomLights.table.turnOn().setBrightness(0.5).setColor('LightYellow');

bedRoomLights.add(lights.bedRoomStrip, 'strip');

bedRoomLights.remove('strip');

(randomMadness = function(lights) {
  var COLOR_CHARACTERS, f, j, len, light, pickRandom, randomInRange, randomTime, ref1, results;
  COLOR_CHARACTERS = "abcdef0123456789";
  pickRandom = function(from) {
    return from[Math.round(Math.random() * (from.length - 1))];
  };
  randomInRange = function(a, b) {
    return Math.random() * (b - a) + a;
  };
  randomTime = function() {
    return Math.floor(randomInRange(100, 5000));
  };
  f = function(light) {
    var i;
    light.setBrightness(Math.random()).setColor(((function() {
      var j, results;
      results = [];
      for (i = j = 0; j < 6; i = ++j) {
        results.push(pickRandom(COLOR_CHARACTERS));
      }
      return results;
    })()).join(""));
    return setTimeout((function() {
      return f(light);
    }), randomTime());
  };
  lights.turnOn();
  ref1 = lights.array;
  results = [];
  for (j = 0, len = ref1.length; j < len; j++) {
    light = ref1[j];
    results.push(f(light));
  }
  return results;
})(lights);
