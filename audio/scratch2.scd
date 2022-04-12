



Pbind(
	\instrument,\glitchSine,
	\dur,Pseq([0.25,0.25,0.5,0.75,0.25,0.25,0.25,5.5],inf) * 60/130,
	\type,Pseq(\note!7 ++ [\rest] ,inf),
	\legato,0.5,
	\freq, Pstep([[40, 73],[28,73]],[0.25,3.75] * 60/130,inf).midicps, //560
	\rls,0.001,
	\curve,10,
	\gain,4,
	\amp,Pseq([[1,0.03]],inf) * 0.1;
).play


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
	\type,\grain,
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

b = ClickConCat(2,/*ClickEnv([64,83],4,2),ClickEnv([83,102],4,2),*/ClickEnv([102,91],4,2),ClickEnv([91,80],4,2))
b.duration
b.play

109 * 4/5
102 * 15/16


60/68 * 3/2

60/63