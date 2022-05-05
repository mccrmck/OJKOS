//////////// == CONTROL STRUCTURES: SCORE == ////////////

var cueKeys = ['introLoop','tuneLoop','ifStart','ifStartRM','elseLoop'];
var outs = OJKOS.clickOutBus;
var pats = OJKOS.patterns;

[
	/*=============   intro   ==============*/

	(
		name: 'introA',
		countIn: [[]],
		click: [
			[
				ClickConCatLoop( cueKeys[0],ClickCue(60/2,4,2),Click(60/2,4,2,3) ).out_([ outs['henriette'],outs['tina'],outs['lyder'],outs['johannes'],outs['knut'],outs['mike'] ]),
				ClickConCat(1,ClickCue(60/2,4,2),Click(60/2,4,2),ClickCue(60/2,2,2,2),ClickCue(60/2,1,2,2),ClickCue(60,1,1,4) ).out_([ outs['henriette'],outs['tina'],outs['lyder'],outs['johannes'],outs['knut'],outs['mike'] ])
			],[
				ClickConCatLoop( cueKeys[0],ClickCue(75/2,5,2),Click(75/2,5,2,3) ).out_([ outs['camilla'],outs['richard'],outs['arneMartin'] ]),
				ClickConCat(1,ClickCue(75/2,5,2),Click(75/2,5,2),ClickCue(75/2,3,2),ClickCue(75/2,2,2),ClickCue(75/2,1,2,5) ).out_([ outs['camilla'],outs['richard'],outs['arneMartin'] ])
			],[
				ClickConCatLoop( cueKeys[0],ClickCue(67.5,3),Click(67.5,3,1,11) ).out_([ outs['maria'],outs['andreas'],outs['alexander'] ]),
				ClickConCat(1, ClickCue(67.5,3),Click(67.5,3,1,5),ClickCue(67.5,3,1,4),ClickCue(67.5,1,1,6) ).out_([ outs['maria'],outs['andreas'],outs['alexander'] ])
			],[
				ClickConCatLoop( cueKeys[0],ClickCue(52.5,4),Click(52.5,3), ClickConCat(3,Click(52.5,4),Click(52.5,3)) ).out_([ outs['sigrid'],outs['tancred'],outs['magnus'],outs['oskar'] ]),
				ClickConCat(1,ClickCue(52.5,4),Click(52.5,3),Click(52.5,4),Click(52.5,3),ClickCue(52.5,4),ClickCue(52.5,3),ClickCue(52.5,2,1,2),ClickCue(52.5,1,1,3) ).out_([ outs['sigrid'],outs['tancred'],outs['magnus'],outs['oskar'] ])
			],
		],
		pats: [],
	),
	(
		name: 'introB',
		countIn: [[ ClickConCat(1,Click(50,2,1,2),Click(50,1,1,4)).out_(outs['all']) ]],
		click: [[ ClickConCat(Click(50,4),ClickLoop(50,4,loopKey: cueKeys[1]),ClickCue(50,2,1,2),ClickCue(50,1,1,4),Click(50,3,1,2)).out_(outs['all']) ]],
		pats: [ pats['tuneLoop'], pats['recBandIntro'] ],
	),

	/*=============   break   ==============*/
	(
		name: 'breakIntro',
		countIn: [[ ]],
		click: [[ Click(133.125,4,1,12).out_( outs['mike'] ) ]],
		pats: [ pats['breakIntro'] ],
	),(
		name: 'breakPickup',
		countIn: [[ ClickConCat(1,Click(133.125,2,1,2),Click(133.125,1,1,4)).out_([ outs['tina'],outs['arneMartin'],outs['mike'] ]) ]],
		click: [[ ClickConCat(1,Click(133.125,4,1,4),ClickCue(133.125,2,1,2),ClickCue(133.125,1,1,4)).out_([ outs['tina'],outs['arneMartin'],outs['mike'] ]) ]],
		pats: [ pats['tranceKickSlo'].finDur(60/133.125 * 24), pats['breakStartFred'] ],
	),
	(
		name: 'breakA',
		countIn: [[ ClickConCat(1,Click(133.125,2,1,2),Click(133.125,1,1,4)).out_([ outs['tina'],outs['arneMartin'],outs['mike'] ])]],
		click: [
			[ ClickConCat(1,Click(133.125,3,1,8),ClickCue(133.125,3,1),ClickCue(133.125,1,1,3)).out_([ outs['tina'],outs['arneMartin'],outs['mike'] ]),ClickConCat(18,Click(133.125 * 2,3),Click(133.125 * 2,2)).out_([ outs['tina'],outs['arneMartin'],outs['mike'] ]) ],
			[ ClickRest(133.125,3,10),ClickRest(133.125 * 2,5,15),ClickConCat(1,ClickCue(142,2,1,2),ClickCue(142,1,1,4)).out_([ outs['maria'],outs['tancred'],outs['magnus'],outs['oskar'] ]) ],
		],
		pats: [ pats['tranceKickSlo'].finDur(60/133.125 * 75), pats['breakAFred'] ],
	),(
		name: 'breakB',
		countIn: [
			[ ClickConCat(1,Click(133.125,2,1,2),Click(133.125,1,1,4)).out_([ outs['tina'],outs['arneMartin'] ]) ],
			[ ClickRest(60/0.2253521126762),ClickConCat(1,Click(142,2,1,2),Click(142,1,1,4)).out_([ outs['maria'],outs['tancred'],outs['magnus'],outs['oskar'] ]) ]
		],
		click: [
			[ ClickConCat(18,Click(133.125 * 2,3),Click(133.125 * 2,2)).out_([ outs['tina'],outs['arneMartin'] ]) ],
			[ Click(142,4,1,12).out_([ outs['maria'],outs['tancred'],outs['magnus'],outs['oskar'] ])  ],
			[ ClickRest(142,4*8),ClickConCat(1,Click(142,4,1,2),ClickCue(142,2,1,2),ClickCue(142,1,1,4)).out_([ outs['henriette'],outs['camilla'],outs['sigrid'],outs['richard'],outs['lyder'],outs['andreas'],outs['johannes'] ])  ],
		],
		pats: [ pats['tranceKickSlo'].finDur(60/133.125 * 45), pats['breakRiserB'] ],
	),(
		name: 'breakC',
		countIn: [[ ClickConCat(1,Click(142,2,1,2),Click(142,1,1,4)).out_(outs['all']) ]],
		click: [[ Click(142,4,1,15).out_(outs['all']) ]],
		pats: [ pats['tranceGateRec'] ],
	),
	(
		name: 'breakD',
		countIn: [[ ClickConCat(1,Click(142,2,1,2),Click(142,1,1,4)).out_([ outs['alexander'],outs['oskar'],outs['mike'] ]) ]],
		click: [[ Click(142,4,1,24).out_([ outs['alexander'],outs['oskar'],outs['mike'] ]),ClickConCat(1,Click(142,4,1,3),ClickCue(142,2,1,2),ClickCue(142,1,1,4)).out_([ outs['knut'],outs['arneMartin'],outs['alexander'],outs['oskar'],outs['mike'] ]) ]],
		pats: [ pats['tranceGate'].finDur(60/142 * 4 * 24), pats['tranceKickFast'].finDur(60/142 * 4 * 29), pats['breakRiserD'] ],
	),
	(
		name: 'breakE',
		countIn: [[ ClickConCat(1,Click(142,2,1,2),Click(142,1,1,4)).out_([ outs['knut'],outs['arneMartin'],outs['alexander'],outs['oskar'],outs['mike'] ]) ]],
		click: [[ Click(142,4,1,24).out_([ outs['knut'],outs['arneMartin'],outs['alexander'],outs['oskar'],outs['mike'] ]) ]],
		pats: [ pats['tranceGate'].finDur(60/142 * 4 * 24), pats['tranceKickFast'].finDur(60/142 * 4 * 24), pats['breakRiserE'] ],
	),
	(
		name: 'breakF',
		countIn: [[ ClickConCat(1,Click(142,2,1,2),Click(142,1,1,4)).out_(outs['all']) ]],
		click: [[ ClickConCat(1,Click(142,4,1,6),ClickCue(142,2,1,2),ClickCue(142,1,1,4)).out_(outs['all']) ]],
		pats: [ pats['tranceGate'].finDur(60/142 * 4 * 8) ],
	),
	(
		name: 'breakG',
		countIn: [[ ClickConCat(1,Click(142,2,1,2),Click(142,1,1,4)).out_(outs['all']) ]],
		click: [[ Click(142,4,1,16).out_(outs['all']) ]],
		pats: [ pats['tranceKickFast'].finDur(60/142 * 4 * 16) ],
	),
	(
		name: 'breakH',
		countIn: [[ ClickConCat(1,Click(142,2,1,2),Click(142,1,1,4)).out_(outs['all']) ]],
		click: [
			[ Click(142,4,1,16).out_(outs['all'].reject({ |i| i == outs['arneMartin'] }) ) ],
			[ ClickConCat(1,Click(142,4,1,14),ClickCue(142,2,1,2),ClickCue(142,1,1,4)).out_(outs['arneMartin']) ]
		],
		pats: [ pats['tranceKickFast'].finDur(60/142 * 4 * 16), pats['recBandBreak'] ],
	),
	(
		name: 'breakI',
		countIn: [[ ClickConCat(1,Click(142,2,1,2),Click(142,1,1,4)).out_(outs['all']) ]],
		click: [[ Click(142,4,1,16).out_(outs['all']) ]],
		pats: [ pats['tranceGate'].finDur(60/142 * 4 * 16), pats['tranceGateEnd'], pats['tranceKickFast'].finDur(60/142 * 4 * 16), pats['breakRiserI'] ],
	),

	/*=============   case   ==============*/

	(
		name: 'caseA',
		countIn: [[]],
		click: [
			[ ClickConCat(1,Click(96,4,1,6), ClickCue(96,2,1,2),ClickCue(96,1,1,4)).out_([ outs['henriette'], outs['tina'], outs['mike'] ]) ],
			[ ClickConCat(1,Click(144,3,1,12),ClickCue(144,3,1,3),ClickCue(144,1,1,3)).out_(outs['camilla']) ],
			[ ClickConCat(6,Click(120,3,1),Click(120,2,1)).out_(outs['maria']),ClickConCat(1,ClickCue(120,3),ClickCue(120,2),ClickCue(120,1,1,5)).out_(outs['maria'])  ],
			[ ClickConCat(6,Click(168,4,1),Click(168,3,1)).out_(outs['sigrid']),ClickConCat(1,ClickCue(168,4),ClickCue(168,3),ClickCue(168,4),ClickCue(168,1,1,3)).out_(outs['sigrid']) ],
		],
		pats: [ pats['pluckA'] ],
	),(
		name: 'caseB',
		countIn: [
			[ ClickConCat(1,Click(96,2,1,2),Click(96,1,1,4)).out_([ outs['henriette'], outs['tina'], outs['mike'] ]) ],
			[ Click(144,3,1,4).out_(outs['camilla'])  ],
			[ ClickConCat(2,Click(120,3,1),Click(120,2,1)).out_(outs['maria'])  ],
			[ ClickConCat(2,Click(168,4,1),Click(168,3,1)).out_(outs['sigrid'])  ],
		],
		click: [
			[ ClickConCat(1,Click(96,4,1,26),ClickCue(96,2,1,2),ClickCue(96,1,1,4)).out_([ outs['henriette'], outs['tina'], outs['mike'] ]) ],
			[ Click(144,3,1,32).out_(outs['camilla']) ],
			[ ClickConCat(16,Click(120,3,1),Click(120,2,1)).out_(outs['maria']) ],
			[ ClickConCat(16,Click(168,4,1),Click(168,3,1)).out_(outs['sigrid']) ],
		],
		pats: [ pats['pluckB'], pats['resNoiseB'], pats['recBandCase'] ],
	),(
		name: 'caseC',
		countIn: [[ ClickConCat(1,Click(96,2,1,2),Click(96,1,1,4)).out_([ outs['henriette'],outs['camilla'],outs['maria'],outs['sigrid'], outs['tina'], outs['mike'] ]) ]],
		click: [[ ClickConCat(1,Click(96,4,1,14),ClickCue(96,2,1,2),ClickCue(96,1,1,4)).out_([ outs['henriette'],outs['camilla'],outs['maria'],outs['sigrid'], outs['tina'], outs['mike'] ]) ]],
		pats: [
			pats['thumpSine'].finDur(60/96 * 4 * 16), pats['klikC'],
			pats['hiSine'].finDur(60/96 * 4 * 16), pats['resNoiseC'].finDur(60/96 * 4 * 15)
		],
	),(
		name: 'caseD',
		countIn: [[ ClickConCat(1,Click(96,2,1,2),Click(96,1,1,4)).out_([ outs['henriette'],outs['camilla'],outs['maria'],outs['sigrid'], outs['tina'], outs['mike'] ]) ]],
		click: [[ ClickConCat(1,Click(96,4,1,16),Click(130,4,1,3)).out_([ outs['henriette'],outs['camilla'],outs['maria'],outs['sigrid'], outs['tina'], outs['mike'] ]) ]],
		pats: [
			pats['thumpSine'].finDur(60/96 * 4 * 16), pats['klikD'].finDur(60/96 * 4 * 16),
			pats['breakSine'], pats['breakNoise'], pats['randSines'].finDur(60/96 * 4 * 16),
			pats['noiseFilt'].finDur(60/96 * 4 * 16), pats['breathRiff'].finDur(60/96 * 4 * 16),
			pats['hiSine'].finDur(60/96 * 4 * 16), pats['freezeD'], pats['freezeCombD']
		],
	),(
		name: 'caseE',
		countIn: [[ ClickConCat(1,Click(130,2,1,2),Click(130,1,1,4)).out_([ outs['henriette'],outs['camilla'],outs['maria'],outs['sigrid'], outs['tina'], outs['mike'] ]) ]],
		click: [[ Click(130,4,1,16).out_([ outs['henriette'],outs['camilla'],outs['maria'],outs['sigrid'], outs['tina'], outs['mike'] ]) ]],
		pats: [ pats['thumpSineE'],pats['klikSlow'].finDur(60/130 * 4 * 16), pats['glitchFills'].finDur(60/130 * 4 * 16), pats['freezeE'], pats['randFreezeComb'].finDur(60/130 * 4 * 16) ],
	),(
		name: 'caseF',
		countIn: [[ ClickConCat(1,Click(130,2,1,2),Click(130,1,1,4)).out_([ outs['henriette'],outs['camilla'],outs['maria'],outs['sigrid'], outs['tina'], outs['mike'] ]) ]],
		click: [[ ClickConCat(1,Click(130,4,1,14),ClickCue(130,2,1,2),ClickCue(130,1,1,4)).out_([ outs['henriette'],outs['camilla'],outs['maria'],outs['sigrid'], outs['tina'], outs['mike'] ]) ]],
		pats: [
			pats['thumpSineF'], pats['klikSlow'].finDur(60/130 * 4 * 16),
			pats['glitchFills'].finDur(60/130 * 4 * 16),
			pats['caseEnd'], pats['endSine'], pats['freezeF'],
			pats['randFreezeComb'].finDur(60/130 * 4 * 16)
		],
	),

	/*=============   try   ==============*/

	(
		name: 'tryABC',
		countIn: [[]],
		click: [[ ClickCue(50,1).out_([ outs['henriette'],outs['maria'],outs['sigrid'],outs['richard'],outs['magnus'],outs['knut'],outs['mike'] ]) ]],
		pats: [],
	),(
		name: 'tryD',
		countIn: [[]],
		click: [
			[ ClickRest(50,2),ClickCue(50,1).out_([ outs['henriette'],outs['maria'] ]) ],
			[ ClickConCat(1,ClickCue(50,4),Click(50,4,1,2)).out_([ outs['sigrid'],outs['richard'],outs['magnus'],outs['knut'],outs['mike'] ]) ]
		],
		pats: [ pats['tryBassD'] ],
	),(
		name: 'tryE',
		countIn: [[]],
		click: [[ ClickConCat(1,Click(50,4),ClickCue(50,4)).out_([ outs['henriette'],outs['maria'],outs['sigrid'],outs['richard'],outs['magnus'],outs['knut'],outs['mike'] ]) ]],
		pats: [ pats['tryBassE'] ],
	),(
		name: 'tryF',
		countIn: [[]],
		click: [[ ClickCue(50,4).out_([ outs['henriette'],outs['richard'],outs['knut'],outs['mike'] ]) ]],
		pats: [ pats['tryBassF'], pats['tryPadsF'] ],
	),(
		name: 'tryG',
		countIn: [[]],
		click: [[ ClickCue(50,4).out_([ outs['henriette'],outs['richard'],outs['knut'],outs['mike'] ]) ]],
		pats: [ pats['tryBassG'], pats['tryPadsG'] ],
	),(
		name: 'tryH',
		countIn: [[]],
		click: [[ ClickCue(50,4).out_([ outs['richard'],outs['magnus'],outs['knut'],outs['mike'] ]) ]],
		pats: [ pats['tryBassH'], pats['tryPadsH'] ],
	),(
		name: 'tryI',
		countIn: [[]],
		click: [[ ClickCue(50,4).out_([ outs['sigrid'],outs['richard'],outs['magnus'],outs['knut'],outs['mike'] ]) ]],
		pats: [ pats['tryBassI'], pats['tryPadsI'] ],
	),(
		name: 'tryJ',
		countIn: [[]],
		click: [[ ClickCue(50,4).out_([ outs['sigrid'],outs['richard'],outs['magnus'],outs['knut'],outs['mike'] ]) ]],
		pats: [pats['tryBassJ'], pats['tryPadsJ'] ],
	),(
		name: 'tryK',
		countIn: [[]],
		click: [[
			ClickConCat(1,
				ClickCue(80,2,1,2),ClickCue(80,1,1,4),
				ClickEnv([80,72],4,2),ClickEnv([72,64],4,2),
				ClickEnv([64,83],4,2),ClickEnv([83,102],4,2),
				ClickEnv([102,91],4,2),ClickEnv([91,80],4,2),
				ClickEnv([80,85],4,2),ClickEnv([85,90],4,2),
			).out_([ outs['henriette'],outs['maria'],outs['sigrid'],outs['richard'],outs['magnus'],outs['knut'],outs['mike'] ])
		]],
		pats: [ pats['tryBassK'], pats['tryPadsK'] ],
	),(
		name: 'tryL',
		countIn: [[ ClickConCat(1,Click(90,2,2,2),Click(90,1,2,4)).out_([ outs['henriette'],outs['maria'],outs['sigrid'],outs['richard'],outs['magnus'],outs['knut'],outs['mike'] ]) ]],
		click: [[
			ClickConCat(1,
				ClickEnv([90,99],4,2),ClickEnv([99,108],4,2),
				ClickEnv([108,97.2],4,2),ClickEnv([97.2,86.4],4,2),
				ClickEnv([86.4,94.2],4,2),ClickEnv([94.2,102],4,2),
				ClickEnv([102,99],4,2),ClickEnv([99,96],4,2),
			).out_([ outs['henriette'],outs['maria'],outs['sigrid'],outs['richard'],outs['magnus'],outs['knut'],outs['mike'] ])
		]],
		pats: [ pats['tryBassL'], pats['tryPadsL'], pats['recBandTry'] ],
	),(
		name: 'tryM',
		countIn: [[ ClickConCat(1,Click(96,2,2,2),Click(96,1,2,4)).out_([ outs['henriette'],outs['maria'],outs['sigrid'],outs['richard'],outs['magnus'],outs['knut'],outs['mike'] ]) ]],
		click: [[
			ClickConCat(1,
				ClickEnv([96,102.5],4,2),ClickEnv([102.5,109],4,2),
				ClickEnv([109,88.5],4,2),ClickEnv([88.5,68],4,2),
				ClickEnv([68,66],4,2),ClickEnv([66,64],4,2),
				ClickEnv([64,83],4,2),ClickEnv([83,102],4,2),
				ClickEnv([102,91],4,2),ClickEnv([91,80],4,2),
				ClickEnv([80,85],4,2),ClickEnv([85,90],4,2),
				ClickEnv([90,99],4,2),ClickEnv([99,108],4,2),
				ClickEnv([108,97.2],4,2),ClickEnv([97.2,86.4],4,2),
				ClickEnv([86.4,75.2],4,2),ClickEnv([75.2,64],4,2),
			).out_([ outs['henriette'],outs['maria'],outs['sigrid'],outs['richard'],outs['magnus'],outs['knut'],outs['mike'] ])
		]],
		pats: [ pats['tryBassM'], pats['tryPadsM'] ],
	),(
		name: 'tryN',
		countIn: [[ ClickConCat(1,Click(64,2,2,2),Click(64,1,2,4)).out_([ outs['henriette'],outs['maria'],outs['sigrid'],outs['richard'],outs['magnus'],outs['knut'],outs['mike'] ]) ]],
		click: [[ Click(64,4,2,10).out_([ outs['henriette'],outs['maria'],outs['sigrid'],outs['richard'],outs['magnus'],outs['knut'],outs['mike'] ]) ]],
		pats: [ pats['tryBassN'], pats['tryPadsN'] ],
	),

	/*=============   push   ==============*/    /// must double check all these (especially outputs/layers) before the break / solo!!

	(
		name: 'pushA',
		countIn: [[  ]],
		click: [[ ClickConCat(1,ClickCue(150,2,1,2),ClickCue(150,1,1,4),Click(150,4,1,16)).out_([ outs['andreas'],outs['knut'],outs['arneMartin'],outs['alexander'],outs['oskar'],outs['mike'] ]) ]],
		pats: [ pats['pushA'].finDur(60/150 * 4 * 18) ],
	),(
		name: 'pushB',
		countIn: [[ ClickConCat(1,Click(150,2,1,2),Click(150,1,1,4)).out_([ outs['sigrid'],outs['lyder'],outs['andreas'],outs['knut'],outs['arneMartin'],outs['alexander'],outs['oskar'],outs['mike'] ]) ]],
		click: [[ ClickConCat(1,Click(150,4,1,14),ClickCue(150,2,1,2),ClickCue(150,1,1,4)).out_([ outs['sigrid'],outs['lyder'],outs['andreas'],outs['knut'],outs['arneMartin'],outs['alexander'],outs['oskar'],outs['mike'] ]) ]],
		pats: [],
	),(
		name: 'pushC',
		countIn: [[ ClickConCat(1,Click(150,2,1,2),Click(150,1,1,4)).out_([ outs['maria'],outs['sigrid'],outs['lyder'],outs['andreas'],outs['magnus'],outs['arneMartin'],outs['alexander'],outs['oskar'],outs['mike'] ]) ]],
		click: [[ Click(150,4,1,16).out_([ outs['maria'],outs['sigrid'],outs['lyder'],outs['andreas'],outs['magnus'],outs['arneMartin'],outs['alexander'],outs['oskar'],outs['mike'] ]) ]],
		pats: [],
	),(
		name: 'pushD',
		countIn: [[ ClickConCat(1,Click(150,2,1,2),Click(150,1,1,4)).out_([ outs['henriette'],outs['camilla'],outs['maria'],outs['sigrid'],outs['lyder'],outs['andreas'],outs['magnus'],outs['johannes'],outs['arneMartin'],outs['alexander'],outs['oskar'],outs['mike'] ]) ]],
		click: [[ Click(150,4,1,16).out_([ outs['henriette'],outs['camilla'],outs['maria'],outs['sigrid'],outs['lyder'],outs['andreas'],outs['magnus'],outs['johannes'],outs['arneMartin'],outs['alexander'],outs['oskar'],outs['mike'] ]) ]],
		pats: [],
	),(
		name: 'pushE',
		countIn: [[ ClickConCat(1,Click(150,2,1,2),Click(150,1,1,4)).out_([ outs['henriette'],outs['camilla'],outs['maria'],outs['sigrid'],outs['lyder'],outs['andreas'],outs['magnus'],outs['johannes'],outs['arneMartin'],outs['alexander'],outs['oskar'],outs['mike'] ]) ]],
		click: [[ Click(150,4,1,12).out_([ outs['henriette'],outs['camilla'],outs['maria'],outs['sigrid'],outs['lyder'],outs['andreas'],outs['magnus'],outs['johannes'],outs['arneMartin'],outs['alexander'],outs['oskar'],outs['mike'] ]) ]],
		pats: [ pats['recBandPush'] ],
	),(
		name: 'pushF',
		countIn: [[]],
		click: [[ ClickConCat(1,Click(150,4,1,4),ClickCue(150,2,1,2),ClickCue(150,1,1,4)).out_(outs['all']) ]],
		pats: [ pats['pushF'] ],
	),(
		name: 'pushG',
		countIn: [[ Click(150,2,1,2).out_(outs['all']),Click(150,1,1,4).out_(outs['all']) ]],
		click: [[ Click(150,4,1,16).out_(outs['all']) ]],
		pats: [ pats['pushG'] ],
	),(
		name: 'pushH',
		countIn: [[ Click(150,2,1,2).out_(outs['all']),Click(150,1,1,4).out_(outs['all']) ]],
		click: [[ Click(150,4,1,16 ).out_(outs['all']) ]],
		pats: [ pats['pushH'] ],
	),(
		name: 'pushI',
		countIn: [[ ClickConCat(1,Click(125,2,1,2),Click(125,1,1,4)).out_(outs['all']) ]],
		click: [[ ClickConCat(1,Click(125,4,2),Click(125,4,1,7),Click(150,4,2),Click(150,4,1,3),Click(169,4,2),Click(169,4,1,3)).out_(outs['all']) ]],
		pats: [ pats['pushI']  ],
	),(
		name: 'pushJ',
		countIn: [[ ClickConCat(1,Click(135,2,1,2),Click(135,1,1,4)).out_(outs['all'])  ]],
		click: [[ ClickConCat(1,Click(135,4,2,2),Click(155,4,2),Click(155,4,1,9),Click(120,4,2),Click(120,4,1,7)).out_(outs['all']) ]],
		pats: [ pats['pushJ'] ],
	),(
		name: 'pushK',
		countIn: [[ ClickConCat(1,Click(135,2,1,2),Click(135,1,1,4)).out_(outs['all']) ]],
		click: [[ ClickConCat(1,Click(135,4,2),Click(135,4,1,3),Click(100,4,2,2),Click(115,4,2,2),Click(135,4,2),Click(135,4,1,7)).out_(outs['all']) ]],
		pats: [  pats['pushK'] ],
	),(
		name: 'pushL',
		countIn: [[ ClickConCat(1,Click(135,2,1,2),Click(135,1,1,4)).out_(outs['all']) ]],
		click: [[ ClickConCat(1, Click(135,4,1,15),Click(90,3,2)).out_(outs['all']) ]],
		pats: [ pats['pushL'], pats['fredPop'] ],
	),

	/*=============   pop   ==============*/

	(
		name: 'popA',
		countIn: [[ ClickConCat(1,Click(90,2,1,2),Click(90,1,1,4)).out_( outs['all'].reject({|i| i == outs['andreas'] || {i == outs['magnus']} || {i == outs['johannes']} }) ) ]],
		click: [[
			ClickConCat(1,
				Click(90,4,1,2),Click(90,2),Click(72,2,2),
				Click(90,4,1,2),Click(90,2),Click(72,2,2),
				Click(90,4,1,2),Click(90,1,2),
			).out_( outs['all'].reject({|i| i == outs['andreas'] || {i == outs['magnus']} || {i == outs['johannes']} }) )
		]],
		pats: [],
	),(
		name: 'popB',
		countIn: [[ ClickConCat(1,Click(90,2,1,2),Click(90,1,1,4)).out_( outs['all'].reject({|i| i == outs['andreas'] || {i == outs['magnus']} || {i == outs['johannes']} }) ) ]],
		click: [[
			ClickConCat(1,
				Click(90,4,1,2),Click(90,2),Click(108,2,2),Click(108,4),
				Click(90,4,1,2),Click(90,2),Click(72,2,2),
				ClickEnv([90,80],4,2),ClickEnv([80,70],4,2),ClickEnv([70,60],4,2)
			).out_( outs['all'].reject({|i| i == outs['andreas'] || {i == outs['magnus']} || {i == outs['johannes']} }) )
		]],
		pats: [],
	),(
		name: 'popC',
		countIn: [[ ]],
		click: [[
			ClickConCat(1,
				ClickCue(90,2,1,2),ClickCue(90,1,1,4),
				Click(90,4,1,8)
			).out_( outs['all'] )
		]],
		pats: [],
	),(
		name: 'popD',
		countIn: [[ ClickConCat(1,Click(90,2,1,2),Click(90,1,1,4)).out_( outs['all'] ) ]],
		click: [[ Click(90,4,1,8).out_( outs['all'] ) ]],
		pats: [],
	),(
		name: 'popE',
		countIn: [[ ClickConCat(1,Click(90,2,1,2),Click(90,1,1,4)).out_( outs['all'] ) ]],
		click: [[
			ClickConCat(1,
				Click(90,4,1,2),Click(90,2),Click(72,2,2),
				Click(90,4),Click(90,2),Click(72,2,2),Click(90,4),
				Click(90,2),Click(72,2,2),Click(90,4,1,2),
			).out_( outs['all'] )
		]],
		pats: [],
	),(
		name: 'popF',
		countIn: [[ ClickConCat(1,Click(90,2,1,2),Click(90,1,1,4)).out_( outs['all'] ) ]],
		click: [[
			ClickConCat(1,
				Click(90,4,1,2),Click(90,2),Click(72,2,2),
				Click(90,4),Click(90,2),Click(72,2,2),Click(90,4),
				Click(90,2),Click(72,2,2),Click(90,4,1,2),
			).out_( outs['all'] )
		]],
		pats: [],
	),(
		name: 'popG',
		countIn: [[ ClickConCat(1,Click(90,2,1,2),Click(90,1,1,4)).out_( outs['all'] ) ]],
		click: [[
			ClickConCat(1,
				Click(90,4,1,2),Click(90,2),Click(72,2,2),
				Click(90,4),Click(90,2),Click(72,2,2),Click(90,4),
				Click(90,2),Click(72,2,2),Click(90,4,1,2),
			).out_( outs['all'] )
		]],
		pats: [ pats['recBandPop'] ],
	),(
		name: 'popH',
		countIn: [[ ClickConCat(1,Click(90,2,1,2),Click(90,1,1,4)).out_( outs['all'] ) ]],
		click: [[
			ClickConCat(1,
				Click(90,4,1,2),Click(90,2),Click(72,2,2),
				Click(90,4),Click(90,2),Click(72,2,2),Click(90,4),
				Click(90,2),Click(72,2,2),Click(90,4,1,2),
			).out_( outs['all'] )
		]],
		pats: [],
	),(
		name: 'popI',
		countIn: [[ ClickConCat(1,Click(90,2,1,2),Click(90,1,1,4)).out_( outs['all'] ) ]],
		click: [[
			ClickConCat(1,
				Click(90,4,1,2),Click(90,2),Click(72,2,2),
				Click(90,4),Click(90,2),Click(72,2,2),Click(90,4),
				Click(90,2),Click(72,2,2),Click(90,4,1,2),
			).out_( outs['all'] )
		]],
		pats: [],
	),(
		name: 'popJ',
		countIn: [[ ClickConCat(1,Click(90,2,1,2),Click(90,1,1,4)).out_( outs['all'] ) ]],
		click: [[
			ClickConCat(1,
				Click(90,4,1,2),Click(90,2),Click(72,2,2),
				Click(90,4),Click(90,2),Click(72,2,2),Click(90,4),
				Click(90,2),Click(72,2,2),Click(90,4,1,2),
				Click(60,3,2),ClickCue(120,1,1,4)
			).out_( outs['all'] )
		]],
		pats: [],
	),(
		name: 'popK',
		countIn: [[ ClickConCat(1,Click(60,2,2,2),Click(60,1,2,4)).out_([ outs['sigrid'],outs['tina'],outs['richard'],outs['lyder'],outs['tancred'],outs['andreas'],outs['magnus'],outs['johannes'],outs['arneMartin'],outs['alexander'],outs['oskar'],outs['mike'] ]) ]],
		click: [[
			ClickConCat(1,
				ClickEnv([60,55],4,2),ClickEnv([55,50],4,2),
				Click(50,4,2,6),Click(68,4,1,2),
				Click(68,4,1,12),ClickCue(68,2,1,2),ClickCue(68,1,1,4),ClickCue(68)
			).out_([ outs['sigrid'],outs['tina'],outs['richard'],outs['lyder'],outs['tancred'],outs['andreas'],outs['magnus'],outs['johannes'],outs['arneMartin'],outs['alexander'],outs['oskar'],outs['mike'] ])
		]],
		pats: [],
	),(
		name: 'popDoom',
		countIn: [[ ClickConCat(1,Click(68,2,1,2),Click(68,1,1,4)).out_([ outs['sigrid'],outs['tina'],outs['richard'],outs['lyder'],outs['tancred'],outs['andreas'],outs['magnus'],outs['johannes'],outs['arneMartin'],outs['alexander'],outs['oskar'],outs['mike'] ]) ]],
		click: [[ ClickConCat(1,Click(68,4,1,12),ClickCue(68,2,1,2),ClickCue(68,1,1,4),ClickCue(68)) .out_([ outs['sigrid'],outs['tina'],outs['richard'],outs['lyder'],outs['tancred'],outs['andreas'],outs['magnus'],outs['johannes'],outs['arneMartin'],outs['alexander'],outs['oskar'],outs['mike'] ]) ]],
		pats: [],
	),

	/*=============   if   ==============*/

	(
		name: 'ifStart',
		countIn: [[ ]],
		click: [[ ClickConCat(1,ClickCue(80,1,3,4),ClickLoop(80,1,3,2,loopKey: cueKeys[2]),ClickLoop(80,1,3,2,loopKey: cueKeys[3])).out_([ outs['henriette'],outs['knut'],outs['mike'] ]) ]],
		pats: [],
	),(
		name: 'ifA',
		countIn: [[ Click(80,1,3,4).out_([ outs['henriette'],outs['knut'],outs['mike'] ]) ]],
		click: [[
			ClickConCat(2,ClickCue(80,1,3),Click(80,1,3)).out_([ outs['henriette'],outs['knut'],outs['mike'] ]),ClickCue(80,1,3,4).out_([ outs['henriette'],outs['knut'],outs['mike'] ]),
			ClickConCat(1,Click(80,1,3,40),ClickCue(80,1,3,4)).out_([ outs['henriette'],outs['knut'],outs['mike'] ])
		]],
		pats: [],
	),(
		name: 'ifB',
		countIn: [[ Click(80,1,3,4).out_([ outs['henriette'],outs['knut'],outs['mike'] ]) ]],
		click: [[ ClickConCat(1,Click(80,1,3,17),ClickCue(80,1,3,4)).out_([ outs['henriette'],outs['knut'],outs['mike'] ]) ]],
		pats: [],
	),(
		name: 'ifC',
		countIn: [[ Click(80,1,3,4).out_([ outs['henriette'],outs['knut'],outs['mike'] ]) ]],
		click: [[ ClickConCat(1,Click(80,1,3,12),ClickCue(80,1,3,4)).out_([ outs['henriette'],outs['knut'],outs['mike'] ]) ]],
		pats: [],
	),(
		name: 'ifD',
		countIn: [[ Click(80,1,3,4).out_([ outs['henriette'],outs['knut'],outs['mike'] ]) ]],
		click: [[
			ClickConCat(1,
				Click(80,1,3,5),Click(60,1,3),Click(80,1,3,6),Click(120,1,2,3),
				Click(80,1,3,3),Click(110,1,3),Click(80,1,3,6),
				Click(80,1,3),Click(65,1,3,2),Click(50,1,3),Click(80,1,3,2),Click(50,1,3,2),Click(40,1,3,2)
			).out_([ outs['henriette'],outs['knut'],outs['mike'] ])
		]],
		pats: [],
	),(
		name: 'ifE',
		countIn: [[ ]],
		click: [[
			ClickConCat(1,
				ClickCue(120,1,3,4),
				Click(120,1,3,20),Click(90,1,3),
				Click(120,1,3,8),Click(180,1,2,4),Click(120,1,3,9),Click(70,1,3),
				Click(120,1,3,6),Click(150,1,2,2),Click(210,1,2),Click(150,1,2),Click(120,1,3,12),Click(70,1,3)
			).out_([ outs['henriette'],outs['knut'],outs['mike'] ])
		]],
		pats: [ pats['ifEKnut'], pats['ifEHenriette'], pats['recBandIf'] ],
	),(
		name: 'ifF',
		countIn: [[ Click(100,1,3,4).out_([ outs['henriette'],outs['knut'],outs['mike'] ]) ]],
		click: [[ ClickConCat(1,Click(100,1,3,2),Click(120,1,3,12),Click(100,1,3),ClickCue(100,1,3,4)).out_([ outs['henriette'],outs['knut'],outs['mike'] ]) ]],
		pats: [ pats['ifFKnut'], pats['ifFHenriette'] ],
	),(
		name: 'ifG',
		countIn: [[ Click(80,1,3,4).out_([ outs['henriette'],outs['knut'],outs['mike'] ]) ]],
		click: [[ ClickConCat(1,Click(80,1,3,3),Click(75,2,4,5),Click(75)).out_([ outs['henriette'],outs['knut'],outs['mike'] ]) ]],
		pats: [ pats['ifGKnut'], pats['ifGHenriette'] ],
	),

	/*=============   else   ==============*/

	(
		name: 'elseA',
		countIn: [[ ]],
		click: [[
			ClickConCat(1,ClickCue(60,2,1,2),ClickCue(60,1,1,4),Click(60,4,1,4), ClickLoop(60,4,1,2,loopKey: cueKeys[4])).out_([ outs['magnus'], outs['oskar'], outs['mike'] ]),
			ClickConCat(1,ClickCue(60,2,1,2),ClickCue(60,1,1,4)).out_(outs['all'])
		]],
		pats: [],
	),(
		name: 'elseB',
		countIn: [[ ClickConCat(1,Click(60,2,1,2),Click(60,1,1,4)).out_(outs['all']) ]],
		click: [[
			ClickConCat(1,
				Click(60,4,1,6),
				ClickCue(60,2,1,2),ClickCue(60,1,1,4),
				Click(60,4,1,1),
				ClickConCat(1,Array.fill(13 ,{ |i| ClickEnv([60+i, 61+i],4,1)}) ),
				ClickCue(73,2,1,2), ClickCue(74,1,1,4),
			).out_(outs['all']),
			Click(75,4,1,2).out_([ outs['magnus'], outs['oskar'], outs['mike'] ]),
			Click(75,4,).out_(outs['mike']),
		]],
		pats: [ pats['elsePlayBackB'] ],
	),(
		name: 'elseC',
		countIn: [[ ]],
		click: [[ClickConCat(1,ClickCue(60,2,1,2), ClickCue(60,1,1,4), Click(60,4,1,7) ).out_([ outs['maria'],outs['sigrid'],outs['tancred'],outs['andreas'],outs['magnus'],outs['knut'], outs['arneMartin'],outs['alexander'],outs['oskar'],outs['mike'] ])	]],
		pats: [ pats['elsePlayBackC'] ],
	),(
		name: 'elseD',
		countIn: [[ ClickConCat(1,Click(80,2,1,2),Click(80,1,1,4)).out_(outs['all']) ]],
		click: [[
			ClickConCat(1,
				Click(80,4,1,3),
				ClickEnv([80,95],4,2), ClickEnv([95,110],4,2),
				Click(110,4,2), ClickCue(110,1,1,2)
			).out_(outs['all'])
		]],
		pats: [ pats['elsePlayBackD'] ],
	),(
		name: 'elseE',
		countIn: [
			[ ClickConCat(1,Click(60,2,1,2), Click(60,1,1,4) ).out_([ outs['henriette'],outs['camilla'],outs['maria'],outs['sigrid'],outs['richard'],outs['lyder'],outs['tancred'], outs['magnus'],outs['johannes'], outs['mike'] ]) ],
			[ ClickConCat(1,Click(75,5,1,2) ).out_([ outs['tina'],outs['andreas'],outs['knut'],outs['arneMartin'],outs['alexander'],outs['oskar'] ]) ],
		],
		click: [
			[ ClickConCat(1,Click(60,4,2),Click(60,4,1,15),ClickCue(60,2,1,2), ClickCue(60,1,1,4) ).out_([ outs['henriette'],outs['camilla'],outs['maria'],outs['sigrid'],outs['richard'],outs['lyder'],outs['tancred'], outs['magnus'],outs['johannes'], outs['mike'] ]) ],
			[ ClickConCat(1,Click(75,5,1,12),Click(60,4,1,4),ClickCue(60,2,1,2), ClickCue(60,1,1,4) ).out_([ outs['tina'],outs['andreas'],outs['knut'],outs['arneMartin'],outs['alexander'],outs['oskar'] ]) ],
		],
		pats: [ pats['elsePlayBackE'] ],
	),(
		name: 'elseF',
		countIn: [[ ClickConCat(1,Click(60,2,1,2),Click(60,1,1,4)).out_( outs['all'] ) ]],
		click: [
			[ ClickConCat(1,Click(60,4,1,11),ClickCue(60,2,1,2),ClickCue(60,1,1,2) ).out_( outs['all'].reject({ |i| i == outs['mike'] }) ) ],
			[ ClickConCat(1,Click(60,4,1,11),ClickCue(60,2,1,2),ClickCue(60,1,1,4),Click(60,4,1,5),Click(60,2) ).out_( outs['mike'] ) ]
		],
		pats: [ pats['elsePlayBackF'], pats['elseFresNoise'].finDur(17 * 4) ],
	),

	/*=============   outro   ==============*/

	(
		name: 'outro',
		countIn: [[ ]],
		click: [[
			ClickRest(60,4,2),ClickRest(60/OJKOS.pbTracks['takk'].duration),
			Click(80,4,out: outs['henriette']),
			Click(80,4,out: outs['camilla']),
			Click(80,4,out: outs['maria']),
			Click(80,4,out: outs['sigrid']),
			Click(80,4,out: outs['tina']),
			Click(80,4,out: outs['tancred']),
			Click(80,4,out: outs['lyder']),
			Click(80,4,out: outs['richard']),
			Click(80,4,out: outs['johannes']),
			Click(80,4,out: outs['magnus']),
			Click(80,4,out: outs['andreas']),
			Click(80,4,out: outs['knut']),
			Click(80,4,out: outs['arneMartin']),
			Click(80,4,out: outs['alexander']),
			ClickRest(80,2),Click(80,4,out: outs['oskar']),
			ClickRest(80,4,4),Click(80,4,1,2).out_( outs['all'] )
		]],
		pats: [ pats['outroPling'], pats['takkHaDet'] ],
	)
]