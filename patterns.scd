//////////// == CONTROL STRUCTURES: PATTERNS == ////////////

var ins = OJKOS.inBus;
var chords = Dictionary[

	\gbMaj -> [[42,46,53,56]],
	\abSus -> [[44,51,53,58]],

	\gQFl  -> [[42.5,46.5,53.5,56.5]],

	\gMaj  -> [[43,47,54,57]],
	\aSus  -> [[45,52,54,59]],

	\abMaj -> [[44,48,55,58]],
	\bBSus -> [[46,53,55,60]],

	\aMaj  -> [[45,49,56,59]],
	\bSus  -> [[47,54,56,61]],

	\bBMaj -> [[46,50,57,60]],
	\cSus  -> [[48,55,57,62]],

	\cQFl  -> [[47.5,51.5,58.5,61.5]],
	\dQFS  -> [[49.5,56.5,58.5,63.5]],

	\cMaj  -> [[48,52,59,62]],
	\dSus  -> [[50,57,59,64]],

	\dMaj  -> [[50,54,61,64]],
	\eSus  -> [[52,59,61,66]],
];

IdentityDictionary[

	'recBand' -> Pbind(
		\instrument,\recorderStereo,
		\dur,Pseq([0],1),
		\inBus,[[ ins['mains'], ins['mains'] + 1 ]],
		\bufnum,Pfunc({ OJKOS.nextElseBuf }),
	),

	/*=============   intro   ==============*/

	'tuneLoop' -> Pseq([
		ClickRest(50,4).pattern,
		Pwhile({ ~tune },
			Pbind(
				\instrument,\tune,
				\dur,Pseq([Pwhite(3,4.0,3),Pwhite(4,6,1)],1),
				\freq,Pseq([[0.25,0.5,1,2]] * [2,3,3,2]) * 46.midicps,
				\gain,Pwhite(1.0,1.2),
				\atk,Pwhite(4.0,6.0),
				\rls,Pwhite(6.0,7.0),
				\pan,Pfunc({ var rand = 0.4.rand2;  [0,0,rand,rand.neg] }),
				\amp,Pseq([[0.2,0.2,0.1,0.1]],inf),
				\out,OJKOS.synthOutBus
			)
		)
	]),

	/*=============   break   ==============*/

	'introBreak' -> Pbind(
		\instrument,\grainPerc,
		\dur,Pseq([0.5,0.5],24 + 15) * 60/133.125,
		\type,\note,
		\bufnum,OJKOS.pbTracks['break'],
		\rate,1,
		\pos,Pseq([0.25,0.4,0.5],inf), // descending fminor triad
		// \gain,Pseg([1,40],[40],\exp,inf),
		\gain,80,                                      // map this to a bus and wrap in a Pwhile to play live - go from kermit the frog to formant synth to drive!!
		\atk,0.01,
		\rls,0.2,
		\curve,5.neg,
		\pan,0,
		\amp,0.1,
		\out,OJKOS.synthOutBus
	),

	'breakFred' -> Pseq([
		Pbind(
			\instrument,\grainPerc,
			\dur,Pseq([0.5,0.5],24 + 15) * 60/133.125,
			\type,\note,
			\bufnum,OJKOS.pbTracks['break'],
			\rate,1,
			\pos,Pseq([0.25,0.4,0.5],inf), // descending fminor triad
			\gain,80,
			\atk,0.01,
			\rls,0.2,
			\curve,5.neg,
			\pan,0,
			\amp,0.1,
			\out,OJKOS.synthOutBus
		),
		Pbind(
			\instrument,\grainPerc,
			\dur,Pseq([0.5,0.5],15) * 60/133.125,
			\type,\note,
			\bufnum,OJKOS.pbTracks['break'],
			\rate,1,
			\pos,Pseq([0.25,0.4,0.5],inf), // descending fminor triad
			\gain,80,
			\atk,0.01,
			\rls,0.2,
			\curve,5.neg,
			\pan,0,
			\amp,Pseg([1,0.1],15 * 60/133.125,\exp) * 0.1,
			\out,OJKOS.synthOutBus
		),
	]),

	'tranceKickSlo' -> Pbind(
		\instrument,\bdSynth,
		\dur,60/133.125,
		\freq,29.midicps, //24 == C, 29 == F
		\sweep,0.06,
		\rq,0.05,
		\gain,4,
		\atk,0.001,
		\rls,0.08,
		\curve,14,
		\amp,0.1,
		\out,OJKOS.synthOutBus
	),

	'tranceGateRec' -> Pbind(
		\instrument,\recorderTrance,
		\dur,Pseq([0],1),
		\inBus,[[ ins['henriette'],ins['camilla'],ins['maria'],ins['sigrid'],ins['richard'],ins['lyder'],ins['tancred'],ins['andreas'],ins['magnus'],ins['johannes'] ]],
		\bufnum,OJKOS.tranceBuf,
	),

	'tranceGate' -> Pmono(\tranceGate,
		\dur,Prand([0.5,Pseq([0.25],2)],inf) * 60/142,
		\bufnum,OJKOS.tranceBuf,
		\gCurve,5.neg,
		\gAtk,0.249 * 60/142,
		\gRls,0.001 * 60/142,
		\trig,1,
		\amp,0.02.ampdb,
		\out,OJKOS.synthOutBus
	),

	'tranceKickFast' -> Pbind(
		\instrument,\bdSynth,
		\dur,60/142,
		\freq,29.midicps, //24 == C, 29 == F
		\sweep,0.06,
		\rq,0.05,
		\gain,4,
		\atk,0.001,
		\rls,0.08,
		\curve,14,
		\amp,0.1,
		\out,OJKOS.synthOutBus
	),

	/*=============   case   ==============*/

	'thumpSine' -> Pbind(
		\instrument,\glitchSine,
		\dur,Pseq([0.125,0.125,0.5,0.25,0.5,6.5,0.25,0.5,0.25,0.125,0.125,0.25,6.5],inf) * 60/96,
		\type,Pseq(\note!5 ++ [\rest,\rest] ++ (\note!5) ++ [\rest],inf),
		\legato,0.5,
		\freq, Pseq([[28, 73]],inf).midicps, //560
		\rls,0.001,
		\curve,10,
		\gain,2,
		\amp,Pseq([[1,0.03]],inf) * 0.3,
		\out,OJKOS.synthOutBus
	),

	'thumpSineE' -> Pseq([
		Pbind(
			\instrument,\glitchSine,
			\dur,Pseq([0.25,0.25,0.5,0.75,0.25,0.25,0.25]) * 60/130,
			\legato,0.5,
			\freq,Pseq([[40, 86]]++([28,86]!7),inf).midicps, // root == E
			\rls,Pseq([[0.03,0.08]],inf),
			\curve,10,
			\gain,4,
			\amp,Pseq([[1,0.04]],inf) * 0.1,
		),
		ClickRest(130,13.5).pattern,
		Pbind(
			\instrument,\glitchSine,
			\dur,Pseq([0.75,0.75,0.5,0.25,0.25,0.5]) * 60/130,
			\type,Pseq([\rest] ++ (\note!5)),
			\legato,0.5,
			\freq,Pseq([[43, 86],[43, 86],[43, 86],[31,86],[31,86],[31,86]],inf).midicps, // root == G
			\rls,Pseq([[0.03,0.08]],inf),
			\curve,10,
			\gain,2.5,
			\amp,Pseq([[1,0.04]],inf) * 0.1,
		),
		ClickRest(130,12).pattern,
		Pbind(
			\instrument,\glitchSine,
			\dur,Pseq([1,0.25,0.5,0.25,1]) * 60/130,
			\legato,0.5,
			\type,Pseq([\note,\rest,\note,\note,\note]),
			\freq,Pseq([[41, 86]]++([29,86]!4),inf).midicps, // root == F
			\rls,Pseq([[0.03,0.08]],inf),
			\curve,10,
			\gain,4,
			\amp,Pseq([[0.8,0.04]],inf) * 0.1,
		),
		ClickRest(130,14).pattern,
		Pbind(
			\instrument,\glitchSine,
			\dur,Pseq([0.25,0.25,0.5,0.75,0.25,0.25,0.25]) * 60/130,
			\legato,0.5,
			\freq,Pseq([[38, 86]]++([26,86]!7),inf).midicps, // root == D
			\rls,Pseq([[0.03,0.08]],inf),
			\curve,10,
			\gain,4,
			\amp,Pseq([[1,0.04]],inf) * 0.1,
		)
	]),

	'thumpSineF' -> Pseq([
		ClickRest(130,4).pattern,
		Pseq([
			Pbind(
				\instrument,\glitchSine,
				\dur,Pseq([0.25,0.25,0.5,0.75,0.25,0.25,0.25]) * 60/130,
				\legato,0.5,
				\freq,Pseq([[38, 86]]++([26,86]!7),inf).midicps, // root == D
				\rls,Pseq([[0.03,0.08]],inf),
				\curve,10,
				\gain,4,
				\amp,Pseq([[1,0.04]],inf) * 0.1,
			),
			ClickRest(130,17.5).pattern
		],3)
	]),

	'klikC' -> Pseq([
		Pbind(
			\instrument,\klik,
			\dur,0.125 * 60/96,
			\type,Pwrand([\rest,\grain],[0.2,0.8],inf),
			\fFreq,12000,
			\gain,20,
			\rq,0.8,
			\atk,0.001,
			\rls,0.001,
			\amp,Pstep([0.3,Pwhite(0.01,0.1,15)],0.125!16 * 60/96,inf),
			\pan, Prand([-0.8,-0.4,0.4,0.8],inf),
			\out,OJKOS.synthOutBus
		).finDur(60/96 * 4 * 14),

		Pbind(
			\instrument,\klik,
			\dur,0.125 * 60/96,
			\type,Pseq([Prand([\rest,\grain],32),Pseq([[\grain,\rest]!6 ++ ([\grain,\rest,\rest,\rest]!5)].flat) ]),
			\fFreq,12000,
			\gain,20,
			\rq,0.8,
			\atk,0.001,
			\rls,0.001,
			\amp,Pseg([0.3,0.1],8 * 60/96,\exp,inf),
			\pan, Prand([-0.8,-0.4,0.4,0.8],inf),
			\out,OJKOS.synthOutBus
		)
	]),

	'resNoiseC' -> Pmono(\resNoiseASR,
		\dur,0.01,
		\freq,[190,200] * 2,
		\gain,Pseg([4,10,4],[12,15],\lin,inf),
		\sineFreq,[190,200] * 4,
		\sineMix,0.1,
		\atk,0.01,
		\rls,7 * 60/96,
		\pan,[-0.5,0.5],
		\amp,0.005,
	),

	'hiSine' -> Pbind(
		\instrument,\glitchSine,
		\dur,Pseq([25.5,0.5,6],inf) * 60/96,
		\type,Pseq([\rest,\note,\rest],inf),
		\legato,1,
		\freq, Pseq([8000],inf),
		\atk,0.001,
		\rls,0.001,
		\curve,4,
		\gain,2,
		\amp,Pseq([0.02],inf),
		\out,OJKOS.synthOutBus,
	),

	'klikD' -> Pbind(
		\instrument,\klik,
		\dur,0.125 * 60/96,
		\type,Pwrand([\rest,\grain],[0.2,0.8],inf),
		\fFreq,12000,
		\gain,20,
		\rq,0.8,
		\atk,0.001,
		\rls,0.001,
		\amp,Pstep([0.3,Pwhite(0.01,0.1,15)],0.125!16 * 60/96,inf),
		\pan, Prand([-0.8,-0.4,0.4,0.8],inf),
		\out,OJKOS.synthOutBus
	),

	'randSines' -> Pbind(
		\instrument,\glitchSine,
		\dur,Pseq([7.5,0.5],inf) * 60/96,
		\type,Pseq([\rest,\note,\rest,\rest],inf),
		\legato,0.85,
		\freq,Pfunc({ var f = 1000.exprand(2000); [f,3000]}),
		\rls,0.001,
		\curve,10.neg,
		\gain,2,
		\amp,Pseq([0.03],inf),
		\out,OJKOS.synthOutBus
	),

	'noiseFilt' -> Pbind(
		\instrument, \noiseFilt,
		\dur,Pseq([7.5,0.5],inf) * 60/96,
		\type,Pseq([\rest,\note,\rest,\rest],inf),
		\legato,0.85,
		\hpFreq,200,
		\hpQ,1,
		\lpFreq,4000,
		\lpQ,1,

		\atk,0.01,
		\rls,0.01,
		\curve,10.neg,
		\offset,0,
		\gain,Pseq([1],inf),
		\amp,0.03,
		\out,OJKOS.synthOutBus
	),

	'breathRiff' -> Pbind(
		\instrument,\glitchSine,
		\dur,Pseq([0.25,0.5,0.25,0.5,0.5,0.5,0.5,0.25,0.25,0.5],inf) * 60/96,
		\type,Pseq(\note!5 ++ [\rest] ++ (\note!4),inf),
		\legato,Pkey(\dur) * 1.3,
		\freq, Pstep([[100,95],[95,90]],[8,8] * 60/96,inf),
		\rls,0.001,
		\curve,10,
		\gain,4,
		\amp,Pseq([0.05],inf),
		\out,OJKOS.synthOutBus
	),

	'breakSine' -> Pseq([
		ClickRest(96,4,16).pattern,
		Pbind(
			\instrument,\glitchSine,
			\dur,Pseq([4] ++ (0.25!32),1) * 60/130,
			\type,Pseq([\note,Pwrand([\note,\rest],[0.85,0.15],32)],inf),
			\freq,Pseq([2] ++ (1!32),inf) * Pseq([[86.midicps,1100]],inf),
			\gain,4,
			\rls,Pseq([0.001],inf),
			\curve,10,
			\amp,Pseq([0.02] ++ (0.03!32),inf),
			\pan, Pseq([[-0.25,0.25]],inf),
			\out,OJKOS.synthOutBus
		)
	]),

	'breakNoise' -> Pseq([
		ClickRest(96,4*15 + 3).pattern,
		Pmono(
			\lfNoise,
			\dur,0.001,
			\freq, Pseg([100,8000],[60/96],\exp),
			\combFreq,Pseg([40,80].midicps,[60/96]),
			\dcy,0.02.neg,
			\atk,0.001,
			\sus,60/96,
			\rls,0.001,
			\gain,10,
			\pan,Pseq([[-1,1]],inf),
			\amp, 0.03,
			\out,OJKOS.synthOutBus,
		)
	]),

	'klikSlow' -> Pbind(
		\instrument,\klik,
		\dur,Pwrand([0.5,0.25,Pseq([0.125],2)],[0.1,0.85,0.05],inf) * 60/130,
		\fFreq,Pwhite(1000,3000),
		\gain,30,
		\rq,0.3,
		\atk,0.001,
		\rls,0.02,
		\curve,2.neg,
		\amp,Pstep([0.1] ++ (Pwhite(0.01,0.05,1)!7),0.25!8,inf),
		\pan, Prand([-0.8,-0.4,0.4,0.8],inf),
		\out,OJKOS.synthOutBus
	),

	'glitchFills' -> Pseq([
		ClickRest(130,6).pattern,
		Pbind(
			\instrument,\lfNoise,
			\dur,Prand([1,Pseq([0.125],8)],inf) * 60/130,
			\type,Pseq([\grain,\rest],inf),
			\freq, Pexprand(10,1000,inf),
			\combFreq,Prand([80,86],inf).midicps / Prand([1,4,8,2],inf),
			\dcy,Prand([0.5,1,0.1],inf) * Prand([1,-1],inf),
			\atk,0.001,
			\sus,Prand([0.25,0.5,0.75],inf) * Pkey(\dur) - 0.002,
			\rls,0.001,
			\gain,Pwhite(1,15,inf),
			\pan,Pseq([[-1,1]],inf),
			\amp, 0.015,
			\out,OJKOS.synthOutBus
		),
	],inf),

	'endSine' -> Pseq([
		ClickRest(130,1,4 * 15 + 3).pattern,
		Pmono(
			\glitchSine,
			\dur,Pseq([1]),
			\freq,[86.midicps,1100],
			\gain,4,
			\rls,0.001,
			\curve,10,
			\amp,0.02,
			\pan, Pseq([[-0.25,0.25]],inf),
			\out,OJKOS.synthOutBus
		)
	]),

	'caseEnd' -> Pseq([
		ClickRest(130,1,4 * 15 + 3).pattern,
		Pmono(
			\lfNoise,
			\dur,0.001,
			\freq, Pseg([100,2000,200,10],[0.75,19.25,8],[0,3.neg,3.neg]),
			\combFreq,Pseg([20,80,40].midicps,[0.75,32.25]),
			\dcy,Pseg([0.3,0.3,0.1,0.05].neg,[10,10,13],4.neg),
			\atk,0.001,
			\sus,33,
			\rls,0.1,
			\gain,10,
			\pan,Pseq([[-1,1]],inf),
			\amp, 0.03,
			\out,OJKOS.synthOutBus
		)
	]),

	/*=============   try   ==============*/

	/*=============   push   ==============*/

	'pushA' -> Pseq([
		ClickRest(150,7).pattern,
		Pbind(
			\instrument, \pushSines,
			\dur,Pseq([2]) * 60/150,
			\freqs,Pdict(chords,'dSus',inf).midicps,
			\amps,[0.1!4],
			\sRate,Pexprand(2000,3500),
			\gain,3,
			\atk,0.01,
			\rls,Pkey(\dur) * 3,
			\curve,1.neg,
			\amp,0.03,
			\out,OJKOS.synthOutBus
		),
		Pbind(
			\instrument, \pushSines,
			\dur,Pseq([1,1,1,0.5,0.5,1,1,1,1,1,1,1,1,1,1,2],4) * 60/150,
			\freqs,Pdict(chords,Pseq('cMaj'!15 ++ 'dSus',inf),inf).midicps,
			\amps,[0.1!4],
			\sRate,Pexprand(2000,3500),
			\gain,3,
			\atk,0.01,
			\rls,Pkey(\dur) * 3,
			\curve,1.neg,
			\amp,0.03,
			\out,OJKOS.synthOutBus
		)
	]),

	'pushF' -> Pseq([
		ClickRest(150,23).pattern,
		Pbind(
			\instrument, \pushSines,
			\dur,Pseq([2]) * 60/150,
			\freqs,Pdict(chords,'dSus',inf).midicps,
			\amps,[0.1!4],
			\sRate,Pexprand(2000,3500),
			\gain,3,
			\atk,0.01,
			\rls,Pkey(\dur) * 3,
			\curve,1.neg,
			\amp,0.03,
			\out,OJKOS.synthOutBus
		)
	]),

	'pushG' -> Pseq([
		ClickRest(150,1).pattern,
		Pbind(
			\instrument, \pushSines,
			\dur,Pseq([1,1,1,0.5,0.5,1,1,1,1,1,1,1,1,1,1,2],4) * 60/150,
			\freqs,Pdict(chords,Pseq('cMaj'!15 ++ 'dSus',inf),inf).midicps,
			\amps,[0.1!4],
			\sRate,Pexprand(2000,3500),
			\gain,3,
			\atk,0.01,
			\rls,Pkey(\dur) * 3,
			\curve,1.neg,
			\amp,0.03,
			\out,OJKOS.synthOutBus
		)
	]),

	'pushH' -> Pseq([
		ClickRest(150,1).pattern,
		Pbind(
			\instrument, \pushSines,
			\dur,Pseq([1,1,1,0.5,0.5,1,1,1,1,1,1,1,1,1,1,2],3) * 60/150,
			\freqs,Pdict(chords,Pseq('cMaj'!15 ++ 'dSus',inf),inf).midicps,
			\amps,[0.1!4],
			\sRate,Pexprand(2000,3500),
			\gain,3,
			\atk,0.01,
			\rls,Pkey(\dur) * 3,
			\curve,1.neg,
			\amp,0.03,
			\out,OJKOS.synthOutBus
		),
		Pbind(
			\instrument, \pushSines,
			\dur,Pseq([1,1,1,0.5,0.5,1,1,1,1,1,1,1,1,1,1,2],1) * 60/150,
			\freqs,Pdict(chords,Pseq('cMaj'!15 ++ 'bSus',inf),inf).midicps,
			\amps,[0.1!4],
			\sRate,Pexprand(2000,3500),
			\gain,3,
			\atk,0.01,
			\rls,Pkey(\dur) * 3,
			\curve,1.neg,
			\amp,0.03,
			\out,OJKOS.synthOutBus
		)
	]),

	'pushI' -> Pseq([
		ClickRest(125,1).pattern,
		Pbind(
			\instrument, \pushSines,
			\dur,Pseq([1,1,1,0.5,0.5,1,1,1,1,1,1,1,1,1,1,2].dup.flat,inf) * 60/125,
			\freqs,Pdict(chords,Pseq('aMaj'!15 ++ 'bSus' ++ ('aMaj'!15),1),inf).midicps,
			\amps,[0.1!4],
			\sRate,Pexprand(2000,3500),
			\gain,3,
			\atk,0.01,
			\rls,Pkey(\dur) * 3,
			\curve,1.neg,
			\amp,0.03,
			// \out,OJKOS.synthOutBus
		),
		Pbind(
			\instrument, \pushSines,
			\dur,60/125 + (60/150),
			\freqs,Pdict(chords,'dSus',1).midicps,
			\amps,[0.1!4],
			\sRate,Pexprand(2000,3500),
			\gain,3,
			\atk,0.01,
			\rls,Pkey(\dur) * 3,
			\curve,1.neg,
			\amp,0.03,
			// \out,OJKOS.synthOutBus
		),
		Pbind(
			\instrument, \pushSines,
			\dur,Pseq([1,1,1,0.5,0.5,1,1,1,1,1,1,1,1,1,1],1) * 60/150,
			\freqs,Pdict(chords,'cMaj',inf).midicps,
			\amps,[0.1!4],
			\sRate,Pexprand(2000,3500),
			\gain,3,
			\atk,0.01,
			\rls,Pkey(\dur) * 3,
			\curve,1.neg,
			\amp,0.03,
			// \out,OJKOS.synthOutBus
		),
		Pbind(
			\instrument, \pushSines,
			\dur,60/150 + (60/169),
			\freqs,Pdict(chords,'eSus',1).midicps,
			\amps,[0.1!4],
			\sRate,Pexprand(2000,3500),
			\gain,3,
			\atk,0.01,
			\rls,Pkey(\dur) * 3,
			\curve,1.neg,
			\amp,0.03,
			// \out,OJKOS.synthOutBus
		),
		Pbind(
			\instrument, \pushSines,
			\dur,Pseq([1,1,1,0.5,0.5,1,1,1,1,1,1,1,1,1,1,2],1) * 60/169,
			\freqs,Pdict(chords,Pseq('dMaj'!15 ++ 'dQFS'),inf).midicps,
			\amps,[0.1!4],
			\sRate,Pexprand(2000,3500),
			\gain,3,
			\atk,0.01,
			\rls,Pkey(\dur) * 3,
			\curve,1.neg,
			\amp,0.03,
			\out,OJKOS.synthOutBus
		)
	]),

	'pushJ' -> Pseq([
		ClickRest(135,1).pattern,
		Pbind(
			\instrument, \pushSines,
			\dur,Pseq([1,1,1,0.5,0.5,1,1,1],1) * 60/135,
			\freqs,Pdict(chords,'cQFl',inf).midicps,
			\amps,[0.1!4],
			\sRate,Pexprand(2000,3500),
			\gain,3,
			\atk,0.01,
			\rls,Pkey(\dur) * 2,
			\curve,1.neg,
			\amp,0.03,
			\out,OJKOS.synthOutBus
		),
		Pbind(
			\instrument, \pushSines,
			\dur,Pseq(1!7 ++ 2 ++ [1,1,1,0.5,0.5] ++ (1!10) ++ 2 ++ [1,1,1,0.5,0.5] ++ (1!10),1) * 60/155,
			\freqs,Pdict(chords,Pseq('cMaj'!7 ++ 'dSus' ++ ('cMaj'!15) ++ 'dSus' ++ ('cMaj'!15)),inf).midicps,
			\amps,[0.1!4],
			\sRate,Pexprand(2000,3500),
			\gain,3,
			\atk,0.01,
			\rls,Pkey(\dur) * 3,
			\curve,1.neg,
			\amp,0.03,
			\out,OJKOS.synthOutBus
		),
		Pbind(
			\instrument, \pushSines,
			\dur,60/155 + (60/120),
			\freqs,Pdict(chords,'bBSus',1).midicps,
			\amps,[0.1!4],
			\sRate,Pexprand(2000,3500),
			\gain,3,
			\atk,0.01,
			\rls,Pkey(\dur) * 3,
			\curve,1.neg,
			\amp,0.03,
			\out,OJKOS.synthOutBus
		),
		Pbind(
			\instrument, \pushSines,
			\dur,Pseq([1,1,1,0.5,0.5,1,1,1,1,1,1,1,1,1,1,2],inf) * 60/120,
			\freqs,Pdict(chords,Pseq('abMaj'!15 ++ 'bBSus' ++ ('abMaj'!15) ++ 'cSus',1),inf).midicps,
			\amps,[0.1!4],
			\sRate,Pexprand(2000,3500),
			\gain,3,
			\atk,0.01,
			\rls,Pkey(\dur) * 2,
			\curve,1.neg,
			\amp,0.03,
			\out,OJKOS.synthOutBus
		)
	]),

	'pushK' -> Pseq([
		ClickRest(135,1).pattern,
		Pbind(
			\instrument, \pushSines,
			\dur,Pseq([1,1,1,0.5,0.5,1,1,1,1,1,1,1,1,1,1],1) * 60/135,
			\freqs,Pdict(chords,'bBMaj',inf).midicps,
			\amps,[0.1!4],
			\sRate,Pexprand(2000,3500),
			\gain,3,
			\atk,0.01,
			\rls,Pkey(\dur) * 2.5,
			\curve,1.neg,
			\amp,0.03,
			\out,OJKOS.synthOutBus
		),
		Pbind(
			\instrument, \pushSines,
			\dur,60/135 + (60/100),
			\freqs,Pdict(chords,'abSus',1).midicps,
			\amps,[0.1!4],
			\sRate,Pexprand(2000,3500),
			\gain,3,
			\atk,0.01,
			\rls,Pkey(\dur) * 2.5,
			\curve,1.neg,
			\amp,0.03,
			\out,OJKOS.synthOutBus
		),
		Pbind(
			\instrument, \pushSines,
			\dur,Pseq([1,1,1,0.5,0.5,1,1,1],1) * 60/100,
			\freqs,Pdict(chords,'gbMaj',inf).midicps,
			\amps,[0.1!4],
			\sRate,Pexprand(2000,3500),
			\gain,3,
			\atk,0.01,
			\rls,Pkey(\dur) * 2,
			\curve,1.neg,
			\amp,0.03,
			\out,OJKOS.synthOutBus
		),
		Pbind(
			\instrument, \pushSines,
			\dur,Pseq(1!7,1) * 60/115,
			\freqs,Pdict(chords,'gQFl',inf).midicps,
			\amps,[0.1!4],
			\sRate,Pexprand(2000,3500),
			\gain,3,
			\atk,0.01,
			\rls,Pkey(\dur) * 2,
			\curve,1.neg,
			\amp,0.03,
			\out,OJKOS.synthOutBus
		),
		Pbind(
			\instrument, \pushSines,
			\dur,60/115 + (60/135),
			\freqs,Pdict(chords,'aSus',1).midicps,
			\amps,[0.1!4],
			\sRate,Pexprand(2000,3500),
			\gain,3,
			\atk,0.01,
			\rls,Pkey(\dur) * 2.5,
			\curve,1.neg,
			\amp,0.03,
			\out,OJKOS.synthOutBus
		),
		Pbind(
			\instrument, \pushSines,
			\dur,60/135,
			\freqs,Pdict(chords,'gMaj',31).midicps,
			\amps,[0.1!4],
			\sRate,Pexprand(2000,3500),
			\gain,3,
			\atk,0.01,
			\rls,Pkey(\dur) * 3,
			\curve,1.neg,
			\amp,0.03,
			\out,OJKOS.synthOutBus
		)
	]),

	'pushL' -> Pbind(
		\instrument, \pushSines,
		\dur,1 * 60/135,
		\freqs,Pdict(chords,'gMaj',inf).midicps,
		\amps,[0.1!4],
		\sRate,Pexprand(2000,3500),
		\gain,3,
		\atk,0.01,
		\rls,Pkey(\dur) * 2.5,
		\curve,1.neg,
		\amp,Pseg([1,0.001],[32] * 60/135,\lin) * 0.03,
		\out,OJKOS.synthOutBus
	),

	'fredPop' -> Pseq([
		ClickRest(135,4,15).pattern,
		ClickRest(90,2).pattern,
		Pbind(
			\instrument, \stereoPlayback,
			\bufnum,OJKOS.pbTracks['pop'],
			\amp,0.1,
			\out,OJKOS.synthOutBus,
		)
	]),

	/*=============   pop   ==============*/


	/*=============   if   ===============*/


	'ifEKnut' -> Pseq([
		ClickRest(120,4).pattern,
		Pbind(
			\type, \set,
			\id, Pfunc({ Ndef(\ringerKnut).nodeID }),
			\args,#[\modFreq,\amp],
			\dur,Pseq([1],11) * 60/120,
			\modFreq,Pwhite(200, 3000),
			\amp,Pseq([1,0],inf) * 0.2,
			\out, OJKOS.fxOutBus,
		),
		Pbind(
			\type, \set,
			\id, Pfunc({ Ndef(\ringerKnut).nodeID }),
			\args,#[\modFreq,\amp],
			\dur,Pseq([1,0.5,0.5],1) * 60/120,
			\modFreq,Pwhite(200, 3000),
			\amp,Pseq([0,1,1],inf) * 0.2,
			\out, OJKOS.fxOutBus,
		),
		Pbind(
			\type, \set,
			\id, Pfunc({ Ndef(\ringerKnut).nodeID }),
			\args,#[\modFreq,\amp],
			\dur,Pseq([1],5) * 60/120,
			\modFreq,Pwhite(200, 3000),
			\amp,Pseq([0,1],inf) * 0.2,
			\out, OJKOS.fxOutBus,
		),
		Pbind(
			\type, \set,
			\id, Pfunc({ Ndef(\ringerKnut).nodeID }),
			\args,#[\modFreq,\amp],
			\dur,Pseq([0.5],2) * 60/120,
			\modFreq,Pwhite(200, 3000),
			\amp,0.2,
			\out, OJKOS.fxOutBus,
		),
		Pbind(
			\type, \set,
			\id, Pfunc({ Ndef(\ringerKnut).nodeID }),
			\args,#[\modFreq,\amp],
			\dur,Pseq([60/120, 60/90, 60/120]),
			\modFreq,Pwhite(200, 3000),
			\amp,Pseq([0,1],inf) * 0.2,
			\out, OJKOS.fxOutBus,
		),
		Pbind(                     // mm. 156
			\type, \set,
			\id, Pfunc({ Ndef(\ringerKnut).nodeID }),
			\args,#[\modFreq,\amp],
			\dur,Pseq([0.25],4) * 60/120,
			\modFreq,Pwhite(200, 3000),
			\amp,0.2,
			\out, OJKOS.fxOutBus,
		),
		Pbind(
			\type, \set,
			\id, Pfunc({ Ndef(\ringerKnut).nodeID }),
			\args,#[\modFreq,\amp],
			\dur,Pseq(1!6 ++ (2/3!4) ++ (1!5),1) * 60/120,
			\modFreq,Pwhite(200, 3000),
			\amp,Pseq([0,1],inf) * 0.2,
			\out, OJKOS.fxOutBus,
		),
		Pbind(
			\type, \set,
			\id, Pfunc({ Ndef(\ringerKnut).nodeID }),
			\args,#[\modFreq,\amp],
			\dur,Pseq([1/3],3) * 60/120,
			\modFreq,Pwhite(200, 3000),
			\amp,0.2,
			\out, OJKOS.fxOutBus,
		),
		Pbind(
			\type, \set,
			\id, Pfunc({ Ndef(\ringerKnut).nodeID }),
			\args,#[\modFreq,\amp],
			\dur,Pseq([1],3) * 60/120,
			\modFreq,Pwhite(200, 3000),
			\amp,Pseq([0,1],inf) * 0.2,
			\out, OJKOS.fxOutBus,
		),
		Pbind(
			\type, \set,
			\id, Pfunc({ Ndef(\ringerKnut).nodeID }),
			\args,#[\modFreq,\amp],
			\dur,Pseq([0.25,0.25,0.5],1) * 60/70,
			\modFreq,Pwhite(200, 3000),
			\amp,0.2,
			\out, OJKOS.fxOutBus,
		),
		Pbind(                                   // mm. 177
			\type, \set,
			\id, Pfunc({ Ndef(\ringerKnut).nodeID }),
			\args,#[\modFreq,\amp],
			\dur,Pseq([1],6) * 60/120,
			\modFreq,Pwhite(200, 3000),
			\amp,Pseq([0,1],inf) * 0.2,
			\out, OJKOS.fxOutBus,
		),
		Pbind(
			\type, \set,
			\id, Pfunc({ Ndef(\ringerKnut).nodeID }),
			\args,#[\modFreq,\amp],
			\dur,Pseq([60/150,60/150,60/210,60/150],1),
			\modFreq,Pwhite(200, 3000),
			\amp,Pseq([0,1],inf) * 0.2,
			\out, OJKOS.fxOutBus,
		),
		Pbind(
			\type, \set,
			\id, Pfunc({ Ndef(\ringerKnut).nodeID }),
			\args,#[\modFreq,\amp],
			\dur,Pseq([1],12) * 60/120,
			\modFreq,Pwhite(200, 3000),
			\amp,Pseq([0,1],inf) * 0.2,
			\out, OJKOS.fxOutBus,
		),
		Pbind(
			\type, \set,
			\id, Pfunc({ Ndef(\ringerKnut).nodeID }),
			\args,#[\modFreq,\amp],
			\dur,Pseq([60/70],1),
			\modFreq,Pwhite(200, 3000),
			\amp,0,
			\out, OJKOS.fxOutBus,
		),
	]),

	'ifEHenriette' -> Pseq([
		ClickRest(120,4).pattern,
		Pbind(
			\type, \set,
			\id, Pfunc({ Ndef(\ringerHenriette).nodeID }),
			\args,#[\modFreq,\amp],
			\dur,Pseq([1],11) * 60/120,
			\modFreq,Pwhite(200, 3000),
			\amp,Pseq([0,1],inf) * 0.2,
			\out, OJKOS.fxOutBus,
		),
		Pbind(
			\type, \set,
			\id, Pfunc({ Ndef(\ringerHenriette).nodeID }),
			\args,#[\modFreq,\amp],
			\dur,Pseq([0.5,0.5,1],1) * 60/120,
			\modFreq,Pwhite(200, 3000),
			\amp,Pseq([1,1,0],inf) * 0.2,
			\out, OJKOS.fxOutBus,
		),
		Pbind(
			\type, \set,
			\id, Pfunc({ Ndef(\ringerHenriette).nodeID }),
			\args,#[\modFreq,\amp],
			\dur,Pseq([1],7) * 60/120,
			\modFreq,Pwhite(200, 3000),
			\amp,Pseq([1,0],inf) * 0.2,
			\out, OJKOS.fxOutBus,
		),
		Pbind(
			\type, \set,
			\id, Pfunc({ Ndef(\ringerHenriette).nodeID }),
			\args,#[\modFreq,\amp],
			\dur,Pseq([60/90],1),
			\modFreq,Pwhite(200, 3000),
			\amp,0,
			\out, OJKOS.fxOutBus,
		),
		Pbind(                     // mm. 155
			\type, \set,
			\id, Pfunc({ Ndef(\ringerHenriette).nodeID }),
			\args,#[\modFreq,\amp],
			\dur,Pseq([1],8) * 60/120,
			\modFreq,Pwhite(200, 3000),
			\amp,Pseq([1,0],inf) * 0.2,
			\out,OJKOS.fxOutBus,
		),
		Pbind(
			\type, \set,
			\id, Pfunc({ Ndef(\ringerHenriette).nodeID }),
			\args,#[\modFreq,\amp],
			\dur,Pseq((2/3!4) ++ (1!9),1) * 60/120,
			\modFreq,Pwhite(200, 3000),
			\amp,Pseq([1,0],inf) * 0.2,
			\out, OJKOS.fxOutBus,
		),
		Pbind(
			\type, \set,
			\id, Pfunc({ Ndef(\ringerHenriette).nodeID }),
			\args,#[\modFreq,\amp],
			\dur,Pseq([1],1) * 60/70,
			\modFreq,Pwhite(200, 3000),
			\amp,0,
			\out, OJKOS.fxOutBus,
		),
		Pbind(                                 // mm. 177
			\type, \set,
			\id, Pfunc({ Ndef(\ringerHenriette).nodeID }),
			\args,#[\modFreq,\amp],
			\dur,Pseq([1],6) * 60/120,
			\modFreq,Pwhite(200, 3000),
			\amp,Pseq([1,0],inf) * 0.2,
			\out, OJKOS.fxOutBus,
		),
		Pbind(
			\type, \set,
			\id, Pfunc({ Ndef(\ringerHenriette).nodeID }),
			\args,#[\modFreq,\amp],
			\dur,Pseq([60/150,60/150,60/210,60/150],1),
			\modFreq,Pwhite(200, 3000),
			\amp,Pseq([1,0],inf) * 0.2,
			\out, OJKOS.fxOutBus,
		),
		Pbind(
			\type, \set,
			\id, Pfunc({ Ndef(\ringerHenriette).nodeID }),
			\args,#[\modFreq,\amp],
			\dur,Pseq([1],12) * 60/120,
			\modFreq,Pwhite(200, 3000),
			\amp,Pseq([1,0],inf) * 0.2,
			\out, OJKOS.fxOutBus,
		),
		Pbind(
			\type, \set,
			\id, Pfunc({ Ndef(\ringerHenriette).nodeID }),
			\args,#[\modFreq,\amp],
			\dur,Pseq([60/70],1),
			\modFreq,Pwhite(200, 3000),
			\amp,0.2,
			\out, OJKOS.fxOutBus,
		),
	]),

	'ifFKnut' -> Pseq([
		Pbind(
			\type, \set,
			\id, Pfunc({ Ndef(\ringerKnut).nodeID }),
			\args,#[\modFreq,\amp],
			\dur,Pseq([0.5,0.5,2/9,2/9,5/9],1) * 60/100,
			\legato,1,
			\modFreq,Pwhite(200, 3000),
			\amp,0.2,
			\out, OJKOS.fxOutBus,
		),
		Pbind(
			\type, \set,
			\id, Pfunc({ Ndef(\ringerKnut).nodeID }),
			\args,#[\modFreq,\amp],
			\dur,Pseq([1],12) * 60/120,
			\legato,1,
			\modFreq,Pwhite(200, 3000),
			\amp,Pseq([0,1],inf) * 0.2,
			\out, OJKOS.fxOutBus,
		),
		Pbind(
			\type, \set,
			\id, Pfunc({ Ndef(\ringerKnut).nodeID }),
			\args,#[\modFreq,\amp],
			\dur,Pseq([1],5) * 60/100,
			\legato,1,
			\modFreq,Pwhite(200, 3000),
			\amp,Pseq([0,1],inf) * 0.2,
			\out, OJKOS.fxOutBus,
		)
	]),

	'ifFHenriette' -> Pseq([
		Pbind(
			\type, \set,
			\id, Pfunc({ Ndef(\ringerHenriette).nodeID }),
			\args,#[\modFreq,\amp],
			\dur,Pseq([1],2) * 60/100,
			\legato,1,
			\modFreq,Pwhite(200, 3000),
			\amp,0,
			\out, OJKOS.fxOutBus,
		),
		Pbind(
			\type, \set,
			\id, Pfunc({ Ndef(\ringerHenriette).nodeID }),
			\args,#[\modFreq,\amp],
			\dur,Pseq([1],12) * 60/120,
			\legato,1,
			\modFreq,Pwhite(200, 3000),
			\amp,Pseq([1,0],inf) * 0.2,
			\out, OJKOS.fxOutBus,
		),
		Pbind(
			\type, \set,
			\id, Pfunc({ Ndef(\ringerHenriette).nodeID }),
			\args,#[\modFreq,\amp],
			\dur,Pseq([1],5) * 60/100,
			\legato,1,
			\modFreq,Pwhite(200, 3000),
			\amp,Pseq([1,0],inf) * 0.2,
			\out, OJKOS.fxOutBus,
		)
	]),

	'ifGKnut' -> Pbind(
		\type, \set,
		\id, Pfunc({ Ndef(\ringerKnut).nodeID }),
		\args,#[\modFreq,\amp],
		\dur,Pseq([1],1) * 60/80,
		\legato,1,
		\modFreq,Pwhite(200, 3000),
		\amp,0.2,
		\out, OJKOS.fxOutBus,
	),

	'ifGHenriette' -> Pbind(
		\type, \set,
		\id, Pfunc({ Ndef(\ringerHenriette).nodeID }),
		\args,#[\modFreq,\amp],
		\dur,60/80,
		\legato,1,
		\modFreq,Pwhite(200, 3000),
		\amp,Pseq([0,1],1) * 0.2,
		\out, OJKOS.fxOutBus,
	),



	/*=============   else   ==============*/

	/*=============   outro   ==============*/

	'outro' -> Pbind(
		\instrument,\outro,
		\dur,Pwhite(0.1,2),
		\degree,Prand ((0..7),inf) * Prand([0.5,1],inf),
		\atk,0.01,
		\rls,Pwhite(0.4,0.8),
		\gain,1,
		\amp,0.1,
		\pan,Pwhite(-0.8,0.8)
	),
]