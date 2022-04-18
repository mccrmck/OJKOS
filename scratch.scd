// emptyset intro
(
Ndef(\esNoise,{
	var sig = PinkNoise.ar(1!3);
	sig = BLowShelf.ar(sig,90,1,6);
	sig = MidEQ.ar(sig,800,1,-12);
	sig = (sig * \gain.kr(1)).clip2;
	sig = LeakDC.ar(sig,0.99);
	sig = HPF.ar(sig,200).tanh;
	sig = Splay.ar(sig,1,\amp.kr(1));
}).play;
)

Ndef(\esNoise)[10] = nil

Ndef(\esNoise)[10] = \filter -> {|in|
	var sig = HPF.ar(in,80);
	sig = CombC.ar(sig,0.2,0.2);
	sig = FreeVerb.ar(sig,1,0.9,1);
	sig = BHiShelf.ar(sig,\fFreq.kr(3500),\rs.kr(1),-24);

}

Ndef(\esNoise).set(\wet10,0.5)
Ndef(\esNoise).set(\gain,3,\amp,-16.dbamp)


// create "presets" I can skip to - improvise for a bit, then skip to a sound....can possibly also be .xset
// create global lag argument for all Control Names, so I can xset w/ a snap or with a s
// every preset gets marked with an impact - tranceBD? Also happened when I lowered \hpFreq to the same freq as the VarSaw (40hZ)
// as things go on and on, the changes happen more and more often
// find one of these presets to end on, this will also bring us to another section, presumably with the ensemble
// must be able to side chain the output with kick drum
// should the whole thing be highshelfed a bit? Maybe remove some of the harshness? Needs to be checked on a PA...
// maybe this should be a hybrid approach, with patterns (\type, \set) controlling pitch, width, etc. and busses controlling the stuff I want to play...
// or I could add some LFOs??

(
Ndef(\emptySet,{
	var sig, freq = \freq.kr(40);
	var harms = (1..4);
	var mid = VarSaw.ar(freq * harms,harms.reciprocal.reverse,\width.kr(0.5),harms.reciprocal).sum;
	var side = PinkNoise.ar(1,\offset.kr(0)).clip2;
	mid = (mid * \midGain.kr(1)).tanh;

	side = LeakDC.ar( HPF.ar( HPF.ar(side,90),90) ) ;
	side = (side * \sideGain.kr(1)).fold2;

	sig = MS2Stereo.ar([mid * \midAmp.kr(1),side * \sideAmp.kr(0.8)]);
	sig = (sig * \gain.kr(1));

	sig = RHPF.ar(sig,\hpFreq.kr(80),\hpQ.kr(1));
	sig = RLPF.ar(sig,\lpFreq.kr(8000),\lpQ.kr(1));

	sig = MidEQ.ar(sig,500,1,6);

	sig = sig.tanh;

	sig = Compander.ar(sig,In.ar(\sChain.kr(),1),\thresh.kr(0.5),1,\ratio.kr().reciprocal,\cAtk.kr(0.01),\cRls.kr(0.1)); // must test this!!

	sig = Balance2.ar(sig[0],sig[1],\pan.kr(0),\amp.kr(0.5));

}).play;
)
(1..4).reciprocal.reverse

// 28.midicps == low
Ndef(\emptySet).set(\freq,28.midicps,\lpFreq,8000,\lpQ,0.2,\hpFreq,40,\hpQ,1,\midGain,1,\sideGain,12,\offset,0.9,\gain,2,\width,0.3,\amp,0.2)
Ndef(\emptySet).clear


// granulating fred
~fred = Buffer.read(s,"/Users/mikemccormick/Desktop/controlStructures/fred/break.aiff")

// Ndef bus behavior- can this be used to route clicks to multiple sources w/o duplicating click streams
// a quick test looks like it's sample accurate when expanding a mono signal to 5 channels...

b = Bus.audio(s,1);

a = Click(60,repeats: inf,amp: 0.3,out:b)
c = a.play
c.stop

Ndef(\test,{ In.ar(b) }).reshaping_(\elastic).play;

