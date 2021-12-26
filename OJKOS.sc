//////////// == CONTROL STRUCTURES: CLASS == ////////////

OJKOS {

	var <data, pbTracks

	*new { |lemurAddr|
		^super.new.init(lemurAddr);  // do I have any args to copy here??
	}

	init { |lemurAddr
		var server = Server.default;
		var path = "/Users/mikemccormick/Library/Application Support/SuperCollider/Extensions/OJKOS/";

		server.waitForBoot({

			// load clicks....and lights???
			data = File.readAllString(path ++ "data.scd").interpret;

			// load buffers
			pbTracks = PathName(path ++ "audio").entries.collect({ |entry|

				Buffer.read(server,entry.fullPath);

			});

			// load synthDefs
			File.readAllString(path ++ "synthDefs.scd").interpret;

			// load oscDefs
			File.readAllString(path ++ "oscDefs.scd").interpret.value(lemurAddr);


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

	cueFrom { |from = 'intro', to = 'outro', click = true, lights = true, countIn = false|
		var fromIndex = this.sections.indexOf(from);
		var toIndex = this.sections.indexOf(to);
		var countInArray, cuedArray = [];

		if(countIn,{
			var bpm = this.clicks[fromIndex].flat.first.bpm;

			countInArray = [ Click(bpm,2,repeats: 2), Click(bpm,1,repeats: 4) ].collect({ |clk| clk.pattern });

			countInArray = Pseq(countInArray);        // must add outputs for this click as well!! Can these be passed through YAWNShow?

		},{
			countInArray = Pseq([Rest(0)]),   // test???
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