//////////// == CONTROL STRUCTURES == ////////////

OJKOS {

	var <score, <pbTracks;
	// var <masterAmp, <clickAmps;

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

			// load lemur interface

		});
	}

	sections {
		^score.collect({ |section| section['name'] });
	}

	clicks {
		^score.collect({ |section| section['click'] });
	}

	cueFrom { |from = 'intro', to = 'outro', click = true, countIn = false|
		var fromIndex = this.sections.indexOf(from);
		var toIndex = this.sections.indexOf(to);
		var countInArray, cuedArray = [];

		if(countIn,{
			var count = score[fromIndex]['countIn'].deepCollect(2,{ |clk| clk.pattern });

			countInArray = count.collect({ |clk| Pseq(clk) });
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

			cuedArray = cuedArray.add( Ppar( sectionArray ) );
		});

		^Pdef("%_%|%|%".format(from, to, click, countIn).asSymbol,
			Pseq( countInArray ++ cuedArray )
		);
	}
}