Ndef(\test).playN([0])
Ndef(\test).playN((0..5))
Ndef(\test).playN([1]) // plays two channels starting at this index dvs. [0,1] -> [1,2]
Ndef(\test).playN([0,2,3]) // wraps and maps 2 channels to 3 dvs. [0,1,0] -> [0,2,3]
Ndef(\test).playN([0,2,3,4]) // wraps and maps 2 channels to 3 dvs. [0,1,0,1] -> [0,2,3,4]

// klik
x = Synth(\klik,[\fFreq,10000,\gain,20,\rq,0.8,\atk,0.001,\rls,0.001,\amp,0.4])
x = Synth(\asrSine,[\freq,8000,\gain,2,\atk,0.001,\rls,0.1,\amp,0.1])

(
Ppar([

	Pbind(
		\instrument,\asrSine,
		\dur,Pseq([25.5,0.5,6],inf) * 60/96,
		\type,Pseq([\rest,\note,\rest],inf),
		\legato,1,
		\freq, Pseq([8000],inf),
		\atk,0.001,
		\rls,0.001,
		\curve,4,
		\gain,2,
		\amp,Pseq([0.02],inf);
	),

	Pbind(
		\instrument,\glitchSine,
		\dur,Pseq([7.5,0.5],inf) * 60/96,
		\type,Pseq([\rest,\note],inf),
		\legato,0.85,
		\freq, Pseq([3000],inf),
		\rls,0.001,
		\curve,10.neg,
		\gain,2,
		\amp,Pseq([0.04],inf);
	),
	Pbind(
		\instrument,\glitchSine,
		\dur,Pseq([7.5,0.5],inf) * 60/96,
		\type,Pseq([\rest,\note],inf),
		\legato,0.85,
		\freq, Pwhite(1000,2000,inf),
		\rls,0.001,
		\curve,10.neg,
		\gain,1,
		\amp,Pseq([0.04],inf);
	),
	Pbind(
		\instrument, \noiseFilt,
		\dur,Pseq([7.5,0.5],inf) * 60/96,
		\type,Pseq([\rest,\note],inf),
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
		\amp,0.03
	),
	Pbind(
		\instrument,\glitchSine,
		\dur,Pseq([0.25,0.5,0.25,0.5,0.5,0.5,0.5,0.25,0.25,0.5],inf) * 60/96,
		\type,Pseq(\note!5 ++ [\rest] ++ (\note!4),inf),
		\legato,Pkey(\dur) * 1.3,
		\freq, Pstep([[100,95],[95,90]],[8,8] * 60/96,inf),
		\rls,0.001,
		\curve,10,
		\gain,4,
		\amp,Pseq([0.05],inf);
	)

]).play
)

x = Synth(\resNoisePerc,[\atk,0.01,\rls,0.8,\curve,5.neg,\freq,3400,\dcy,0.3,\pNoiz,0.1,\sineFreq,3000,\sineMix,0.2,\amp,0.5,\gain,4])

x = 2.collect({|i| Synth(\resNoiseASR,[\atk,10,\freqs,[200,250].at(i),\amps,0.6,\rTimes,0.6,\pNoiz,0.01,\amp,0.7])})
x.do({|i,index| i.set(\freqs,[200,190].at(index),\amps,0.6,\rTimes,1,\pNoiz,0.01,\amp,0.8)})
x.set(\freqs,[200,190],\amp,0.3)
x.do(_.set(\rls,10,\gate,0))

x.set(\freq,1200,\gain,4,\amp,0.01)
x.set(\gate,0)

x = 4.collect({|i| Synth(\resNoiseASR,[\atk,10,\freq,[62.5,66.5,71,80].midicps.at(i),\sineFreq,[62.5,66.5,71,80].midicps.at(i),\sineMix,0.1,\dcy,0.6,\pNoiz,0.01,\amp,0.2])})


(
Pmono(\resNoiseASR,
	\dur,Pseq([10],1),
	\freq,[190,200],
	\gain,10,
	\sineFreq,200  * 4,
	\sineMix,0.05,
	\atk,5,
	\rls,5,
	\amp,0.1,
).play;
)



Pmono(\glitchSine,\dur,Pseq([0.0625],16*8) * 60/96,\freq,1000,\gain,4,\legato,1,\rls,0.001,\amp,0.01).play;

