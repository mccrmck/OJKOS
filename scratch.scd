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


x = Synth(\resNoisePerc,[\atk,0.01,\rls,0.8,\curve,5.neg,\freq,3400,\dcy,0.3,\pNoiz,0.1,\sineFreq,3000,\sineMix,0.2,\amp,0.5,\gain,4])

x = 2.collect({|i| Synth(\resNoiseASR,[\atk,10,\freqs,[200,250].at(i),\amps,0.6,\rTimes,0.6,\pNoiz,0.01,\amp,0.7])})
x.do({|i,index| i.set(\freqs,[200,190].at(index),\amps,0.6,\rTimes,1,\pNoiz,0.01,\amp,0.8)})
x.set(\freqs,[200,190],\amp,0.3)
x.do(_.set(\rls,10,\gate,0))

x.set(\freq,1200,\gain,4,\amp,0.01)
x.set(\gate,0)

x = 4.collect({|i| Synth(\resNoiseASR,[\atk,10,\freq,[62.5,66.5,71,80].midicps.at(i),\sineFreq,[62.5,66.5,71,80].midicps.at(i),\sineMix,0.1,\dcy,0.6,\pNoiz,0.01,\amp,0.2])})




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


x = Synth(\pluck,[\dcy,2.neg,\freq,400.exprand(800),\coef,0.5.rrand(0.9),\fFreq,3000,\fGain,0.1,\gain,3,\amp,0.5])
x.set(\dcy,4.neg,\coef,0.7,\fFreq,2400,\fGain,0.1,\gain,3,\amp,0.5)


SynthDef(\pluck,{
	var sig = SoundIn.ar(0); // later, In.ar() ?
	var freq = \freq.kr(400);

	sig = Pluck.ar(Hasher.ar(Sweep.ar(1)),1,0.2,freq.reciprocal,\dcy.kr(1),\coef.kr(0.5).clip2(0.999));
	sig = MoogFF.ar(sig,\fFreq.kr(800),\fGain.kr(0));
	sig = (sig * \gain.kr(1)).tanh;
	sig = LeakDC.ar(sig,0.9);
	DetectSilence.ar(sig,doneAction: 2);
	sig = Pan2.ar(sig,\pan.kr(0),\amp.kr(0.5));
	OffsetOut.ar(\out.kr(0),sig)
}).add;

(
// smacks
Pdef(\test,
	Pbind(
		\instrument, \pluck,
		\dur,Pwhite(0.2,0.4,inf) * 60/96,
		\freq,Pwhite(400,800),
		\dcy,4.neg,
		\coef,0.7,
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


// riser?
(
SynthDef(\riser,{
	var freq = \freq.kr(450);
	var sig = VarSaw.ar(freq ,{1.0.rand}!4,width: \width.kr(0.5)).sum;
	sig = sig * PinkNoise.ar(1);
	sig = (sig * \gain.kr(1)).tanh;
	sig = HPF.ar(sig,freq * 0.6);
	sig = RLPF.ar(sig,freq * 2,\rq.kr(1));
	sig = sig * Env.asr(\atk.kr(0.01),1,\rls.kr(0.1),\curve.kr(0)).kr(2,\gate.kr(1));
	sig = LeakDC.ar(sig);
	sig = Splay.ar(sig,\pan.kr(0),\amp.kr(0.5));
	Out.ar(\out.kr(0),sig);
}).add;
)

(
Pmono(\riser,
	\dur,0.05,
	\freq,Pseg([0.5,1] * 66.midicps,[10],\exp),
	\width,Pseg([0.5,0.1],[10],\exp),
	\rq,Pseg([0.5,1],[10],\exp),
	\amp,Pseg([0.05,0.5],[10],\exp),
	\gain,2,
	\rls,0.001,
).play
)


