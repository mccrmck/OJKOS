//////////// == CONTROL STRUCTURES: PATTERNS == ////////////


IdentityDictionary[                    // these could also be functions??? so I can pass args into Pbind keys???!?!??!

	/*=============   intro   ==============*/

	'tune' -> Pbind(
		\instrument,\tune,
		\dur,Pseq([Pwhite(2,3.0,3),Pwhite(3.8,5.25,1)],inf),
		\freq, Pseq([[0.25,0.5,1,2]],inf) * Pseq([2,3,3,2],inf) * 46.midicps,
		\gain,Pwhite(1.0,1.4),
		\atk,Pwhite(3.0,4.0),
		\rls,Pwhite(4.0,5.0),
		\pan,Pfunc({ var rand = 0.8.rand2;  [0,0,rand,rand.neg] }),
		\amp,0.2
	),

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
	),

	'tranceKick' -> Pbind(
		\instrument,\bdSynth,
		\dur,60/142,
		\freq,29.midicps, //24 == C, 29 == F
		\trans,6,
		\rq,0.05,
		\gain,4,
		\atk,0.01,
		\rls,0.08,
		\curve,14,
		\amp,0.1,
	),


	/*=============   case   ==============*/


	/*=============   try   ==============*/

	/*=============   push   ==============*/

	/*=============   pop   ==============*/

	/*=============   if   ===============*/

	/*=============   else   ==============*/

	/*=============   outro   ==============*/


]