(
Pbind(
	\instrument, \noiseFilt,
	\dur,Pseq([0.25],inf) * 60/130,
	\type,Pwrand([\rest,\note],[0.2,0.8],inf),
	\legato,0.1,
	\hpFreq,1000,
	\hpQ,0.2,
	\lpFreq,Pwhite(2000,3000),
	\lpQ,0.8,
	\atk,0.001,
	\rls,0.1,
	\curve,2.neg,
	\offset,0.3,
	\gain,50,
	\amp,Pstep([0.01,0.1,0.01],[2,0.25,1.75] * 60/130,inf),
).play
)


// some noiz shit!!

(
Ndef(\noiz,{
	var sig = BrownNoise.ar(1!4,\offset.kr(0)).fold2;
	sig = MidEQ.ar(sig,500,2,-12);
	sig = (sig * \gain.kr(1)).clip2;
	sig = LeakDC.ar(sig,0.999);
	sig = Splay.ar(sig,1,\amp.kr(1));
}).play;
)

Ndef(\noiz)[7] = nil

Ndef(\noiz)[7] = \filter -> {|in|
	var sig = CombC.ar(in,0.2,XLine.kr(0.2,0.03,4),);
	sig = LeakDC.ar(sig);
	sig + in
}


Ndef(\noiz)[10] = \filter -> {|in|
	var sig = HPF.ar(in,80);
	sig = FreeVerb.ar(sig,1,0.9,1);
	sig = BHiShelf.ar(sig,\fFreq.kr(3500),\rs.kr(1),-24);

}

Ndef(\noiz).set(\wet10,0.2)
Ndef(\noiz).set(\offset,0,\gain,2,\amp,-12.dbamp) // caps: \offset,1 (because it folds),\gain,20

// ring mod
(
Ndef(\ringer,{
	// var sig = SoundIn.ar(0);
	var sig = SinOsc.ar(1000);
	var mod = SinOsc.ar(\modFreq.kr(100,0.05));

	// consider using hasFreq as gate??
	sig = Compander.ar(sig,sig,0.1,5,1); // gate ... add threshold

	sig = sig * mod;
	sig = LeakDC.ar(sig);
	sig = Pan2.ar(sig,\pan.kr(0),\amp.kr(0.5));

}).play
)

Ndef(\ringer).set(\modFreq,200)


(
Pdef(\test,
	Pbind(
		\type,\set,
		\id, Ndef(\ringer).nodeID,
		\args,#[\modFreq],
		\dur, 0.1,
		\modFreq,Pwhite(40.0,400,4) ++ 4
	)
).play
)

//Push synth
(
Pdef(\test,
	Pbind(
		\instrument, \push,
		\dur,Pseq([2,1,1,1,0.5,0.5,1,1,1,1,1,1,1,1,1,1],inf) * 60/150,
		\dummy, Pstep([50,54],[16,16] * 60/150,inf),
		\freq,(Pseq([[0,7,9,14]]++ [-2,2,9,12].dup(15),inf) + Pkey(\dummy)).midicps,
		\fFreq,5000,
		\rq,0.4,
		\gain,2.5,
		\atk,0.01,
		\rls,1.5,
		\curve,2.neg,
		\amp,-20.dbamp,
	)
).quant_(60/150).play
)


x = Synth(\pluck,[\dcy,2.neg,\freq,400.exprand(800),\coef,0.5.rrand(0.9),\fFreq,3000,\fGain,0.1,\gain,3,\amp,0.5])
x.set(\dcy,4.neg,\coef,0.7,\fFreq,2400,\fGain,0.1,\gain,3,\amp,0.5)

(
//clicks
Pdef(\test,
	Pbind(
		\instrument, \pluck,
		\dur,Prand([1/4,1/8],inf) * 60/96,
		\freq,Pwhite(2000,4000),
		\dcy,4.neg,
		\coef,0.8,
		\fFreq,Pkey(\freq) * 4,
		\fGain,2,
		\gain,4,
		\amp,0.5
	)
).play
)

Pdef(\test).stop


