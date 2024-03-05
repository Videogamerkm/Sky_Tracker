extends Object

const util = preload("res://SpiritUtils.gd")

static var seasons = ["Season of the Nine-Colored Deer",
	"Season of Revival",
	"Season of Moments",
	"Season of Passage",
	"Season of Remembrance",
	"Season of AURORA",
	"Season of Shattering",
	"Season of Performance",
	"Season of Abyss",
	"Season of Flight",
	"Season of the Little Prince",
	"Season of Assembly",
	"Season of Dreams",
	"Season of Prophecy",
	"Season of Sanctuary",
	"Season of Enchantment",
	"Season of Rhythm",
	"Season of Belonging",
	"Season of Lightseekers",
	"Season of Gratitude"]

static var data = {"Bearhug Hermit":{"loc":"Season of Dreams",
	"tree":[["seas/exp/bearhug?2;8;h","seas/cos/bearhug 3;70;c","seas/cos/bearhug 2;50;c"],["","base/5C;5;c",""],
	["seas/cos/bearhug 1;42;c","base/wing;2;a","base/heart;3;c"],["base/sheet?19;15;c","base/5C;5;c",""],["","seas/exp/bearhug?1;0;0",""]]},
	
	"Light Whisperer":{"loc":"Season of Flight",
	"tree":[["seas/cos/light 1;50;c","seas/cos/light 4;70;c","seas/cos/light 2;65;c"],["","base/5C;5;c",""],
	["seas/cos/light 3;45;c","base/wing;2;a","base/heart;3;c"],["","base/5C;5;c",""],["","seas/exp/light;0;0",""]]},
	
	"Nodding Muralist":{"loc":"Season of Enchantment",
	"tree":[["","seas/cos/nod 2;34;c",""],["seas/exp/nod?4;6;h","base/5C;5;c",""],["","seas/exp/nod?3;3;h",""],
	["seas/cos/nod 1;30;c","base/wing;2;a","base/heart;3;c"],["seas/exp/nod?2;4;h","base/5C;5;c",""],["","seas/exp/nod?1;0;0",""]]},
	
	"Indifferent Alchemist":{"loc":"Season of Enchantment",
	"tree":[["seas/cos/shrug 2;42;c","seas/cos/shrug 3;70;c",""],["seas/exp/shrug?4;6;h","base/5C;5;c",""],["","seas/exp/shrug?3;3;h",""],
	["seas/cos/shrug 1;42;c","base/wing;2;a","base/heart;3;c"],["seas/exp/shrug?2;4;h","base/5C;5;c",""],["","seas/exp/shrug?1;0;0",""]]},
	
	"Ceasing Commodore":{"loc":"Season of Abyss",
	"tree":[["seas/cos/calm 1;40;c","seas/cos/calm 3;70;c",""],["seas/exp/calm?4;6;h","base/5C;5;c",""],["","seas/exp/calm?3;3;h",""],
	["seas/cos/calm 2;45;c","base/wing;2;a","base/heart;3;c"],["seas/exp/calm?2;4;h","base/5C;5;c",""],["","seas/exp/calm?1;0;0",""]]},
	
	"Frantic Stagehand":{"loc":"Season of Performance",
	"tree":[["seas/exp/shake?2;8;h","seas/cos/shake 2;34;c","seas/cos/shake 3;70;c"],["","base/5C;5;c",""],
	["seas/cos/shake 1;48;c","base/wing;2;a","base/heart;3;c"],["base/sheet?29;22;c","base/5C;5;c",""],["","seas/exp/shake?1;0;0",""]]},
	
	"Herb Gatherer":{"loc":"Season of the Nine-Colored Deer",
	"tree":[["base/5C;0;0;sp","base/season_heart;3;sp;sp",""],["seas/exp/whistle?4;0;0;sp","seas/cos/whistle 2;36;sp",""],
	["base/5C;0;0;sp","seas/exp/whistle?3;30;sp",""],["seas/cos/whistle sp;0;0;sp","seas/cos/whistle 1;26;sp",""],
	["seas/exp/whistle?2;0;0;sp","base/5C;16;sp",""],["","seas/exp/whistle?1;0;0",""]]},
	
	"Hunter":{"loc":"Season of the Nine-Colored Deer",
	"tree":[["base/5C;0;0;sp","base/season_heart;3;sp;sp",""],["seas/cos/flex sp;0;0;sp","seas/cos/flex 2;34;sp",""],
	["seas/exp/flex?4;0;0;sp","base/5C;28;sp",""],["base/5C;0;0;sp","seas/exp/flex?3;20;sp",""],
	["seas/exp/flex?2;0;0;sp","seas/cos/flex 1;8;sp",""],["","seas/exp/flex?1;0;0",""]]},
	
	"Feudal Lord":{"loc":"Season of the Nine-Colored Deer",
	"tree":[["base/5C;0;0;sp","base/season_heart;3;sp;sp",""],["seas/cos/cradle sp2;0;0;sp","base/sheet?39;32;sp",""],
	["base/5C;0;0;sp","base/5C;26;sp",""],["seas/cos/cradle sp1;0;0;sp","seas/cos/cradle;18;sp",""],
	["seas/exp/cradle?2;0;0;sp","base/5C;6;sp",""],["","seas/exp/cradle?1;0;0",""]]},
	
	"Princess":{"loc":"Season of the Nine-Colored Deer",
	"tree":[["seas/cos/princess sp2;0;0;sp","base/season_heart;3;sp;sp",""],["base/5C;0;0;sp","base/5C;32;sp",""],
	["seas/exp/princess?4;0;0;sp","seas/cos/princess 2;26;sp",""],["seas/cos/princess sp1;0;0;sp","seas/exp/princess?3;22;sp",""],
	["base/5C;0;0;sp","base/5C;18;sp",""],["seas/exp/princess?2;0;0;sp","seas/cos/princess 1;8;sp",""],["","seas/exp/princess?1;0;0",""]]},
	
	"Spirit of Mural":{"loc":"Season of the Nine-Colored Deer","isGuide":true,
	"tree":[["","seas/cos/mural 5;2;sh;sp",""],["","seas/cos/mural 4;1;sh;sp",""],
	["seas/cos/mural 1;50;c","seas/cos/mural 3;1;sh;sp","seas/cos/mural 2;120;c"],["","seas/icons/the Nine-Colored Deer;0;0;sp",""]]}}

static func get_cost(name) -> Dictionary: return util.get_cost(data,name)
static func get_unspent(name,bought) -> Dictionary: return util.get_unspent(data,name,bought)

static func get_spent(name,bought) -> int:
	var c = 0
	var x = 0
	for row in data[name]["tree"]:
		var y = 0
		for item in row:
			if item != "" && item.split(";")[2] == "sp" && bought[x][y]:
				c += int(item.split(";")[1])
			y += 1
		x += 1
	return c

static func get_completion(name,bought) -> int: return util.get_completion(data,name,bought)
static func get_t2_completion(name,bought) -> int: return util.get_t2_completion(data,name,bought)
static func get_all_wings() -> int: return util.get_all_wings(data)
static func get_wings(bought) -> int: return util.get_wings(data,bought)
static func get_all_t2_wings() -> int: return util.get_all_t2_wings(data)
static func get_t2_wings(bought) -> int: return util.get_t2_wings(data,bought)
