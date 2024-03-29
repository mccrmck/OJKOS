//////////// == CONTROL STRUCTURES: SYNTHDEFS == ////////////

(
SynthDef(\recorderMono,{
	var sig = SoundIn.ar(\inBus.kr());
	sig = HPF.ar(sig,\fFreq.kr(150));
	sig = Compander.ar(sig,sig,0.5,1,1/4,0.01,0.1,4);
	RecordBuf.ar(sig,\bufnum.kr(),loop:0,doneAction: 2)
}).add;

SynthDef(\recorderStereo,{
	var sig = SoundIn.ar(\inBus.kr(0!2));
	sig = HPF.ar(sig,\fFreq.kr(150));
	sig = Compander.ar(sig,sig,0.5,1,1/4,0.01,0.1,4);
	RecordBuf.ar(sig,\bufnum.kr(),loop:0,doneAction: 2)
}).add;

SynthDef(\recorderTrance,{
	var sig = SoundIn.ar(\inBus.kr(0!10));
	sig = sig.sum;
	sig = HPF.ar(sig,\fFreq.kr(150));
	sig = Compander.ar(sig,sig,0.5,1,1/4,0.01,0.1,4);
	RecordBuf.ar(sig,\bufnum.kr(),loop:0,doneAction: 2)
}).add;

SynthDef(\monoPlayback,{
	var bufnum = \bufnum.kr();
	var sig = PlayBuf.ar(1,bufnum,BufRateScale.kr(bufnum),doneAction: 2);
	sig = Pan2.ar(sig,\pan.kr(0),\amp.kr(1));
	OffsetOut.ar(\out.kr(0),sig);
}).add;

SynthDef(\stereoPlayback,{
	var bufnum = \bufnum.kr();
	var sig = PlayBuf.ar(2,bufnum,BufRateScale.kr(bufnum),doneAction: 2);
	sig = Balance2.ar(sig[0],sig[1],\pan.kr(0),\amp.kr(1));
	OffsetOut.ar(\out.kr(0),sig);
}).add;

/*=============   intro   ==============*/

SynthDef(\tune,{
	var freq = \freq.kr(440);
	var sig = SinOsc.ar(freq);
	sig = (sig * \gain.kr(1)).tanh;
	sig = RLPF.ar(sig,freq * 6, 0.9);
	sig = sig * Env([0,1,0],[\atk.kr(0.01),\rls.kr(0.1)],\curve.kr(-4)).kr(2);
	sig = Pan2.ar(sig,\pan.kr(0),\amp.kr(0.5));
	Out.ar(\out.kr(0),sig)
}).add;

/*=============   break   ==============*/

SynthDef(\grainPerc,{
	var bufnum = \bufnum.kr();
	var sig = PlayBuf.ar(1,bufnum,BufRateScale.kr(bufnum) * \rate.kr(1),1,\pos.kr(0) * BufFrames.kr(bufnum), \loop.kr(0));
	sig = (sig * \gain.kr(1)).clip2;
	sig = sig * Env.perc(\atk.kr(0.01),\rls.kr(0.1),1,\curve.kr(-4)).kr(2);
	sig = Pan2.ar(sig,\pan.kr(0),\amp.kr(1));
	OffsetOut.ar(\out.kr(0),sig)
}).add;

SynthDef(\bdSynth,{
	var freq = \freq.kr(440);
	var atk = \atk.kr(0.01);
	var freqSweep = freq * XLine.kr(4,1,\sweep.kr(0.04)).lag;
	var sig = SinOsc.ar(freqSweep) * \gain.kr(1);
	sig = RLPF.ar(sig,freqSweep * 2,\rq.kr(1));
	sig = sig.tanh;
	sig = Compander.ar(sig,sig,0.5,1,1/3,atk,0.1,3);
	sig = sig * Env.perc(atk,\rls.kr(0.1),1,\curve.kr(-4)).kr(2);
	Out.ar(\sendBus.ar,sig * \sendAmp.kr(0));
	sig = Pan2.ar(sig,\pan.kr(0),\amp.kr(0.5));
	Out.ar(\out.ar,sig);
}).add;

SynthDef(\tranceGate,{
	var bufnum = \bufnum.kr();
	var sig = PlayBuf.ar(1,bufnum,BufRateScale.kr(bufnum),loop: 1);
	sig = (sig * \gain.kr(1)).tanh;
	sig = sig * Env([1,0,1],[\gAtk.kr(0.1),\gRls.kr(0.001)],\gCurve.kr(1)).ar(gate:\trig.tr);
	sig = sig * Env.asr(\atk.kr(0),1,\rls.kr(0.01),\curve.kr(-4)).kr(2,\gate.kr(1));
	sig = Pan2.ar(sig,\pan.kr(0),\amp.kr(1));
	OffsetOut.ar(\out.kr(0),sig)
}).add;

/*=============   case   ==============*/

SynthDef(\pluck,{
	var freq = \freq.kr(400);
	var sig = Pluck.ar(Hasher.ar(Sweep.ar(1)),1,0.2,freq.reciprocal,\dcy.kr(1),\coef.kr(0.5).clip2(0.999));
	sig = MoogFF.ar(sig,\fFreq.kr(800),\fGain.kr(0));
	sig = (sig * \gain.kr(1)).tanh;
	sig = LeakDC.ar(sig,0.9);
	DetectSilence.ar(sig,doneAction: 2);
	sig = Pan2.ar(sig,\pan.kr(0),\amp.kr(0.5));
	OffsetOut.ar(\out.kr(0),sig)
}).add;

SynthDef(\glitchSine,{
	var freq = \freq.kr(440);
	var sig	= SinOsc.ar(0, (Sweep.ar(1, 2pi * freq) + (pi/3)).wrap(-pi, pi));
	sig = (sig * \gain.kr(1)).tanh;
	sig = sig * Env.cutoff(\rls.kr(0.1),1,\curve.kr(0)).kr(2,\gate.kr(1));
	sig = Pan2.ar(sig,\pan.kr(0),\amp.kr(1));
	OffsetOut.ar(\out.kr(0),sig);
}).add;

SynthDef(\resNoiseASR,{
	var sig = PinkNoise.ar(\pNoiz.kr(0.01));
	sig = HPF.ar(sig,\hpFreq.kr(100));
	sig = LPF.ar(sig,\lpFreq.kr(3000));
	sig = Ringz.ar(sig,\freq.kr(440),\dcy.kr(0.5)) + SinOsc.ar(\sineFreq.kr(440),mul: \sineMix.kr(0.1));
	sig = (sig * \gain.kr(1)).tanh;
	sig = sig * Env.asr(\atk.kr(0.01),1,\rls.kr(0.1),\curve.kr(-4)).kr(2,\gate.kr(1));
	sig = Pan2.ar(sig,\pan.kr(0),\amp.kr(1));
	Out.ar(\out.kr(0),sig);
}).add;

SynthDef(\klik,{
	var sig = PinkNoise.ar(1!2).sum;
	sig = BPF.ar(sig,\fFreq.kr(5000),\rq.kr(0.1),\gain.kr(20));
	sig = sig.fold2;
	sig = sig * Env.perc(\atk.kr(0.01),\rls.kr(0.1),1,\curve.kr(-4)).kr(2);
	sig = Pan2.ar(sig,\pan.kr(0),\amp.kr(1));
	OffsetOut.ar(\out.kr(0),sig);
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

SynthDef(\noiseFilt,{
	var sig = WhiteNoise.ar();
	sig = RHPF.ar(sig,\hpFreq.kr(80),\hpQ.kr(1));
	sig = RLPF.ar(sig,\lpFreq.kr(8000),\lpQ.kr(1));
	sig = (sig + \offset.kr(0) * \gain.kr(1)).clip2;
	sig = sig * Env.asr(\atk.kr(0.01),1,\rls.kr(0.1),\curve.kr(-4)).kr(2,\gate.kr(1));
	sig = LeakDC.ar(sig);
	sig = Pan2.ar(sig,\pan.kr(0),\amp.kr(1));
	OffsetOut.ar(\out.kr(0),sig);
}).add;

SynthDef(\lfNoise,{
	var sig = LFNoise0.ar(\freq.kr(440));
	sig = CombC.ar(sig,0.2,\combFreq.kr(40).reciprocal,\dcy.kr(0.2));
	sig = (sig + \offset.kr(0) * \gain.kr(1)).fold2;
	sig = sig * Env.linen(\atk.kr(0.01),\sus.kr(0.1),\rls.kr(0.1),1,\curve.kr(0)).kr(2);
	sig = LeakDC.ar(sig);
	sig = Pan2.ar(sig,\pan.kr(0),\amp.kr(1));
	Out.ar(\out.kr(0),sig);
}).add;

/*=============   try   ==============*/

SynthDef(\tryBass,{
	var freq = \freq.kr(110);
	var sig = SinOsc.ar(freq * [1,1.5,2],mul: [1,0.5,0.5]);
	sig = sig.sum.tanh;
	sig = HPF.ar(sig,freq);
	sig = Compander.ar(sig,sig,0.5,1,1/4,0.01,1.0,4);
	sig = sig + HPF.ar(WhiteNoise.ar(0.8),freq / 4);
	sig = RLPF.ar(sig,\fFreq.kr(500) * LFNoise1.ar(0.5).range(0.9,1.1),\rq.kr(1));
	sig = (sig * \gain.kr(1)).tanh;
	sig = Compander.ar(sig,sig,0.5,1,1/3,0.01,1.0,3);
	sig = sig * Env.perc(\atk.kr(0.01),1,\rls.kr(0.6),\curve.kr(-4)).kr(2);
	sig = Pan2.ar(sig,\pan.kr(0),\amp.kr(0.5));
	Out.ar(\out.kr(0),sig);
}).add;

SynthDef(\tryResNoise,{
	var varT = \lagTime.kr(2);
	var varC = \lagCurve.kr(4);
	var sig = PinkNoise.ar(\pNoiz.kr(0.01));
	sig = HPF.ar(sig,\hpFreq.kr(250));
	sig = LPF.ar(sig,\lpFreq.kr(4000));
	sig = Ringz.ar(sig,\freq.kr(440).varlag(varT,varC),\dcy.kr(0.5)) + SinOsc.ar(\sineFreq.kr(440).varlag(varT,varC),mul: \sineMix.kr(0.1));
	sig = (sig * \gain.kr(1)).tanh;
	sig = Compander.ar(sig,sig,0.5,1,1/3,0.01,0.1,3);
	sig = sig * Env.asr(\atk.kr(0.01),1,\rls.kr(0.1),\curve.kr(-4)).kr(2,\gate.kr(1));
	sig = Pan2.ar(sig,\pan.kr(0).varlag(varT,varC),\amp.kr(1));
	Out.ar(\out.kr(0),sig);
}).add;

// processing for knut?

/*=============   push   ==============*/

SynthDef(\pushSines,{
	var freqs = \freqs.kr(440!4);
	var sig	= Klang.ar(`[freqs,\amps.kr(0.1!4)]);
	sig = HPF.ar(sig,freqs[0] * 1.5);
	sig = Latch.ar(sig,Impulse.ar(\sRate.kr(1000)));
	sig = RLPF.ar(sig,freqs[0] * 4,0.6);
	sig = MidEQ.ar(sig,freqs[0] * 3,0.5,-4);
	sig = (sig * \gain.kr(1)).tanh;
	sig = Compander.ar(sig,sig,0.5,1,1/4,0.01,0.1,4);
	sig = sig * Env.perc(\atk.kr(0.01),\rls.kr(0.1),1,\curve.kr(0)).kr(2);
	sig = Pan2.ar(sig,\pan.kr(0),\amp.kr(1));
	OffsetOut.ar(\out.kr(0),sig);
}).add;

/*=============   pop   ==============*/

/*=============   if   ==============*/

SynthDef(\ringSeq,{
	var sig = SoundIn.ar(\inBus.kr(0));
	var mod = SinOsc.ar(\modFreq.kr(100,0.05));
	sig = sig * mod;
	sig = LeakDC.ar(sig);
	sig = sig * Env.asr(\atk.kr(0.001),1,\rls.kr(0.001),\curve.kr(-4)).kr(2,\gate.kr(1));
	sig = Pan2.ar(sig,\pan.kr(0),\amp.kr(0.5));
	Out.ar(\out.kr(0),sig)
}).add;

/*=============   else   ==============*/

/*=============   outro   ==============*/

SynthDef(\outro,{
	var sig = SinOsc.ar(\freq.kr(440));
	sig = (sig * \gain.kr(1)).tanh;
	sig = LPF.ar(sig,2500);
	sig = sig * Env.perc(\atk.kr(0.01),\rls.kr(0.1),1,\curve.kr(-4)).kr(2);
	sig = Pan2.ar(sig,\pan.kr(0),\amp.kr(1));
	Out.ar(\out.kr(0),sig);
}).add;
)