//////////// == CONTROL STRUCTURES: CLASS == ////////////

OJKOS {

	var <data, <pbTracks;
	var <masterAmp, <clickAmps;

	*new { |lemurAddr|
		^super.new.init(lemurAddr);  // do I have any args to copy here??
	}

	init { |clickOuts, synthOuts, processOuts, lemurAddr|
		var server = Server.default;
		var path = "/Users/mikemccormick/Library/Application Support/SuperCollider/Extensions/OJKOS/";

		server.waitForBoot({

			// load clicks....and lights???
			data = File.readAllString(path ++ "score.scd").interpret;

			// load buffers
			pbTracks = PathName(path ++ "audio").entries.collect({ |entry|

				Buffer.read(server,entry.fullPath);

			});

			// load synthDefs
			File.readAllString(path ++ "synthDefs.scd").interpret;

			// load oscDefs
			File.readAllString(path ++ "oscDefs.scd").interpret.value(lemurAddr);

			// allocate busses
			masterAmp = Bus.control(server,1);               // consider writing wrapper methods to get/set these busses
			clickAmps = Bus.control(server,4).value_(0.5);   // or how many clickAmps do I need???


		});
	}

	sections {
		var sectArray =	data.collect({ |section| section['name'] });
		^sectArray
	}

	clicks {
		var clickArray = data.collect({ |section| section['click'] });
		^clickArray
	}

	cueFrom { |from = 'intro', to = 'outro', click = true, countIn = false|  // maybe each individual click has a slot in data Arrays? So I can
		var fromIndex = this.sections.indexOf(from);
		var toIndex = this.sections.indexOf(to);
		var countInArray, cuedArray = [];

		if(countIn,{                                             // can I make this a 4-voice countIn that calculates the correct offsets for each voice?
			var bpm = this.clicks[fromIndex].flat.first.bpm;

			countInArray = Pseq([ ClickCue(bpm,2,repeats: 2).pattern, ClickCue(bpm,1,repeats: 4).pattern ]);  // must add outputs for these clicks as well!!
		},{
			countInArray = Pseq([ Rest(0) ])   // test???
		});

		if(click,{
			var clickArray = [];

			for(fromIndex,toIndex,{ |index|

				clickArray = clickArray ++ data[index]['click'];
			});

			clickArray = clickArray.deepCollect(3,{ |clk| clk.pattern.key });
			clickArray = Psym( Pseq(clickArray) );

			cuedArray = cuedArray.add(clickArray)
		});

		^Pdef("%_%|%|%".format(from, to, click, countIn).asSymbol,
			Pseq([
				countInArray,
				Ppar(cuedArray)
			])
		);
	}
}


/*
OJKOS(
	[21,22,23,24], //clickOuts
	25, // synthOuts (stereo)
	27, // processOuts (stereo)
	NetAddr("192.168.0.101", 8000), // lemurAddr
)
*/

