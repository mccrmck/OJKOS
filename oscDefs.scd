//////////// == CONTROL STRUCTURES: OSCDEFS == ////////////
(
/*== click Pdefs == */

var introPart1 = OJKOS.cueFrom('introA','introB',true,true,false);

var breakPart1 = OJKOS.cueFrom('breakIntro','breakI',true,true,false);

var case = OJKOS.cueFrom('caseA','caseF',true,true,false);

var tryABC  = OJKOS.cueFrom('tryABC','tryABC',true,true,false);
var tryD    = OJKOS.cueFrom('tryD', 'tryD', true, true, false);
var tryE    = OJKOS.cueFrom('tryE', 'tryE', true, true, false);
var tryF    = OJKOS.cueFrom('tryF', 'tryF', true, true, false);
var tryG    = OJKOS.cueFrom('tryG', 'tryG', true, true, false);
var tryH    = OJKOS.cueFrom('tryH', 'tryH', true, true, false);
var tryI    = OJKOS.cueFrom('tryI', 'tryI', true, true, false);
var tryJ    = OJKOS.cueFrom('tryJ', 'tryJ', true, true, false);
var tryLast = OJKOS.cueFrom('tryK', 'tryN', true, true, false);

var pushPart1 = OJKOS.cueFrom('pushA','pushE',true,true,false);
var push2Pop  = OJKOS.cueFrom('pushF','popB',true,true,false);

var popPart2 = OJKOS.cueFrom('popC','popK',true,true,false);

var ifPart1 = OJKOS.cueFrom('ifStart','ifD',true,true,false);
var ifPart2 = OJKOS.cueFrom('ifE','ifG',true,true,false);


var elsePart1 = OJKOS.cueFrom('elseA','elseB',true,true,false);
var elsePart2 = OJKOS.cueFrom('elseC','elseF',true,true,false);

var outro = OJKOS.cueFrom('outro','outro',true,true,false);

var trySlots = Array.fill(11,{0});

/*=============   intro   ==============*/

OSCdef(\test,{ |msg, time,addr, recvPort|

	msg.postln;
},'ojkos/test/x');


OSCdef(\introPart1,{ |msg, time,addr, recvPort|
	var val = msg[1].asInteger;

	case
	{val == 0}{ introPart1.stop }
	{val == 1}{ introPart1.play };
},'ojkos/introClick/x');

OSCdef(\introLoopCue,{ |msg, time,addr, recvPort|
	var val = msg[1].asInteger;

	case
	{val == 0}{ Click.loopCues['introLoop'] = true; "introLoop true".postln }
	{val == 1}{ Click.loopCues['introLoop'] = false; "introLoop false".postln };
},'ojkos/loopCue/x');

OSCdef(\tuneCue,{ |msg, time,addr, recvPort|
	var val = msg[1].asInteger;

	case
	{val == 0}{ Click.loopCues['tuneLoop'] = true; OJKOS.tune = true; "tuneLoop true".postln }
	{val == 1}{ Click.loopCues['tuneLoop'] = false; OJKOS.tune = false; "tuneLoop false".postln };
},'ojkos/tuneCue/x');

OSCdef(\introText,{ |msg, time,addr, recvPort|
	var val = msg[1..].sum.asInteger;

	case
	{val == 1}{
		Synth(\monoPlayback,[\bufnum,OJKOS.pbTracks['fred']['intro0'],\amp,-15.dbamp,\out,OJKOS.synthOutBus]);
	}
	{val == 2}{
		Synth(\monoPlayback,[\bufnum,OJKOS.pbTracks['fred']['intro1'],\amp,-15.dbamp,\out,OJKOS.synthOutBus]);
	}
	{val == 3}{
		Synth(\monoPlayback,[\bufnum,OJKOS.pbTracks['fred']['intro2'],\amp,-15.dbamp,\out,OJKOS.synthOutBus]);
	};
},'ojkos/introText/x');


/*=============   begin   ==============*/

OSCdef(\begin,{  |msg, time,addr, recvPort|
	var val = msg[1].asInteger;

	case
	{val == 0}{ Ndef(\emptySet).clear }
	{val == 1}{
		Routine({

			Synth(\monoPlayback,[\bufnum,OJKOS.pbTracks['fred']['begin'],\amp,-15.dbamp,\out,OJKOS.synthOutBus]);

			OJKOS.pbTracks['fred']['begin'].duration.wait;

			Ndef(\emptySet,{
				var varT = \lagTime.kr(0);
				var varC = \lagCurve.kr(0);
				var sig, freq = \freq.kr(40);
				var harms = (1..4);
				var mid = VarSaw.ar(freq * harms,harms.reciprocal.reverse,\width.kr(0.5).varlag(varT,varC),harms.reciprocal).sum;
				var side = PinkNoise.ar(1,\offset.kr(0).varlag(varT,varC)).clip2;
				mid = (mid * \midGain.kr(0.5).varlag(varT,varC)).tanh;

				side = LeakDC.ar( HPF.ar( HPF.ar(side,90),90) ) ;
				side = (side * \sideGain.kr(4).varlag(varT,varC)).fold2;

				sig = MS2Stereo.ar([mid * \midAmp.kr(1).varlag(varT,varC),side * \sideAmp.kr(1).varlag(varT,varC)]);
				sig = (sig * \gain.kr(4).varlag(varT,varC));

				sig = RHPF.ar(sig,\hpFreq.kr(80).varlag(varT,varC).clip(20,20000),\hpQ.kr(0.1).varlag(varT,varC));
				sig = RLPF.ar(sig,\lpFreq.kr(8000).varlag(varT,varC).clip(20,20000),\lpQ.kr(1).varlag(varT,varC));

				sig = MidEQ.ar(sig,500,1,6);
				sig = sig.tanh;
				sig = Balance2.ar(sig[0],sig[1],\pan.kr(0),\amp.kr(0.25) * -18.dbamp);
			}).play;

		}).play;
	}
},'ojkos/begin/x');

OSCdef(\freqSet,{ |msg, time,addr, recvPort|
	var hpFreq = msg[1].linexp(0,1,40,10000);
	var lpFreq = msg[2].linexp(0,1,40,10000);

	Ndef(\emptySet).set(\hpFreq,hpFreq,\lpFreq,lpFreq)

},'ojkos/beginFreq/x');

OSCdef(\beginSet,{ |msg, time,addr, recvPort|
	var hpQ      = msg[1].linlin(0,1,1.0,0.01);
	var width    = msg[2];
	var offset   = msg[3].lincurve(0,1,0,3,3);
	var gain     = msg[4].lincurve(0,1,1,40,3);
	var amp      = \db.asSpec.map(msg[5]).dbamp;
	var midGain  = msg[6].lincurve(0,1,1,40,3);
	var midAmp   = \db.asSpec.map(msg[7]).dbamp;
	var sideGain = msg[8].lincurve(0,1,1,40,3);
	var sideAmp  = \db.asSpec.map(msg[9]).dbamp;
	var lpQ      = msg[10].linexp(0,1,1.0,0.01);

	Ndef(\emptySet).set(\hpQ,hpQ,\width,width,\offset,offset,\gain,gain,\amp,amp,\midGain,midGain,\midAmp,midAmp,\sideGain,sideGain,\sideAmp,sideAmp,\lpQ,lpQ);

},'ojkos/beginFaders/x');

OSCdef(\lagTime,{ |msg, time,addr, recvPort|
	var val = msg[1].asInteger;

	case
	{val == 0}{ Ndef(\emptySet).set(\lagTime,0) }
	{val == 1}{ Ndef(\emptySet).set(\lagTime,10) }

},'ojkos/lagTime/x');

/*=============   break   ==============*/

OSCdef(\breakStart,{  |msg, time,addr, recvPort|
	var val = msg[1].asInteger;

	case
	{val == 0}{ breakPart1.stop }
	{val == 1}{
		Routine({

			Ndef(\emptySet).clear;
			Synth(\monoPlayback,[\bufnum,OJKOS.pbTracks['fred']['break0'],\amp,-15.dbamp,\out,OJKOS.synthOutBus]);
			Synth(\bdSynth,[\freq,29.midicps,\sweep,0.06,\rq,0.05,\gain,4,\atk,0.001,\rls,0.08,\curve,14,\amp,0.1,\out,OJKOS.synthOutBus]);
			OJKOS.pbTracks['fred']['break0'].duration.wait;
			Synth(\monoPlayback,[\bufnum,OJKOS.pbTracks['fred']['break1'],\amp,-15.dbamp,\out,OJKOS.synthOutBus]);
			Synth(\bdSynth,[\freq,29.midicps,\sweep,0.06,\rq,0.05,\gain,4,\atk,0.001,\rls,0.08,\curve,14,\amp,0.1,\out,OJKOS.synthOutBus]);
			OJKOS.pbTracks['fred']['break1'].duration.wait;
			Synth(\monoPlayback,[\bufnum,OJKOS.pbTracks['fred']['break2'],\amp,-15.dbamp,\out,OJKOS.synthOutBus]);
			Synth(\bdSynth,[\freq,29.midicps,\sweep,0.06,\rq,0.05,\gain,4,\atk,0.001,\rls,0.08,\curve,14,\amp,0.1,\out,OJKOS.synthOutBus]);
			OJKOS.pbTracks['fred']['break2'].duration.wait;
			Synth(\monoPlayback,[\bufnum,OJKOS.pbTracks['fred']['break3'],\amp,-15.dbamp,\out,OJKOS.synthOutBus]);
			1.wait;
			Synth(\bdSynth,[\freq,29.midicps,\sweep,0.06,\rq,0.05,\gain,4,\atk,0.001,\rls,0.08,\curve,14,\amp,0.1,\out,OJKOS.synthOutBus]);
			4.5.wait;
			Synth(\bdSynth,[\freq,29.midicps,\sweep,0.06,\rq,0.05,\gain,4,\atk,0.001,\rls,0.08,\curve,14,\amp,0.1,\out,OJKOS.synthOutBus]);
			14.wait;
			breakPart1.play

		}).play
	}
},'ojkos/beginStart/x');

/*=============   case   ==============*/

OSCdef(\caseTalk,{  |msg, time,addr, recvPort|
	var val = msg[1].asInteger;

	if(val == 1,{

		Synth(\monoPlayback,[\bufnum,OJKOS.pbTracks['fred']['case'],\amp,-15.dbamp,\out,OJKOS.synthOutBus]);
	})
},'ojkos/caseText/x');

OSCdef(\pluck,{ |msg, time,addr, recvPort|
	var val = msg[1].asInteger;

	if(val == 1,{
		var freq = 400.exprand(800);
		Synth(\pluck,[\freq,freq,\dcy,4.neg,\coef,0.75.rrand(0.92),\fFreq,freq * 4,\fGain,1,\gain,8,\amp,0.15.rrand(0.25),\pan,0.5.rand2,\out,OJKOS.synthOutBus]);
	})
},'ojkos/pluck/x');

OSCdef(\caseStart,{ |msg, time,addr, recvPort|
	var val = msg[1].asInteger;

	case
	{val == 0}{ case.stop }
	{val == 1}{ case.play };
},'ojkos/caseStart/x');

OSCdef(\caseDistort,{ |msg, time,addr, recvPort|
	var val = msg[1].asInteger;


	case
	{val == 0}{
		Ndef(\caseFuzz).clear;
	}
	{val == 1}{
		Ndef(\caseFuzz,{
			var henriette = SoundIn.ar(OJKOS.inBus['henriette']) * \henAmp.kr(0);
			var camilla = SoundIn.ar(OJKOS.inBus['camilla']) * \camAmp.kr(0);
			var sol = SoundIn.ar(OJKOS.inBus['maria']) * \marAmp.kr(0);
			var sigrid = SoundIn.ar(OJKOS.inBus['sigrid']) * \sigAmp.kr(0);
			var tina = SoundIn.ar(OJKOS.inBus['tina']) * \tinAmp.kr(0);

			var sig = [henriette,camilla,sol,sigrid,tina].sum;

			sig = Decimator.ar(sig,SampleRate.ir * \sRate.kr(0.5).linexp(0,1,0.005,0.6),24 * \bits.kr(1).linexp(0,1,0.05,0.3));
			sig = (sig * \gain.kr(1)).tanh;
			sig = Pan2.ar(sig,\pan.kr(0),\amp.kr(0.25));

		}).play
	};

},);

OSCdef(\caseControl,{ |msg, time,addr, recvPort|

	Ndef(\caseFuzz).set(\henAmp,msg[0],\camAmp,msg[1],\marAmp,msg[2],\sigAmp,msg[3],\tinAmp,msg[4]);

});

/*=============   try   ==============*/

OSCdef(\tryStart,{  |msg, time,addr, recvPort|
	var val = msg[1].asInteger;

	case
	{val == 0}{ Ndef(\tryNoise).end(12) }
	{val == 1}{

		Routine({
			Ndef(\tryNoise,\resNoiseASR).set(
				\freq,880,
				\pNoiz,0.03,
				\gain,1,
				\sineFreq,440,
				\sineMix,0.05,
				\atk,7,
				\rls,20,
				\curve,3,
				\pan,0,
				\amp,0.01,
			).play(out:OJKOS.synthOutBus);

			14.wait;

			Synth(\monoPlayback,[\bufnum,OJKOS.pbTracks['fred']['try'],\amp,-15.dbamp,\out,OJKOS.synthOutBus]);

		}).play
	}
},'ojkos/tryStart/x');


OSCdef(\tryCues,{ |msg, time,addr, recvPort|
	var val,index;

	msg[1..].do({ |item, i|
		item = item.asInteger;
		if(item != trySlots[i],{
			val = item;
			index = i;
		});
	});

	trySlots[index] = val;

	switch(val,
		0,{
			switch(index,
				0,{tryABC.stop}, // A
				1,{tryABC.stop}, // B
				2,{tryABC.stop}, // C
				3,{tryD.stop},   // D
				4,{tryE.stop},   // E
				5,{tryF.stop},   // F
				6,{tryG.stop},   // G
				7,{tryH.stop},   // H
				8,{tryI.stop},   // I
				9,{tryJ.stop},   // J
				10,{tryLast.stop},  // Last
			)
		},
		1,{
			switch(index,
				0,{tryABC.play; "a".postln}, // A
				1,{tryABC.play; "b".postln}, // B
				2,{tryABC.play; "c".postln}, // C
				3,{tryD.play;   "d".postln},   // D
				4,{tryE.play;   "e".postln},   // E
				5,{tryF.play;   "f".postln},   // F
				6,{tryG.play;   "g".postln},   // G
				7,{tryH.play;   "h".postln},   // H
				8,{tryI.play;   "i".postln},   // I
				9,{tryJ.play;   "j".postln},   // J
				10,{tryLast.play; "last".postln},  // Last
			)
		}
	);

},'ojkos/tryCues/x');

OSCdef(\knutFXAmps,{  |msg, time,addr, recvPort|
	var delay = \db.asSpec.map(msg[1]).dbamp;
	var reps = \db.asSpec.map(msg[2]).dbamp;
	var freeze = \db.asSpec.map(msg[3]).dbamp;

	Ndef(\delayK).set(\amp,delay);
	Ndef(\repsK).set(\amp,delay);
	Ndef(\freezeK).set(\amp,delay);

},'ojkos/knutFX/x');


OSCdef(\knutFX,{  |msg, time,addr, recvPort|
	var delay = msg[1].asInteger;
	var reps = msg[2].asInteger;
	var freeze = msg[3].asInteger;

	if(delay == 1,{
		Ndef(\delayK,{
			var sig = SoundIn.ar(OJKOS.inBus['knutPerc']);
			sig = CombC.ar(sig,0.4,LFNoise1.ar(0.2).range(0.2,0.4),2);
			sig = sig.tanh;
			sig = Pan2.ar(sig,0,\amp.kr(0.5))
		}).play(OJKOS.fxOutBus)
	},{ Ndef(\delayK).clear });

	if(reps == 1,{
		Ndef(\repsK,{
			var sig = SoundIn.ar(OJKOS.inBus['knutPerc']);
			sig = sig * Env.sine().kr;
			sig = CombC.ar(sig,0.3,Rand(0.1,0.3),inf);
			sig = sig.tanh;
			sig = Pan2.ar(sig,0,\amp.kr(0.5))
		}).play(OJKOS.fxOutBus)
	},{ Ndef(\repsK).clear });

	if(freeze == 1,{
		Ndef(\freezeK,{
			var frames = 4096;
			var sig = SoundIn.ar(OJKOS.inBus['knutPerc']);
			sig = FFT(LocalBuf(frames),sig);
			sig = PV_Freeze(sig,1);
			sig = IFFT(sig);
			sig = sig.tanh;
			sig = Pan2.ar(sig,0,\amp.kr(0.5))
		}).play(OJKOS.fxOutBus)
	},{ Ndef(\freezeK).clear });

},'ojkos/knutFX/z');

OSCdef(\richardFXAmps,{  |msg, time,addr, recvPort|
	var delay = \db.asSpec.map(msg[1]).dbamp;
	var reps = \db.asSpec.map(msg[2]).dbamp;
	var freeze = \db.asSpec.map(msg[3]).dbamp;

	Ndef(\delayR).set(\amp,delay);
	Ndef(\repsR).set(\amp,reps);
	Ndef(\repsR).set(\amp,delay);

},'ojkos/richardFX/x');

OSCdef(\richardFX,{  |msg, time,addr, recvPort|
	var delay = msg[1].asInteger;
	var reps = msg[2].asInteger;
	var freeze = msg[3].asInteger;

	if(delay == 1,{
		Ndef(\delayR,{
			var sig = SoundIn.ar(OJKOS.inBus['richard']);
			sig = CombC.ar(sig,0.4,LFNoise1.ar(0.2).range(0.2,0.4),2);
			sig = sig.tanh;
			sig = Pan2.ar(sig,0,\amp.kr(0.5))
		}).play(OJKOS.fxOutBus)
	},{ Ndef(\delayR).clear });

	if(reps == 1,{
		Ndef(\repsR,{
			var sig = SoundIn.ar(OJKOS.inBus['richard']);
			sig = sig * Env.sine().kr;
			sig = CombC.ar(sig,0.3,Rand(0.1,0.3),inf);
			sig = sig.tanh;
			sig = Pan2.ar(sig,0,\amp.kr(0.5))
		}).play(OJKOS.fxOutBus)
	},{ Ndef(\repsR).clear });

	if(freeze == 1,{
		Ndef(\freezeR,{
			var frames = 4096;
			var sig = SoundIn.ar(OJKOS.inBus['richard']);
			sig = FFT(LocalBuf(frames),sig);
			sig = PV_Freeze(sig,1);
			sig = IFFT(sig);
			sig = sig.tanh;
			sig = Pan2.ar(sig,0,\amp.kr(0.5))
		}).play(OJKOS.fxOutBus)
	},{ Ndef(\freezeR).clear });

},'ojkos/richardFX/z');

/*=============   push   ==============*/

OSCdef(\pushStart,{  |msg, time,addr, recvPort|
	var val = msg[1].asInteger;

	case
	{val == 0}{ /*pushPart1.stop*/ }
	{val == 1}{
		Routine({
			Synth(\monoPlayback,[\bufnum,OJKOS.pbTracks['fred']['push0'],\amp,-15.dbamp,\out,OJKOS.synthOutBus]);
			OJKOS.pbTracks['fred']['push0'].duration.wait;
			2.wait;
			Synth(\monoPlayback,[\bufnum,OJKOS.pbTracks['fred']['push1'],\amp,-15.dbamp,\out,OJKOS.synthOutBus]);
			(OJKOS.pbTracks['fred']['push1'].duration - (8 * 60/150)).wait;
			pushPart1.play;

		}).play;
	}

},'ojkos/pushStart/x');

OSCdef(\pushToPop,{ |msg, time,addr, recvPort|
	var val = msg[1].asInteger;

	case
	{val == 0}{ push2Pop.stop }
	{val == 1}{ push2Pop.play };
},'ojkos/pushCue/x');

/*=============   pop   ==============*/


OSCdef(\popPart2,{ |msg, time,addr, recvPort|
	var val = msg[1].asInteger;

	case
	{val == 0}{ popPart2.stop }
	{val == 1}{ popPart2.play };
},'ojkos/popCue/x');

OSCdef(\hendrixAmp,{ |msg, time,addr, recvPort|
	var val = msg[1];

	Ndef(\hendrix).set(\amp,\db.asSpec.map(val).dbamp)
},'ojkos/hendrix/x');

OSCdef(\hendrix,{ |msg, time,addr, recvPort|
	var val = msg[1].asInteger;

	case
	{val == 0}{ Ndef(\hendrix).clear }
	{val == 1}{
		Ndef(\hendrix,{
			var sig = SoundIn.ar(OJKOS.inBus['henriette']);
			sig = Decimator.ar(sig,SampleRate.ir * \sRate.kr(0.5).linexp(0,1,0.005,0.6),24 * \bits.kr(1).linexp(0,1,0.05,0.3));
			sig = Compander.ar(sig,sig,0.5,1,1/2,0.01,0.1,2);
			sig = Limiter.ar(sig);
			sig = (sig * \gain.kr(1)).tanh;
			Pan2.ar(sig,\pan.kr(0),\amp.kr(1) * 0.5);
		}).play(out:OJKOS.fxOutBus)
	};
},'ojkos/hendrix/z');

OSCdef(\hendrixYx,{ |msg, time,addr, recvPort|
	var val = msg[1];

	Ndef(\hendrix).set(\sRate,val)
},'ojkos/hendrixY/x');

OSCdef(\hendrixYy,{ |msg, time,addr, recvPort|
	var val = msg[1];

	Ndef(\hendrix).set(\bits,val)
},'ojkos/hendrixY/y');

//

OSCdef(\doomNoiseX,{ |msg, time,addr, recvPort|
	var amp = \db.asSpec.map(msg[1]).dbamp;
	var rq = msg[2].linlin(0,1,1,0.01);


	Ndef(\doomNoise).set(\amp,amp,\rq,rq)
},'ojkos/doomNoise/x');

OSCdef(\doomNoiseY,{ |msg, time,addr, recvPort|
	var gain = msg[1].linexp(0,1,1,80);
	var freq = msg[2].linexp(0,1,20,800);

	Ndef(\doomNoise).set(\gain,gain,\fFreq,freq,)
},'ojkos/doomNoise/y');

OSCdef(\doomNoise,{ |msg, time,addr, recvPort|
	var val = msg[1..].sum.asInteger;

	case
	{val == 0}{ Ndef(\doomNoise).clear }
	{val > 0}{

		Ndef(\doomNoise,{
			var sig = BrownNoise.ar(1);
			sig = BPF.ar(sig,\fFreq.kr(440),\rq.kr(1));
			sig = (sig *\gain.kr(10)).clip2;
			sig = Pan2.ar(sig,\pan.kr(0),\amp.kr(0.3) * 0.1);
		}).play(out:OJKOS.synthOutBus)
	}
},'ojkos/doomNoise/z');

/*=============   if   ===============*/

OSCdef(\ifStart,{ |msg, time,addr, recvPort|
	var val = msg[1].asInteger;

	case
	{val == 0}{ ifPart1.stop }
	{val == 1}{
		Routine({

			Synth(\monoPlayback,[\bufnum,OJKOS.pbTracks['fred']['if0'],\amp,-15.dbamp,\out,OJKOS.synthOutBus]);
			OJKOS.pbTracks['fred']['if0'].duration.wait;
			1.wait;
			Synth(\monoPlayback,[\bufnum,OJKOS.pbTracks['fred']['if1'],\amp,-15.dbamp,\out,OJKOS.synthOutBus]);
			// ifPart1.play;
			OJKOS.cueFrom('ifStart','ifD',true,true,false).play

		}).play;
	}

},'ojkos/ifStart/x');

OSCdef(\ifStartCue,{ |msg, time,addr, recvPort|
	var val = msg[1].asInteger;

	case
	{val == 0}{ Click.loopCues['ifStart'] = true; "ifStart true".postln }
	{val == 1}{ Click.loopCues['ifStart'] = false; "ifStart false".postln};
},'ojkos/ifStartCue/x');

OSCdef(\ifRMCue,{ |msg, time,addr, recvPort|
	var val = msg[1].asInteger;

	case
	{val == 0}{ Click.loopCues['ifStartRM'] = true; "ifStartRM true".postln }
	{val == 1}{ Click.loopCues['ifStartRM'] = false; "ifStartRM false".postln};
},'ojkos/ifRingModCue/x');

OSCdef(\ifPart2,{ |msg, time,addr, recvPort|
	var val = msg[1].asInteger;

	if(Ndef(\ringerKnut).isPlaying.not || Ndef(\ringerHenriette).isPlaying.not,{
		"the ring mods must be on!!!".postln;
	},{
		case
		{val == 0}{ ifPart2.stop }
		{val == 1}{ ifPart2.play };
	})
},'ojkos/ifPart2/x');

OSCdef(\ifRingMod,{ |msg, time,addr, recvPort|
	var knutVal = msg[1].asInteger;
	var henVal = msg[2].asInteger;

	case
	{knutVal == 0} { Ndef(\ringerKnut).clear }
	{knutVal == 1} {
		Ndef(\ringerKnut,{
			var sig = SoundIn.ar( OJKOS.inBus['knutVibes'] );
			var mod = SinOsc.ar(\modFreq.kr(1000,0.1));

			// sig = Compander.ar(sig,sig,0.1,5,1); // gate ... add threshold

			sig = sig * mod;
			sig = LeakDC.ar(sig);
			sig = Pan2.ar(sig,\pan.kr(0),\amp.kr(0.5,0.01));
		}).play(OJKOS.fxOutBus)
	};

	case
	{henVal == 0} { Ndef(\ringerHenriette).clear }
	{henVal == 1} {
		Ndef(\ringerHenriette,{
			var sig = SoundIn.ar( OJKOS.inBus['henriette'] );
			var mod = SinOsc.ar(\modFreq.kr(1000,0.1));

			// sig = Compander.ar(sig,sig,0.1,5,1); // gate ... add threshold

			sig = sig * mod;
			sig = LeakDC.ar(sig);
			sig = Pan2.ar(sig,\pan.kr(0),\amp.kr(0.5,0.01));
		}).play(OJKOS.fxOutBus)
	};

},'ojkos/ringMod/x');


OSCdef(\ifRingModFaders,{ |msg, time,addr, recvPort|
	var knutAmp = \db.asSpec.map(msg[1]).dbamp;
	var modFreq  = msg[2].lincurve(0,1,1,2000,4);
	var henAmp  = \db.asSpec.map(msg[3]).dbamp;

	Ndef(\ringerKnut).set(\modFreq,modFreq,\amp,knutAmp);
	Ndef(\ringerHenriette).set(\modFreq,modFreq,\amp,henAmp);
},'ojkos/ringModFreq/x');

/*=============   else   ==============*/

OSCdef(\elseStart,{  |msg, time,addr, recvPort|

	Routine({

		Synth(\monoPlayback,[\bufnum,OJKOS.pbTracks['fred']['else0'],\amp,-15.dbamp,\out,OJKOS.synthOutBus]);
		OJKOS.pbTracks['fred']['else0'].duration.wait;
		2.wait;
		Synth(\monoPlayback,[\bufnum,OJKOS.pbTracks['fred']['else1'],\amp,-15.dbamp,\out,OJKOS.synthOutBus]);
		(OJKOS.pbTracks['fred']['else1'].duration - 8).wait;
		// elsePart1.play;
		OJKOS.cueFrom('elseA','elseB',true,true,false).play

	}).play;

},'ojkos/elseStart/x');

OSCdef(\elsePart2,{ |msg, time,addr, recvPort|
	var val = msg[1].asInteger;

	case
	{val == 0}{ elsePart2.stop }
	{val == 1}{ elsePart2.play };
},'ojkos/elseCue/x');

OSCdef(\magnusCue,{ |msg, time,addr, recvPort|
	var val = msg[1].asInteger;

	case
	{val == 0}{ Click.loopCues['elseLoop'] = true; "elseLoop true".postln }
	{val == 1}{ Click.loopCues['elseLoop'] = false; "elseLoop false".postln};
},'ojkos/magnus/x');

OSCdef(\elseSoloAmp,{ |msg, time,addr, recvPort|

	Ndef(\elseSolo).set(\amp,\db.asSpec.map(msg[1]).dbamp)

},'ojkos/elseSolo/x');

OSCdef(\elseSoloRate,{ |msg, time,addr, recvPort|
	var freq = msg[1].linexp(0,1,40,12000);
	var index = msg[2].linlin(0,1,0,(OJKOS.elseIndex-1)).asInteger;

	Ndef(\elseSolo).set(\fFreq,freq,\bufnum,OJKOS.elseBufs[index])

},'ojkos/elseSoloArgs/x');

OSCdef(\elseSoloRate,{ |msg, time,addr, recvPort|
	var rq = msg[1].linexp(0,1,1,0.01);
	var rate = msg[2].linexp(0,1,0.5,3);

	Ndef(\elseSolo).set(\rq,rq,\rate,rate);

},'ojkos/elseSoloArgs/y');

OSCdef(\elseSolo,{ |msg, time,addr, recvPort|
	var val = msg[1].asInteger;

	case
	{val == 0}{ Ndef(\elseSolo).clear }
	{val == 1}{
		Ndef(\elseSolo,{
			var bufnum = \bufnum.kr();
			var frames = BufFrames.kr(bufnum);
			var pos = Phasor.ar(0,BufRateScale.kr(bufnum) * \rate.kr(1),\start.kr(0) * frames,\end.kr(1) * frames);
			var sig = BufRd.ar(2,bufnum,pos);

			sig = BPF.ar(sig,\fFreq.kr(500),\rq.kr(1));

			sig = (sig * \gain.kr(1)).tanh;
			sig = Balance2.ar(sig[0],sig[1],\pan.kr(0),\amp.kr(0.5));

		}).set(\bufnum,OJKOS.elseBufs[OJKOS.elseIndex.rand]).play
	}
},'ojkos/elseSolo/z');

OSCdef(\elseBufRange,{ |msg, time,addr, recvPort|
	var start = msg[1];
	var end = msg[2];

	Ndef(\elseSolo).set(\start,start,\end,end);

},'ojkos/bufRange/x');

/*=============   outro   ==============*/

// needs one button toggle

OSCdef(\outroPlay,{ |msg, time,addr, recvPort|
	var val = msg[1].asInteger;

	case
	{val == 0}{
		OJKOS.outro = false;
		outro.stop;
	}
	{val == 1}{
		OJKOS.outro = true;
		outro.play;
	};
},'ojkos/outro/x');
)