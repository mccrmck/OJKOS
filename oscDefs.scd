//////////// == CONTROL STRUCTURES: OSCDEFS == ////////////
{ |lemurAddr|

	/*== click Pdefs == */


	var introPart1 = OJKOS.cueFrom('introA','introB',true,true,false);

	var breakPart1 = OJKOS.cueFrom('breakIntro','breakI',true,true,false);

	var case = OJKOS.cueFrom('caseA','caseF',true,true,false);

	var tryABC = OJKOS.cueFrom('caseA','caseF',true,true,false);
	var tryD = OJKOS.cueFrom('tryD','tryD',true,true,false);
	var tryE = OJKOS.cueFrom('tryE','tryE',true,true,false);
	var tryF = OJKOS.cueFrom('tryF','tryF',true,true,false);
	var tryG = OJKOS.cueFrom('tryG','tryG',true,true,false);
	var tryH = OJKOS.cueFrom('tryH','tryH',true,true,false);
	var tryI = OJKOS.cueFrom('tryI','tryI',true,true,false);
	var tryJ = OJKOS.cueFrom('tryJ','tryJ',true,true,false);
	var tryLast = OJKOS.cueFrom('tryK','tryN',true,true,false);

	var pushPart1 = OJKOS.cueFrom('pushA','pushE',true,true,false);
	var push2Pop = OJKOS.cueFrom('pushF','popB',true,true,false);

	var popPart2 = OJKOS.cueFrom('popC','popK',true,true,false);

	var ifPart1 = OJKOS.cueFrom('ifStart','ifD',true,true,false);
	var ifPart2 = OJKOS.cueFrom('ifE','ifG',true,true,false);


	var elsePart1 = OJKOS.cueFrom('elseA','elseB',true,true,false);
	var elsePart2 = OJKOS.cueFrom('elseC','elseF',true,true,false);

	var outro = OJKOS.cueFrom('outro','outro',true,true,false);


	lemurAddr.postln;

	/*=============   intro   ==============*/

	OSCdef(\introPart1,{ |msg, time,addr, recvPort|
		var val = msg[1].asInteger;

		case
		{val == 0}{
			introPart1.stop;
		}
		{val == 1}{
			introPart1.play;
		};
	},);               // needs address


	OSCdef(\firstCue,{ |msg, time,addr, recvPort|
		var val = msg[1].asInteger;

		case
		{val == 0}{
			Synth(\monoPlayback,[\bufnum,OJKOS.pbTracks['fred']['intro0'],\amp,-15.dbamp,\out,OJKOS.synthOutBus]);
		}
		{val == 1}{
			Synth(\monoPlayback,[\bufnum,OJKOS.pbTracks['fred']['intro1'],\amp,-15.dbamp,\out,OJKOS.synthOutBus]);
		}
		{val == 2}{
			Synth(\monoPlayback,[\bufnum,OJKOS.pbTracks['fred']['intro2'],\amp,-15.dbamp,\out,OJKOS.synthOutBus]);
		};
	},);                // needs address

	OSCdef(\firstCue,{ |msg, time,addr, recvPort|
		var val = msg[1].asInteger;

		case
		{val == 0}{
			Click.loopCues['introLoop'] = true;
		}
		{val == 1}{
			Click.loopCues['introLoop'] = false;
		};
	},);      // needs address


	OSCdef(\tuneCue,{ |msg, time,addr, recvPort|
		var val = msg[1].asInteger;

		case
		{val == 0}{
			Click.loopCues['tuneLoop'] = true;
			OJKOS.tune = true;
		}
		{val == 1}{
			Click.loopCues['tuneLoop'] = false;
			OJKOS.tune = false;
		};
	},);      // needs address


	/*=============   begin   ==============*/

	OSCdef(\emptySet,{  |msg, time,addr, recvPort|

		Routine({

			Synth(\monoPlayback,[\bufnum,OJKOS.pbTracks['fred']['begin'],\amp,-15.dbamp,\out,OJKOS.synthOutBus]);

			OJKOS.pbTracks['fred']['begin'].duration.wait;

			Ndef(\emptySet,{
				var varT = \lagTime.kr(0);
				var varC = \lagCurve.kr(0);
				var sig, freq = \freq.kr(40).varlag(varT,varC);
				var harms = (1..4);
				var mid = VarSaw.ar(freq * harms,harms.reciprocal.reverse,\width.kr(0.5).varlag(varT,varC),harms.reciprocal).sum;
				var side = PinkNoise.ar(1,\offset.kr(0).varlag(varT,varC)).clip2;
				mid = (mid * \midGain.kr(0.5).varlag(varT,varC)).tanh;

				side = LeakDC.ar( HPF.ar( HPF.ar(side,90),90) ) ;
				side = (side * \sideGain.kr(4).varlag(varT,varC)).fold2;

				sig = MS2Stereo.ar([mid * \midAmp.kr(1).varlag(varT,varC),side * \sideAmp.kr(1).varlag(varT,varC)]);
				sig = (sig * \gain.kr(4).varlag(varT,varC));

				sig = RHPF.ar(sig,\hpFreq.kr(80).varlag(varT,varC),\hpQ.kr(0.1).varlag(varT,varC));
				sig = RLPF.ar(sig,\lpFreq.kr(8000).varlag(varT,varC),\lpQ.kr(1).varlag(varT,varC));

				sig = MidEQ.ar(sig,500,1,6);
				sig = sig.tanh;
				sig = Compander.ar(sig,In.ar(\sChain.kr(),1),\thresh.kr(0.5),1,\ratio.kr().reciprocal,\cAtk.kr(0.01),\cRls.kr(0.1)); // must test this!!
				sig = Balance2.ar(sig[0],sig[1],\pan.kr(0),\amp.kr(0.25) * -6.dbamp);
			}).play;

		}).play
	},);                            // needs address

	// Ndef(\emptySet).set(\lagTime,2,\lagCurve,4)
	// Ndef(\emptySet).set(\freq,40,\lpFreq,2000,\lpQ,0.5,\hpFreq,40,\hpQ,1,\midGain,0.02,\sideGain,4,\offset,0.9,\gain,8,\width,0.02,\amp,0.5)
	// Ndef(\emptySet).clear


	/*=============   break   ==============*/



	OSCdef(\breakStart,{  |msg, time,addr, recvPort|

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
			11.wait;
			// breakPart1 starts here? fade in?

		}).play

	},);                            // needs address


	/*=============   case   ==============*/


	OSCdef(\caseTalk,{  |msg, time,addr, recvPort|

		Synth(\monoPlayback,[\bufnum,OJKOS.pbTracks['fred']['case'],\amp,-15.dbamp,\out,OJKOS.synthOutBus]);

	},);                            // needs address

	OSCdef(\pluckIntro,{ |msg, time,addr, recvPort|

		var freq = 400.exprand(800);
		Synth(\pluck,[\freq,freq,\dcy,4.neg,\coef,0.75.rrand(0.92),\fFreq,freq * 4,\fGain,1,\gain,8,\amp,0.05.rrand(0.2),\pan,0.5.rand2,\out,OJKOS.synthOutBus]);

	},);      // needs address



	OSCdef(\caseStart,{ |msg, time,addr, recvPort|
		var val = msg[1].asInteger;

		case
		{val == 0}{
			case.stop;
		}
		{val == 1}{
			case.play;
		};
	},);               // needs address



	// some distortion controls go here?


	/*=============   try   ==============*/

	OSCdef(\tryStart,{  |msg, time,addr, recvPort|

		Synth(\monoPlayback,[\bufnum,OJKOS.pbTracks['fred']['try'],\amp,-15.dbamp,\out,OJKOS.synthOutBus]);

		//must add a \resNoise synth here too! very subtle, on A...how do I free it?!?!? Ndef?

	},);                            // needs address


	OSCdef(\tryCues,{ |msg, time,addr, recvPort|
		var val = msg[1].asInteger;

		// I could use one of the YAWN templates to do off switches as well...worth it?

		case
		{val == 0}{ tryABC.play } // A
		{val == 1}{ tryABC.play } // B
		{val == 2}{ tryABC.play } // C
		{val == 3}{ tryD.play } // D
		{val == 4}{ tryE.play } // E
		{val == 5}{ tryF.play } // F
		{val == 6}{ tryG.play } // G
		{val == 7}{ tryH.play } // H
		{val == 8}{ tryI.play } // I
		{val == 9}{ tryJ.play } // J
		{val == 10}{ tryLast.play } // Last


	},);

	/*=============   push   ==============*/


	OSCdef(\pushStart,{  |msg, time,addr, recvPort|

		Routine({
			Synth(\monoPlayback,[\bufnum,OJKOS.pbTracks['fred']['push0'],\amp,-15.dbamp,\out,OJKOS.synthOutBus]);
			OJKOS.pbTracks['fred']['push0'].duration.wait;
			2.wait;
			Synth(\monoPlayback,[\bufnum,OJKOS.pbTracks['fred']['push1'],\amp,-15.dbamp,\out,OJKOS.synthOutBus]);
			(OJKOS.pbTracks['fred']['push1'].duration - (8 * 60/150)).wait;
			pushPart1.play;

		}).play;
		//must add a \resNoise synth here too! very subtle, on A...how do I free it?!?!? Ndef?

	},);

	OSCdef(\pushToPop,{ |msg, time,addr, recvPort|
		var val = msg[1].asInteger;

		case
		{val == 0}{

			push2Pop.stop;

		}
		{val == 1}{

			push2Pop.play;
		};
	},);




	/*=============   pop   ==============*/


	OSCdef(\popPart2,{ |msg, time,addr, recvPort|
		var val = msg[1].asInteger;

		case
		{val == 0}{

			popPart2.stop;

		}
		{val == 1}{

			popPart2.play;
		};
	},);

	/*
	Ndef(\bitCrush,{
	var sig = SoundIn.ar(OJKOS.inBus['henriette']);
	var sig = Decimator.ar(in,SampleRate.ir * \sRate.kr(0.5).linexp(0,1,0.005,0.6),24 * \bits.kr(1).linexp(0,1,0.05,0.3));
	sig = Compander.ar(sig,sig,0.5,1,1/3,0.01,0.1,3);
	sig = (sig * \gain.kr(1)).tanh;
	Pan2.ar(sig,\pan.kr(0),\amp.kr(1));
	}).play(out:OJKOS.fxOutBus)


	Ndef(\popNoise,{
	var sig = BrownNoise.ar(1);
	sig = BPF.ar(sig,\fFreq.kr(440),\rq.kr(1));
	sig = (sig *\gain.kr(10)).clip2;
	sig = Pan2.ar(sig,\pan.kr(0),\amp.kr(0.3));
	}).set(\amp,0).play


	Ndef(\popNoise).set(\gain,200,\fFreq,500,\rq,0.8,\amp,0.1)
	*/

	/*=============   if   ===============*/

	OSCdef(\ifStart,{  |msg, time,addr, recvPort|

		Routine({

			Synth(\monoPlayback,[\bufnum,OJKOS.pbTracks['fred']['if0'],\amp,-15.dbamp,\out,OJKOS.synthOutBus]);
			OJKOS.pbTracks['fred']['if0'].duration.wait;
			1.wait;
			Synth(\monoPlayback,[\bufnum,OJKOS.pbTracks['fred']['if1'],\amp,-15.dbamp,\out,OJKOS.synthOutBus]);
			ifPart1.play;

		}).play;

	},);


	OSCdef(\ifPart1,{ |msg, time,addr, recvPort|
		var val = msg[1].asInteger;

		case
		{val == 0}{

			ifPart1.stop;

		}
		{val == 1}{

			ifPart1.play;
		};
	},);


	OSCdef(\ifStartCue,{ |msg, time,addr, recvPort|
		var val = msg[1].asInteger;

		case
		{val == 0}{ Click.loopCues['ifStart'] = true }
		{val == 1}{ Click.loopCues['ifStart'] = false};
	},);

	OSCdef(\ifRMCue,{ |msg, time,addr, recvPort|
		var val = msg[1].asInteger;

		case
		{val == 0}{ Click.loopCues['ifStartRM'] = true }
		{val == 1}{ Click.loopCues['ifStartRM'] = false};
	},);


	OSCdef(\ifPart2,{ |msg, time,addr, recvPort|
		var val = msg[1].asInteger;

		case
		{val == 0}{

			ifPart2.stop;

		}
		{val == 1}{

			ifPart2.play;
		};
	},);

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


	// when running the ifE - ifG click, it needs to be protected with a Ndef(\ringerHenriette).isPlaying!

	/*=============   else   ==============*/

	//as if impro fades, text starts w/ Oskar's click also coming..

	OSCdef(\elsePart1,{ |msg, time,addr, recvPort|
		var val = msg[1].asInteger;

		case
		{val == 0}{

			elsePart1.stop;

		}
		{val == 1}{

			elsePart1.play;
		};
	},);                                         // needs address

	OSCdef(\elsePart2,{ |msg, time,addr, recvPort|
		var val = msg[1].asInteger;

		case
		{val == 0}{

			elsePart2.stop;

		}
		{val == 1}{

			elsePart2.play;
		};
	},);

	OSCdef(\magnusCue,{ |msg, time,addr, recvPort|
		var val = msg[1].asInteger;

		case
		{val == 0}{ Click.loopCues['elseLoop'] = true }
		{val == 1}{ Click.loopCues['elseLoop'] = false};
	},);

	OSCdef(\magnusCue,{ |msg, time,addr, recvPort|
		var val = msg[1].asInteger;

		case
		{val == 0}{ Click.loopCues['elseLoop'] = true }
		{val == 1}{ Click.loopCues['elseLoop'] = false};
	},);



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
	},);               // needs address

}
