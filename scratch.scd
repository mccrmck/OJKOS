
Ndef(\ringerKnut,{
	var sig = SoundIn.ar(OJKOS.inBus['knutVibes']);
	var mod = SinOsc.ar(\modFreq.kr(1000));

	// sig = Compander.ar(sig,sig,0.1,5,1); // gate ... add threshold

	sig = sig * mod;
	sig = LeakDC.ar(sig);
	sig = Pan2.ar(sig,\pan.kr(0),\amp.kr(0.5,0.01));

}).play;

(
Ndef(\ringerHenriette,{
	// var sig = SoundIn.ar(OJKOS.inBus['knutVibes']);
	var sig = SoundIn.ar(OJKOS.inBus['henriette']);
	var mod = SinOsc.ar(\modFreq.kr(1000));

	// sig = Compander.ar(sig,sig,0.1,5,1); // gate ... add threshold

	sig = sig * mod;
	sig = LeakDC.ar(sig);
	sig = Pan2.ar(sig,\pan.kr(0),\amp.kr(0.5,0.01));

}).play(out:OJKOS.fxOutBus);
)



(
Ndef(\ringTest,{
	var sig = SoundIn.ar(0);
	var mod = SinOsc.ar(\modFreq.kr(1000));

	// sig = Compander.ar(sig,sig,0.1,5,1); // gate ... add threshold

	sig = sig * mod;
	sig = LeakDC.ar(sig);
	sig = Pan2.ar(sig,\pan.kr(0),\amp.kr(0.5,0.01));

}).play;
)

Ndef(\ringTest).fadeTime = 0.01

Ndef(\ringTest).filter(2,{|sig| sig * LFPulse.ar(\amFreq.kr(4)) }).set(\wet2,1)
Ndef(\ringTest).set(\amFreq,20)
Ndef(\ringTest)[2] = nil



// break intro

b = Bus.control(s,1).set(1);
c = Bus.control(s,1).set(0.6);
d = Bus.control(s,1).set(0.2);


(
// Pwhile({OJKOS.break},)
Pbind(
	\instrument,\grainPerc,
	\dur,Pseq([0.5],inf) * 60/133.125,
	\type,Pdup(3,Pseq([\note,\rest],inf)),
	\bufnum,OJKOS.pbTracks['break'],
	\rate,1,
	\pos,Pseq([0.25,0.4,0.5],inf), // descending fminor triad
	\gain,Pfunc({ b.getSynchronous }),
	\atk,0.01,
	\rls,Pfunc({ c.getSynchronous }),
	\curve,5.neg,
	\pan,0,
	\amp,Pfunc({ d.getSynchronous }),
	\out,OJKOS.synthOutBus
).play
)


b.set(80)
c.set(0.2)
d.set(0.1)

a = Bus.control(s,3).setn([0,1,2])

a.subBus(2).get
