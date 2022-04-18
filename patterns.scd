//////////// == CONTROL STRUCTURES: PATTERNS == ////////////

var ins = OJKOS.inBus;
var chords = Dictionary[
	\gb  -> ([42,46,53,56]!15).addFirst([44,51,53,58]),
	\gqb -> ([42.5,46.5,53.5,56.5]!9 ++ ([43,47,54,57]!7)).addFirst([44.5,51.5,53.5,58.5]),
	\g   -> ([43,47,54,57]!15).addFirst([45,52,54,59]),
	\ab  -> ([44,48,55,58]!15).addFirst([46,53,55,60]),
	\a   -> ([45,49,56,59]!15).addFirst([47,54,56,61]),
	\bb  -> ([46,50,57,60]!15).addFirst([48,55,57,62]),
	\cqb -> ([47.5,51.5,58.5,61.5]!9 ++ ([48,52,59,62]!7)).addFirst([49.5,56.5,58.5,63.5]),
	\c   -> ([48,52,59,62]!15).addFirst([50,57,59,64]),
	\d   -> ([50,54,61,64]!15).addFirst([52,59,61,66]),
];

IdentityDictionary[                    // these could also be functions??? so I can pass args into Pbind keys???!?!??!

	/*=============   intro   ==============*/

	'tuneLoop' -> Pseq([
		ClickRest(50,4).pattern,
		Pwhile({ ~tune },
			Pbind(     /// must fix this!!
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

	'breakFred' -> Pbind(
		\instrument,\grainPerc,
		\dur,30/142,
		\type,\grain,
		\bufnum,~fred,     // obviously change this!!!
		\rate,1,
		// \pos,Pwhite(0.2,0.8,inf),
		\pos,Pseq(([0.25,0.4,0.5]!2 ++ [0.25,0.5]).flat,inf), // descending fminor triad
		// \gain,Pseg([1,40],[40],\exp,inf),
		\gain,80, //play with this to go from kermit the frog to formant synth to drive!!
		\atk,0.01,
		\rls,0.2,
		\curve,5.neg,
		\pan,0,
		\amp,0.3,
		\out,OJKOS.synthOutBus
	),

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
		\inBus,[ ins['henriette'],ins['camilla'],ins['maria'],ins['sigrid'],ins['richard'],ins['lyder'],ins['tancred'],ins['andreas'],ins['magnus'],ins['johannes'] ],
		\bufnum,OJKOS.tranceBuf,
	),

	'tranceGate' -> Pmono(\tranceGate,
		\dur,Prand([0.5,Pseq([0.25],2)],32) * 60/142,
		\bufnum,OJKOS.tranceBuf,
		\gCurve,5.neg,
		\gAtk,0.249 * 60/142,
		\gRls,0.001 * 60/142,
		\trig,1,
		\amp,0.4,
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
			\amp,Pseq([[1,0.03]],inf) * 0.1;
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
			\amp,Pseq([[1,0.03]],inf) * 0.1;
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
			\amp,Pseq([[0.8,0.03]],inf) * 0.1;
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
			\amp,Pseq([[1,0.03]],inf) * 0.1;
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
				\amp,Pseq([[1,0.03]],inf) * 0.1;
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

	'breakSine' -> Pseq([
		ClickRest(96,4*16).pattern,
		Pbind(
			\instrument,\glitchSine,
			\dur,Pseq([4] ++ (0.25!32),1) * 60/130,
			\type,Pseq([\note,Pwrand([\note,\rest],[0.85,0.15],32)],inf),
			\freq,Pseq([2] ++ (1!32),inf) * Pseq([[86.midicps,1100]],inf),
			\gain,4,
			\rls,Pseq([0.4] ++ (0.001!32),inf),
			\curve,10,
			\amp,Pseq([0.03] ++ (0.05!32),inf),
			\pan, Pseq([[-0.25,0.25]],inf),
			\out,OJKOS.synthOutBus
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



	/*=============   try   ==============*/

	/*=============   push   ==============*/

	'pushA' -> Pseq([
		ClickRest(150,7).pattern,
		Pbind(
			\instrument, \pushSines,
			\dur,Pseq([2,1,1,1,0.5,0.5,1,1,1,1,1,1,1,1,1,1],inf) * 60/150,
			\freqs,Pdict(chords,'c',16 * 4 + 1).midicps,
			\amps,[0.1!4],
			\gain,1,
			\atk,0.05,
			\rls,2,
			\curve,6.neg,
			\amp,0.05,
			\out,OJKOS.synthOutBus
		)
	]),

	// keys are where the pattern starts, but the mostly live in the following rehearsal mark
	// I think the durations will be fucked because of the tempo changes - must fix later!
	'pushF' -> Pseq([
		ClickRest(150,23).pattern,
		Pbind(
			\instrument, \pushSines,
			\dur,Pseq([2,1,1,1,0.5,0.5,1,1,1,1,1,1,1,1,1,1],4) * 60/150,
			\freqs,Pdict(chords,'c',inf).midicps,
			\amps,[0.1!4],
			\gain,1,
			\atk,0.05,
			\rls,2,
			\curve,6.neg,
			\amp,0.05,
			\out,OJKOS.synthOutBus
		)
	]),

	'pushG' -> Pseq([
		ClickRest(150,4 * 15 + 3).pattern,
		Pbind(
			\instrument, \pushSines,
			\dur,Pseq([2,1,1,1,0.5,0.5,1,1,1,1,1,1,1,1,1,1],4) * 60/150,
			\freqs,Pdict(chords,'c',inf).midicps,
			\amps,[0.1!4],
			\gain,1,
			\atk,0.05,
			\rls,2,
			\curve,6.neg,
			\amp,0.05,
			\out,OJKOS.synthOutBus
		)
	]),

	'pushH' -> Pseq([
		ClickRest(150,4 * 15 + 3).pattern,
		Pbind(
			\instrument, \pushSines,
			\dur,Pseq([2,1,1,1,0.5,0.5,1,1,1,1,1,1,1,1,1,1],2) * 60/125,
			\freqs,Pdict(chords,'a',inf).midicps,
			\amps,[0.1!4],
			\gain,1,
			\atk,0.05,
			\rls,2,
			\curve,6.neg,
			\amp,0.05,
			\out,OJKOS.synthOutBus
		),
		Pbind(
			\instrument, \pushSines,
			\dur,Pseq([2,1,1,1,0.5,0.5,1,1,1,1,1,1,1,1,1,1],1) * 60/150,
			\freqs,Pdict(chords,'c',inf).midicps,
			\amps,[0.1!4],
			\gain,1,
			\atk,0.05,
			\rls,2,
			\curve,6.neg,
			\amp,0.05,
			\out,OJKOS.synthOutBus
		),
		Pbind(
			\instrument, \pushSines,
			\dur,Pseq([2,1,1,1,0.5,0.5,1,1,1,1,1,1,1,1,1,1],1) * 60/169,
			\freqs,Pdict(chords,'d',inf).midicps,
			\amps,[0.1!4],
			\gain,1,
			\atk,0.05,
			\rls,2,
			\curve,6.neg,
			\amp,0.05,
			\out,OJKOS.synthOutBus
		),

	]),

	'pushI' -> Pseq([
		ClickRest(125,4 * 8).pattern,
		ClickRest(150,4 * 4).pattern,
		ClickRest(169,4 * 3 + 3).pattern,
		Pbind(
			\instrument, \pushSines,
			\dur,Pseq([2,1,1,1,0.5,0.5,1,1,1,1,1,1,1,1,1,1],1) * Pseq(60/135!9 ++ (60/155!7),inf),
			\freqs,Pdict(chords,'cqb',inf).midicps,
			\amps,[0.1!4],
			\gain,1,
			\atk,0.05,
			\rls,2,
			\curve,6.neg,
			\amp,0.05,
			\out,OJKOS.synthOutBus
		),
		Pbind(
			\instrument, \pushSines,
			\dur,Pseq([2,1,1,1,0.5,0.5,1,1,1,1,1,1,1,1,1,1],1) * 60/155,
			\freqs,Pdict(chords,'c',inf).midicps,
			\amps,[0.1!4],
			\gain,1,
			\atk,0.05,
			\rls,2,
			\curve,6.neg,
			\amp,0.05,
			\out,OJKOS.synthOutBus
		),
		Pbind(
			\instrument, \pushSines,
			\dur,Pseq([2,1,1,1,0.5,0.5,1,1,1,1,1,1,1,1,1,1],2) * 60/120,
			\freqs,Pdict(chords,'ab',inf).midicps,
			\amps,[0.1!4],
			\gain,1,
			\atk,0.05,
			\rls,2,
			\curve,6.neg,
			\amp,0.05,
			\out,OJKOS.synthOutBus
		)
	]),

	'pushJ' -> Pseq([
		ClickRest(135,4 * 2).pattern,
		ClickRest(155,4 * 10).pattern,
		ClickRest(120,4 * 7 + 3).pattern,
		Pbind(
			\instrument, \pushSines,
			\dur,Pseq([2,1,1,1,0.5,0.5,1,1,1,1,1,1,1,1,1,1],1) * 60/135,
			\freqs,Pdict(chords,'bb',inf).midicps,
			\amps,[0.1!4],
			\gain,1,
			\atk,0.05,
			\rls,2,
			\curve,6.neg,
			\amp,0.05,
			\out,OJKOS.synthOutBus
		),
		Pbind(
			\instrument, \pushSines,
			\dur,Pseq([2,1,1,1,0.5,0.5,1,1,1,1,1,1,1,1,1,1],1) * Pseq(60/100!9 ++ (60/115!7),inf),
			\freqs,Pdict(chords,'gb',inf).midicps,
			\amps,[0.1!4],
			\gain,1,
			\atk,0.05,
			\rls,2,
			\curve,6.neg,
			\amp,0.05,
			\out,OJKOS.synthOutBus
		),
		Pbind(
			\instrument, \pushSines,
			\dur,Pseq([2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],1) * 60/135,
			\freqs,Pdict(chords,'g',inf).midicps,
			\amps,[0.1!4],
			\gain,1,
			\atk,0.05,
			\rls,2,
			\curve,6.neg,
			\amp,0.05,
			\out,OJKOS.synthOutBus
		),
		Pbind(
			\instrument, \pushSines,
			\dur,Pseq([1],16) * 60/135,
			\freqs,chords['g'][1].midicps,
			\amps,[0.1!4],
			\gain,1,
			\atk,0.05,
			\rls,2,
			\curve,6.neg,
			\amp,0.05,
			\out,OJKOS.synthOutBus
		),
	]),

	// we "skip" K because L can start on a downbeat

	'pushL' -> Pbind(
		\instrument, \pushSines,
		\dur,Pseq([1],16) * 60/135,
		\freqs,chords['g'][1].midicps,
		\amps,[0.1!4],
		\gain,1,
		\atk,0.05,
		\rls,2,
		\curve,6.neg,
		\amp,Pseg([1,0.0001],16 * 60/135,\exp,1) * 0.05,
		\out,OJKOS.synthOutBus
	),

	/*=============   pop   ==============*/

	/*=============   if   ===============*/

	/*=============   else   ==============*/

	/*=============   outro   ==============*/

]