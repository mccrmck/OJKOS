

Ndef(\foley,{
	var sig	= SoundIn.ar(\inBus.kr(0));
	sig = Compander.ar(sig,sig,\compThresh.kr(0.5),1,\ratio.kr(1).reciprocal,\compAtk.kr(0.01),\compRls.kr(0.1));

}).stop


// make parProcess Dict for oneshot Synths!




// build this up!!
~process = IdentityDictionary[    // should these be stereo or mono?

	\ring -> { |in|
		var mod = SinOsc.ar(\rmFreq.kr(100));
		var sig = in *  mod;
		sig = LeakDC.ar(sig);
		sig
	},
	\delay -> { |in|
		var sig = in * Env.sine(1).kr; // this should be made into a .kr, no?
		sig = LocalIn.ar(1) + sig;

		sig = DelayC.ar(sig,1.0,\dly.kr(0.1));

		LocalOut.ar(sig * \dcyCoef.kr(0.99).clip(0,1.5));
		sig + SinOsc.ar(280,mul: 0.2)
	},
	\fBack -> { |in|
		var sig = in;
		sig = LocalIn.ar(1) + sig;

		sig = RLPF.ar(sig,\feedFfreq.kr(150),\feedRQ.kr(1),\gain.kr(1)).tanh;

		LocalOut.ar(sig * \fBackCoef.kr(0.99));
		sig
	},
]


Ndef(\foley).play.filter(2,~process['ring'])
Ndef(\foley).put(2,nil).stop
Ndef(\foley).objects

Ndef(\foley).set(\rmFreq,50)





// filter maker? How can I switch things very quickly but keep track of index number

~this = { |index, function|

	Ndef(\foley)[index] = \filter -> function
}

