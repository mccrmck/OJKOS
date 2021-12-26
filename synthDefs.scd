//////////// == CONTROL STRUCTURES: SYNTHDEFS == ////////////

SynthDef(\monoIn,{
	var sig = SoundIn.ar(\inBus.kr(0));


}).add



// possible paradigm
// Ndef chains for each player, allows for easy cleanup after processing?

Ndef(\henriette).put(0,\monoIn,extraArgs: [] )

Ndef(\henriette).put(20,\filter -> { /* routing, volume control? */ },extraArgs: [\outBus,~busGoesHere])

Ndef(\henriette).put(1,\filter -> { /* pitchTracker */ },extraArgs: [\lpfFreq, 2000])
