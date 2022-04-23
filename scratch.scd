

x = Synth(\resNoisePerc,[\atk,0.01,\rls,0.8,\curve,5.neg,\freq,3400,\dcy,0.3,\pNoiz,0.1,\sineFreq,3000,\sineMix,0.2,\amp,0.5,\gain,4])

x = 2.collect({|i| Synth(\resNoiseASR,[\atk,10,\freqs,[200,250].at(i),\amps,0.6,\rTimes,0.6,\pNoiz,0.01,\amp,0.7])})
x.do({|i,index| i.set(\freqs,[200,190].at(index),\amps,0.6,\rTimes,1,\pNoiz,0.01,\amp,0.8)})
x.set(\freqs,[200,190],\amp,0.3)
x.do(_.set(\rls,10,\gate,0))

x.set(\freq,1200,\gain,4,\amp,0.01)
x.set(\gate,0)

x = 4.collect({|i| Synth(\resNoiseASR,[\atk,10,\freq,[62.5,66.5,71,80].midicps.at(i),\sineFreq,[62.5,66.5,71,80].midicps.at(i),\sineMix,0.1,\dcy,0.6,\pNoiz,0.01,\amp,0.2])})



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

(
SynthDef(\clipper,{
	var sig = SoundIn.ar(\inBus.kr(0));
	sig = BLowShelf.ar(sig,\loShelf.kr(250),1,\dBLo.kr(0));
	sig = BHiShelf.ar(sig,\hiShelf.kr(5000),1,\dBHi.kr(0));
	sig = (sig * \gain.kr(1)).clip2;
	sig = sig * Env.asr(\atk.kr(0.01),1,\rls.kr(0.01),\curve.kr(-4)).kr(2,\gate.kr(1));
	sig = Pan2.ar(sig,\pan.kr(0),\amp.kr(0.2));
	Out.ar(\out.kr(0),sig)
}).add;

SynthDef(\saturator,{
	var sig = SoundIn.ar(\inBus.kr(0));
	sig = BLowShelf.ar(sig,\loShelf.kr(250),1,\dBLo.kr(0));
	sig = BHiShelf.ar(sig,\hiShelf.kr(5000),1,\dBHi.kr(0));
	sig = (sig * \gain.kr(1)).tanh;
	sig = sig * Env.asr(\atk.kr(0.01),1,\rls.kr(0.01),\curve.kr(-4)).kr(2,\gate.kr(1));
	sig = Pan2.ar(sig,\pan.kr(0),\amp.kr(0.2));
	Out.ar(\out.kr(0),sig)
}).add;

SynthDef(\freeze,{
	var sig = SoundIn.ar(\inBus.kr(0));
	var frames = \frames.kr(4096);
	sig = HPF.ar(sig,400);
	sig = FFT(LocalBuf(frames),sig);
	sig = PV_Freeze(sig,1);
	sig = IFFT(sig);
	sig = (sig * \gain.kr(1)).clip2;
	sig = sig * Env.asr(\atk.kr(0.01),1,\rls.kr(0.01),\curve.kr(-4)).kr(2,\gate.kr(1));
	sig = Pan2.ar(sig,\pan.kr(0),\amp.kr(0.2));
	Out.ar(\out.kr(0),sig)
}).add;

SynthDef(\freezeComb,{
	var sig = SoundIn.ar(\inBus.kr(0));
	var frames = \frames.kr(4096);
	sig = HPF.ar(sig,300);
	sig = FFT(LocalBuf(frames),sig);
	sig = PV_Freeze(sig,1);
	sig = PV_RectComb(sig,32,1,\width.kr(0.1));
	sig = IFFT(sig);
	sig = (sig * \gain.kr(1)).clip2;
	sig = sig * Env.asr(\atk.kr(0.01),1,\rls.kr(0.01),\curve.kr(-4)).kr(2,\gate.kr(1));
	sig = Pan2.ar(sig,\pan.kr(0),\amp.kr(0.2));
	Out.ar(\out.kr(0),sig)
}).add;

)

(
Ppar([
	Click(120,4,1,2).pattern,
	Pseq([
		ClickRest(120,4).pattern,
		Pmono(
			\saturator,
			\dur,Pseq([3]) * 60/80,
			\gain,2,
			\loShelf,250,
			\dBLo,6,
			\hiShelf,1200,
			\dBHi,3,
			\amp,0.5,
		)
	])
]).play
)




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


