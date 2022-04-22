//////////// == CONTROL STRUCTURES == ////////////

OJKOS {

	classvar <inBus, <clickOutBus, <synthOutBus, <fxOutBus, <lemurAddr;
	classvar <patterns, <score, <pbTracks;
	classvar <tranceBuf, <elseBufs, <recBufs;

	*new { |ins, clicks, synthOut, fxOut, guiAddr|
		^super.new.init(ins,clicks, synthOut, fxOut, guiAddr);
	}

	init { |ins_, clicks_, synthOut_, fxOut_, guiAddr_|
		var server = Server.default;
		var path = Platform.userExtensionDir +/+ "OJKOS/";

		server.waitForBoot({

			inBus = ins_;
			clickOutBus = clicks_;
			synthOutBus = synthOut_;
			fxOutBus = fxOut_;
			lemurAddr = guiAddr_;

			// load synthDefs
			File.readAllString(path ++ "synthDefs.scd").interpret;

			server.sync;

			// load Patterns
			patterns = File.readAllString(path ++ "patterns.scd").interpret;
			server.sync;

			// load buffers
			pbTracks = PathName(path ++ "audio").entries.collect({ |entry|

				if(entry.isFolder)

				Buffer.read(server,entry.fullPath);

			});

			// load score
			score = File.readAllString(path ++ "score.scd").interpret;

			server.sync;

			tranceBuf = Buffer.alloc(server,server.sampleRate * 15 * 60/142);
			// elseBufs = Array.fill(12,{Buffer.alloc(server,server.sampleRate * 8,2)}); // shouold these be timed differently to match what they record?
			// recBufs = Array.fill(12,{Buffer.alloc(server,server.sampleRate * 8)});

			server.sync;

			// oscDefs for Lemur
			File.readAllString(path ++ "oscDefs.scd").interpret.value(lemurAddr);
		});
	}

	*sections {
		^score.collect({ |section| section['name'] });
	}

	*clicks {
		^score.collect({ |section| section['click'] });
	}

	*cueFrom { |from = 'intro', to = 'outro', click = true, pats = true, countIn = false|
		var fromIndex = this.sections.indexOf(from);
		var toIndex = this.sections.indexOf(to);
		var countInArray = [], cuedArray = [];

		if(countIn,{
			if(score[fromIndex]['countIn'].flat.size > 0, {
				var count = score[fromIndex]['countIn'].deepCollect(2,{ |clk| clk.pattern });
				count = count.collect({ |clk| Pseq(clk) });
				countInArray = countInArray.add( Ppar( count ) );
			})
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

			if( pats,{
				var synthesisArray = score[index]['pats'];

				if(synthesisArray.size > 0,{
					sectionArray = sectionArray.add( Ppar( synthesisArray ) );
				});
			});

			cuedArray = cuedArray.add( Ppar( sectionArray ) );
		});

		^Pdef("%_%|%|%|%".format(from, to, click, pats, countIn).asSymbol,
			Pseq( countInArray ++ cuedArray )
		);
	}
}