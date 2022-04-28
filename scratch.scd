
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




(
Ndef(\elseSolo,{
	var bufnum = \bufnum.kr();
	var frames = BufFrames.kr(bufnum);
	var pos = Phasor.ar(0,BufRateScale.kr(bufnum) * \rate.kr(1),\start.kr(0) * frames,\end.kr(1) * frames);
	var sig = BufRd.ar(2,bufnum,pos);

	sig = BPF.ar(sig,\fFreq.kr(500),\rq.kr(1));

	sig = (sig * \gain.kr(1)).tanh;
	sig = Balance2.ar(sig[0],sig[1],\pan.kr(0),\amp.kr(0.5));

}).play
)