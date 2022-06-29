//////////// == CONTROL STRUCTURES: CLASS == ////////////

OJKOS {

	classvar <inBus, <clickOutBus, <synthOutBus, <fxOutBus, <kickOut, <lemurAddr;
	classvar <patterns, <score, <pbTracks;
	classvar <>tune = true, <>outro = true, <>kickLoop = true;
	classvar <tranceBuf, <elseBufs, <recBufs;
	classvar <elseIndex = 0;

	*initClass {
		pbTracks = IdentityDictionary();
	}

	*new { |ins, clicks, synthOut, fxOut, kickOut, guiAddr|
		^super.new.init(ins, clicks, synthOut, fxOut, kickOut, guiAddr);
	}

	init { |ins_, clicks_, synthOut_, fxOut_, kickOut_, guiAddr_|
		var server = Server.default;
		var path = Platform.userExtensionDir +/+ "OJKOS/";

		server.waitForBoot({

			inBus = ins_;
			clickOutBus = clicks_;
			synthOutBus = synthOut_;
			fxOutBus = fxOut_;
			kickOut = kickOut_;
			lemurAddr = guiAddr_;

			tranceBuf = Buffer.alloc(server,server.sampleRate * (60/142 * 4 * 8) );
			elseBufs = Array.fill(12,{Buffer.alloc(server,server.sampleRate * 8,2)});  // should these be timed differently to match what they record?

			server.sync;
			// load synthDefs
			File.readAllString(path +/+ "meat" +/+ "synthDefs.scd").interpret;
			server.sync;

			// load buffers
			PathName(path ++ "potatoes").entries.collect({ |entry|

				if(entry.isFolder,{
					var folderKey = entry.folderName.asSymbol;
					var folder = IdentityDictionary();
					entry.entries.do({ |folderEntry|
						var fileKey = folderEntry.fileNameWithoutExtension.asSymbol;
						var file = Buffer.read(server,folderEntry.fullPath);
						folder.put(fileKey,file)
					});
					pbTracks.put(folderKey,folder);

				},{
					var key = entry.fileNameWithoutExtension.asSymbol;
					var file = Buffer.read(server,entry.fullPath);

					pbTracks.put(key,file);
				});
			});

			server.sync;

			// load Patterns
			patterns = File.readAllString(path +/+ "meat" +/+ "patterns.scd").interpret;
			server.sync;

			// load score
			score = File.readAllString(path +/+ "meat" +/+ "score.scd").interpret;
			server.sync;

			// oscDefs for Lemur
			File.readAllString(path +/+ "meat" +/+ "oscDefs.scd").interpret;
			server.sync;

			"READY TO PLAY".postln
		});
	}

	*sections {
		^score.collect({ |section| section['name'] });
	}

	*clicks {
		^score.collect({ |section| section['click'] });
	}

	*nextElseBuf {
		var buf = elseBufs[elseIndex];
		elseIndex = (elseIndex + 1) % elseBufs.size;
		^buf
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