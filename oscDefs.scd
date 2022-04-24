//////////// == CONTROL STRUCTURES: OSCDEFS == ////////////
{ |lemurAddr|

	lemurAddr.postln;

	/*=============   intro   ==============*/

	/*=============   begin   ==============*/

	// create "presets" I can skip to - improvise for a bit, then skip to a sound....can possibly also be .xset
	// every preset gets marked with an impact - tranceBD? Also happened when I lowered \hpFreq to the same freq as the VarSaw (40hZ)
	// as things go on and on, the changes happen more and more often
	// find one of these presets to end on, this will also bring us to another section, presumably with the ensemble
	// must be able to side chain the output with kick drum
	// should the whole thing be highshelfed a bit? Maybe remove some of the harshness? Needs to be checked on a PA...
	// maybe this should be a hybrid approach, with patterns (\type, \set) controlling pitch, width, etc. and busses controlling the stuff I want to play...
	// or I could add some LFOs??



	// OSCdef(\emptySet,{  |msg, time,addr, recvPort|
	/*Ndef(\emptySet,{
	var varT = \lagTime.kr(0);
	var varC = \lagCurve.kr(0);
	var sig, freq = \freq.kr(28.midicps).varlag(varT,varC);
	var harms = (1..4);
	var mid = VarSaw.ar(freq * harms,harms.reciprocal.reverse,\width.kr(0.5).varlag(varT,varC),harms.reciprocal).sum;
	var side = PinkNoise.ar(1,\offset.kr(0).varlag(varT,varC)).clip2;
	mid = (mid * \midGain.kr(1).varlag(varT,varC)).tanh;

	side = LeakDC.ar( HPF.ar( HPF.ar(side,90),90) ) ;
	side = (side * \sideGain.kr(1).varlag(varT,varC)).fold2;

	sig = MS2Stereo.ar([mid * \midAmp.kr(1).varlag(varT,varC),side * \sideAmp.kr(0.8).varlag(varT,varC)]);
	sig = (sig * \gain.kr(1).varlag(varT,varC));

	sig = RHPF.ar(sig,\hpFreq.kr(80).varlag(varT,varC),\hpQ.kr(1).varlag(varT,varC));
	sig = RLPF.ar(sig,\lpFreq.kr(8000).varlag(varT,varC),\lpQ.kr(1).varlag(varT,varC));

	sig = MidEQ.ar(sig,500,1,6);
	sig = sig.tanh;
	sig = Compander.ar(sig,In.ar(\sChain.kr(),1),\thresh.kr(0.5),1,\ratio.kr().reciprocal,\cAtk.kr(0.01),\cRls.kr(0.1)); // must test this!!
	sig = Balance2.ar(sig[0],sig[1],\pan.kr(0),\amp.kr(0.5));
	}).play;*/
	// });

	// Ndef(\emptySet).set(\lagTime,2,\lagCurve,4)
	// Ndef(\emptySet).set(\freq,28.midicps,\lpFreq,2000,\lpQ,0.5,\hpFreq,40,\hpQ,1,\midGain,0.02,\sideGain,4,\offset,0.9,\gain,8,\width,0.02,\amp,0.5)
	// Ndef(\emptySet).clear




	/*=============   break   ==============*/

	/*=============   case   ==============*/


	/*

	(  // for before letter A
	var freq = 400.exprand(800);
	Synth(\pluck,[\freq,freq,\dcy,4.neg,\coef,0.75.rrand(0.92),\fFreq,freq * 4,\fGain,1,\gain,8,\amp,0.05.rrand(0.2),\pan,0.5.rand2,\out,OJKOS.synthOutBus])
	)
	*/

	/*=============   try   ==============*/

	/*=============   push   ==============*/

	/*=============   pop   ==============*/

	/*
	Ndef(\test,{
	var sig = SoundIn.ar(OJKOS.inBus['henriette']);
	sig = (sig * \gain.kr(1)).clip2;
	// sig = (sig * \gain.kr(1)).tanh;
	sig = Compander.ar(sig,sig,0.5,1.0,0.01,0.1,4);

	Pan2.ar(sig,\pan.kr(0),\amp.kr(0.5))
	}).play(out:OJKOS.fxOutBus);



	Ndef(\popNoise,{
	var sig = BrownNoise.ar(1);
	sig = BPF.ar(sig,\fFreq.kr(440),\rq.kr(1));
	sig = (sig *\gain.kr(10)).clip2;
	sig = Pan2.ar(sig,\pan.kr(0),\amp.kr(0.3));
	}).set(\amp,0).play


	Ndef(\popNoise).set(\gain,200,\fFreq,500,\rq,0.8,\amp,0.1)
	*/

	/*=============   if   ===============*/



	// these need one fader that can .set \modFreq and also maybe volume control? And .filter some delay or some shit on this as well maybe...
	/*(

	Ndef(\ringerKnut,{
	var sig = SoundIn.ar(\inBus.kr(0));
	var mod = SinOsc.ar(\modFreq.kr(100));

	sig = Compander.ar(sig,sig,0.1,5,1); // gate ... add threshold

	sig = sig * mod;
	sig = LeakDC.ar(sig);
	sig = Pan2.ar(sig,\pan.kr(0),\amp.kr(0,0.01));

	}).play;

	Ndef(\ringerHenriette,{
	var sig = SoundIn.ar(\inBus.kr(0));
	var mod = SinOsc.ar(\modFreq.kr(100));

	sig = Compander.ar(sig,sig,0.1,5,1); // gate ... add threshold

	sig = sig * mod;
	sig = LeakDC.ar(sig);
	sig = Pan2.ar(sig,\pan.kr(0),\amp.kr(0,0.01));

	}).play;

	)*/


	/*=============   else   ==============*/

	/*=============   outro   ==============*/

}