// fft Freeze/comb
Ndef(\freezeComb,{
	var bufnum = \bufnum.kr;
	// var sig = PlayBuf.ar(1,bufnum,BufRateScale.kr(bufnum) * 2,startPos: 0.1 * BufFrames.kr(bufnum));
	var frames = \frames.kr(4096);

	sig = FFT(LocalBuf(frames),sig);
	sig = PV_Freeze(sig,1);
	sig = PV_RectComb(sig,32,1,\width.kr(0.1));
	sig = IFFT(sig);
	sig = HPF.ar(sig,400);

	sig = Pan2.ar(sig,\pan.ar(0),\amp.kr(0.5));

}).play


// more glitch

SynthDef(\comb,{
	var freq = \freq.kr(440);
	var sig = WhiteNoise.ar() + SinOsc.ar(freq/2);
	sig = CombC.ar(sig,0.2,freq.reciprocal,\dcy.kr(4));
	sig = (sig + \offset.kr(0) * \gain.kr(1)).tanh;
	sig = LeakDC.ar(sig);
	sig = sig * Env.asr(\atk.kr(0.01),1,\rls.kr(0.1),\curve.kr(-4)).kr(2,\gate.kr(1));
	sig = Pan2.ar(sig,\pan.kr(0),\amp.kr(1));
	Out.ar(\out.kr(0),sig);
}).add;


(
Pdef(\test,
	Pbind(
		\instrument, \comb,
		\dur,Pseq([0.125,0.125,0.125,0.625],inf),
		\legato,0.5,
		\freq,Pseq([5050,5050/2,5050/4,5050/8],inf),
		\atk,0.01,
		\dcy,0.1,
		\rls,0.01,
		\curve,10,
		\offset,0.1,
		\gain,2,
		\amp,0.2
	)
).play
)

(
Pbind(
	\instrument,\glitchSine,
	\dur,Pseq([0.25,0.5,0.25,0.5,0.5,0.5,0.5,0.25,0.25,0.5],inf) * 60/96,
	\type,Pseq(\note!5 ++ [\rest] ++ (\note!4),inf),
	\legato,Pkey(\dur) * 1.5 ,
	\freq, Pseq([[100,95]],inf),
	\rls,0.001,
	\curve,10.neg,
	\gain,4,
	\amp,Pseq([0.2],inf);
).play
)

.finDur

// outro pling plong

(
Pbind(
	\instrument,\outro,
	\dur,Pwhite(0.1,2),
	\degree,Prand ((0..7),inf) * Prand([0.5,1],inf),
	\atk,0.01,
	\rls,Pwhite(0.4,0.8),
	\gain,1,
	\amp,0.1,
	\pan,Pwhite(-0.8,0.8)
).play
)


(
SynthDef(\lfNoise,{
	var sig = LFNoise0.ar(\freq.kr(440));
	sig = CombC.ar(sig,0.2,\combFreq.kr(40).reciprocal,\dcy.kr(0.2));
	sig = (sig + \offset.kr(0) * \gain.kr(1)).fold2;
	sig = sig * Env.linen(\atk.kr(0.01),\sus.kr(0.1),\rls.kr(0.1),1,\curve.kr(0)).kr(2);
	sig = LeakDC.ar(sig);
	sig = Pan2.ar(sig,\pan.kr(0),\amp.kr(1));
	Out.ar(\out.kr(0),sig);
}).add;
)

Pmono(\lfNoise,\dur,Pseq([0.0625],16*8) * 60/96,\freq,500,\gain,2,\legato,1,\rls,0.001,\amp,0.1).play;

(
Pbind(
	\instrument,\lfNoise,
	\dur,Prand([0.25],inf) * 60/130,
	\type,Prand([\grain],inf),
	\freq, Pexprand(10,1000,inf),
	\combFreq,Prand([82,88],inf).midicps / Prand([1,4,8,2],inf),
	\dcy,Prand([0.5,1,0.1],inf) * Prand([1,-1],inf),
	\atk,0.001,
	\sus,Prand([0.25,0.5,0.75],inf) * Pkey(\dur),
	\rls,0.001,
	\gain,Pwhite(1,15,inf),
	\offset,0,
	\pan,Pseq([[-1,1]],inf),
	\amp, 0.05,
).play
)
