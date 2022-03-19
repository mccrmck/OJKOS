//////////// == CONTROL STRUCTURES == ////////////

OJKOS {

	var <score, <pbTracks;
	var <masterAmp, <clickAmps;

	*new { |clickOuts, synthOuts, processOuts, lemurAddr|
		^super.new.init(clickOuts, synthOuts, processOuts, lemurAddr);  // do I have any args to copy here??
	}

	init { |clickOuts, synthOuts, processOuts, lemurAddr|
		var server = Server.default;
		var path = Platform.userExtensionDir +/+ "OJKOS/";

		server.waitForBoot({

			// load score
			score = File.readAllString(path ++ "score.scd").interpret;

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

			// load lemur interface

		});
	}

	sections {
		^score.collect({ |section| section['name'] });
	}

	clicks {
		^score.collect({ |section| section['click'] });
	}

	cueFrom { |from = 'intro', to = 'outro', click = true, kemper = true, bTracks = true, countIn = false|
		var fromIndex = this.sections.indexOf(from);
		var toIndex = this.sections.indexOf(to);
		var countInArray, cuedArray = [];

		if(countIn,{                                                   // how do I make this generate a click for every voice??
			var bpm = this.clicks[fromIndex].flat.first.bpm;

			countInArray = Pseq([ Click(bpm,2,repeats: 2).pattern, Click(bpm,1,repeats: 4).pattern ]);   // must add outputs for these clicks as well!!
		},{
			countInArray = Pbind(
				\dur, Pseq([0],1),
				\note, Rest(0.1)
			)
		});

		for(fromIndex,toIndex,{ |index|
			var sectionArray = [];

			if( click,{
				var clkArray = score[index]['click'].deepCollect(2,{ |clk| clk.pattern });

				clkArray = clkArray.collect({ |clk| Pseq(clk) });

				if(clkArray.size > 0,{
					sectionArray = sectionArray.add( Ppar( clkArray ) );
				});
			});

			if( kemper,{
				var kemperArray = score[index]['kemper'];

				if(kemperArray.size > 0,{
					sectionArray = sectionArray.add( Ppar( kemperArray ) );
				});
			});

			if( bTracks,{
				var trackArray = score[index]['bTracks'];

				if(trackArray.size > 0,{
					sectionArray = sectionArray.add( Ppar( trackArray ) );
				});
			});

			cuedArray = cuedArray.add( Ppar( sectionArray ) );
		});

		^Pdef("%_%|%|%|%".format(from, to, click, kemper, bTracks, countIn).asSymbol,
			Pseq( [countInArray] ++ cuedArray )
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