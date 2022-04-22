
s
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
e = Pseq([
	Click(120,4).pattern,
	Pbind(
		\instrument,\ringSeq,
		\dur,Pseq([1],11) * 60/120,
		\legato,1,
		// \inBus, Pseq([ ins['knut'],ins['henriette'] ],inf),
		\inBus, Pseq([0],inf),
		\modFreq,Pwhite(400,2000),
		\amp,0.5,
	),
	Pbind(
		\instrument,\ringSeq,
		\dur,Pseq([0.5],4) * 60/120,
		\legato,1,
		// \inBus, Pdup(2,Pseq([ ins['henriette'],ins['knut'] ],1)),
		\inBus, Pseq([0],inf),
		\modFreq,Pwhite(400,2000),
		\amp,0.5,
	),
	Pbind(
		\instrument,\ringSeq,
		\dur,Pseq([1],5) * 60/120,
		\legato,1,
		// \inBus, Pseq([ ins['henriette'],ins['knut'] ],inf),
		\inBus, Pseq([0],inf),
		\modFreq,Pwhite(400,2000),
		\amp,0.5,
	),
	Pbind(
		\instrument,\ringSeq,
		\dur,Pseq([0.5],2) * 60/120,
		\legato,1,
		// \inBus, Pseq([ ins['knut'] ],2),
		\inBus, Pseq([0],inf),
		\modFreq,Pwhite(400,2000),
		\amp,0.5,
	),
	Pbind(
		\instrument,\ringSeq,
		\dur,Pseq([60/120, 60/90, 60/120],1) ,
		\legato,1,
		// \inBus, Pseq([ ins['henriette'],ins['knut'] ],inf),
		\inBus, Pseq([0],inf),
		\modFreq,Pwhite(400,2000),
		\amp,0.5,
	),
	Pbind(
		\instrument,\ringSeq,
		\dur,Pseq([0.25],4) * 60/120,
		\legato,1,
		// \inBus, ins['knut'],
		\inBus, Pseq([0],inf),
		\modFreq,Pwhite(400,2000),
		\amp,0.5,
	),
	Pbind(
		\instrument,\ringSeq,
		\dur,Pseq(1!6 ++ (2/3!4) ++ (1!5),1) * 60/120,
		\legato,1,
		// \inBus, Pseq([ ins['henriette'],ins['knut'] ],inf),
		\inBus, Pseq([0],inf),
		\modFreq,Pwhite(400,2000),
		\amp,0.5,
	),
	Pbind(
		\instrument,\ringSeq,
		\dur,Pseq([1/3],3) * 60/120,
		\legato,1,
		// \inBus, ins['knut'],
		\inBus, Pseq([0],inf),
		\modFreq,Pwhite(400,2000),
		\amp,0.5,
	),
	Pbind(
		\instrument,\ringSeq,
		\dur,Pseq([1],3) * 60/120,
		\legato,1,
		// \inBus, Pseq([ ins['henriette'],ins['knut'] ],inf),
		\inBus, Pseq([0],inf),
		\modFreq,Pwhite(400,2000),
		\amp,0.5,
	),
	Pbind(
		\instrument,\ringSeq,
		\dur,Pseq([0.5,0.25,0.25],1) * 60/70,
		\legato,1,
		// \inBus, ins['knut'],
		\inBus, Pseq([0],inf),
		\modFreq,Pwhite(400,2000),
		\amp,0.5,
	),
	Pbind(
		\instrument,\ringSeq,
		\dur,Pseq([1],6) * 60/120,
		\legato,1,
		// \inBus, Pseq([ ins['henriette'],ins['knut'] ],inf),
		\inBus, Pseq([0],inf),
		\modFreq,Pwhite(400,2000),
		\amp,0.5,
	),
	Pbind(
		\instrument,\ringSeq,
		\dur,Pseq([60/150,60/150,60/210,60/150],1),
		\legato,1,
		// \inBus, Pseq([ ins['henriette'],ins['knut'] ],inf),
		\inBus, Pseq([0],inf),
		\modFreq,Pwhite(400,2000),
		\amp,0.5,
	),
	Pbind(
		\instrument,\ringSeq,
		\dur,Pseq([1],12) * 60/120,
		\legato,1,
		// \inBus, Pseq([ ins['henriette'],ins['knut'] ],inf),
		\inBus, Pseq([0],inf),
		\modFreq,Pwhite(400,2000),
		\amp,0.5,
	),
	Pbind(
		\instrument,\ringSeq,
		\dur,Pseq([60/70],1),
		\legato,1,
		// \inBus, ins['henriette'],
		\inBus, Pseq([0],inf),
		\modFreq,Pwhite(400,2000),
		\amp,0.5,
	),
]).play
)

(
f = Pseq([
	Click(100,4).pattern,
	Pbind(
		\instrument,\ringSeq,
		\dur,Pseq([2/9,2/9,5/9],1) * 60/100,
		\legato,1,
		// \inBus, ins['knut'],
		\inBus, Pseq([0],inf),
		\modFreq,Pwhite(400,2000),
		\amp,0.5,
	),
	Pbind(
		\instrument,\ringSeq,
		\dur,Pseq([1],12) * 60/120,
		\legato,1,
		// \inBus, Pseq([ ins['henriette'],ins['knut'] ],inf),
		\inBus, Pseq([0],inf),
		\modFreq,Pwhite(400,2000),
		\amp,0.5,
	),
	Pbind(
		\instrument,\ringSeq,
		\dur,Pseq([1],5) * 60/100,
		\legato,1,
		// \inBus, Pseq([ ins['henriette'],ins['knut'] ],inf),
		\inBus, Pseq([0],inf),
		\modFreq,Pwhite(400,2000),
		\amp,0.5,
	)
]).play
)


x = Synth(\pluck,[\dcy,2.neg,\freq,400.exprand(800),\coef,0.5.rrand(0.9),\fFreq,3000,\fGain,0.1,\gain,3,\amp,0.5])
x.set(\dcy,4.neg,\coef,0.7,\fFreq,2400,\fGain,0.1,\gain,3,\amp,0.5)


SynthDef(\pluck,{
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
	var bufnum = \bufnum.kr();
	// var sig = PlayBuf.ar(1,bufnum,BufRateScale.kr(bufnum) * 2,startPos: 0.1 * BufFrames.kr(bufnum));
	var frames = \frames.kr(4096);

	sig = HPF.ar(sig,400);
	sig = FFT(LocalBuf(frames),sig);
	sig = PV_Freeze(sig,1);
	sig = PV_RectComb(sig,32,1,\width.kr(0.1));
	sig = IFFT(sig);

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


