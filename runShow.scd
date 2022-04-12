

(
var server = Server.default;
var inputs = IdentityDictionary[
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

	'knut'       -> 11,
	'arneMartin' -> 12,
	'alexander'  -> 13,
	'oskar'      -> 14,
];
var clickOuts = (0..24); // or whatever
var synthOuts = 25; // or whatever
var processOuts = 27; // or whatever
var lemurAddr = NetAddr("192.168.0.101", 8000);

//server init stuff
// more inputs???
// soundcard

OJKOS(clickOuts,synthOuts,processOuts,lemurAddr);
)
