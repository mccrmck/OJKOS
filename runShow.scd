(
var server = Server.default;
var inputs = Dictionary[
	'henriette'  -> 0,
	'camilla'    -> 1,
	'maria'      -> 2,
	'sigrid'     -> 3,
	'tina'       -> 4,

	'richard'    -> 5,
	'lyder'      -> 6,
	'tancred'    -> 7,

	'andreas'    -> 8,
	'magnus'     -> 9,
	'johannes'   -> 10,

	'knutVibes'  -> 16,
	'knutPerc'   -> 17,
	'arneMartin' -> 18,
	'alexander'  -> 19,
	'oskar'      -> 20,

	'mains'      -> 22, // and 23!
];

var clickOuts = Dictionary[
	'henriette'  -> 17,
	'camilla'    -> 16,
	'maria'      -> 15,
	'sigrid'     -> 14,
	'tina'       -> 13,

	'richard'    -> 10,
	'lyder'      -> 11,
	'tancred'    -> 12,

	'andreas'    -> 7,
	'magnus'     -> 8,
	'johannes'   -> 9,

	'knut'       -> 18,
	'arneMartin' -> 5,
	'alexander'  -> 6,
	'oskar'      -> 4,

	'mike'       -> 19,
	'all'        -> (4..19),
];

var synthOuts = 0; // stereo dvs. [0,1]
var processOuts = 2; // stereo dvs. [2,3]
var kickOut = 20; // stereo dvs. [20,21]
var lemurAddr = NetAddr("192.168.0.101", 8000);

//server init stuff
server.options.numInputBusChannels = 32;
server.options.numOutputBusChannels = 32;
// server.options.device = "Dante Virtual Soundcard";

OJKOS(inputs,clickOuts,synthOuts,processOuts,kickOut,lemurAddr);
)

Safety.enable
Safety.disable


SoundCheck(32).static(13)
SoundCheck(32,[4,6,5,18,19,7,8,9,10,11,12,17,16,15,14,13]).sweep(0.1)
SoundCheck(32).clear

a = OJKOS.cueFrom('caseD','caseF',true,true,false)
a.play
a.stop
