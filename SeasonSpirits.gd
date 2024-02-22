extends Object

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
	"tree":[["seas/exp/bearhug;8;h","seas/cos/bearhug 3;70;c","seas/cos/bearhug 2;50;c"],["","base/5C;5;c",""],
	["seas/cos/bearhug 1;42;c","base/wing;2;a","base/heart;3;c"],["base/sheet;15;c","base/5C;5;c",""],["","seas/exp/bearhug;0;0",""]]},
	
	"Herb Gatherer":{"loc":"Season of the Nine-Colored Deer",
	"tree":[["base/5C;0;0;sp","base/season_heart;3;sp;sp",""],["seas/exp/whistle;0;0;sp","seas/cos/whistle 2;36;sp",""],
	["base/5C;0;0;sp","seas/exp/whistle;30;sp",""],["seas/cos/whistle sp;0;0;sp","seas/cos/whistle 1;26;sp",""],
	["seas/exp/whistle;0;0;sp","base/5C;16;sp",""],["","seas/exp/whistle;0;0",""]]},
	"Hunter":{"loc":"Season of the Nine-Colored Deer",
	"tree":[["base/5C;0;0;sp","base/season_heart;3;sp;sp",""],["seas/cos/flex sp;0;0;sp","seas/cos/flex 2;34;sp",""],
	["seas/exp/flex;0;0;sp","base/5C;28;sp",""],["base/5C;0;0;sp","seas/exp/flex;20;sp",""],
	["seas/exp/flex;0;0;sp","seas/cos/flex 1;8;sp",""],["","seas/exp/flex;0;0",""]]},
	"Feudal Lord":{"loc":"Season of the Nine-Colored Deer",
	"tree":[["base/5C;0;0;sp","base/season_heart;3;sp;sp",""],["seas/cos/cradle sp2;0;0;sp","base/sheet;32;sp",""],
	["base/5C;0;0;sp","base/5C;26;sp",""],["seas/cos/cradle sp1;0;0;sp","seas/cos/cradle;18;sp",""],
	["seas/exp/cradle;0;0;sp","base/5C;6;sp",""],["","seas/exp/cradle;0;0",""]]},
	"Princess":{"loc":"Season of the Nine-Colored Deer",
	"tree":[["seas/cos/princess sp2;0;0;sp","base/season_heart;3;sp;sp",""],["base/5C;0;0;sp","base/5C;32;sp",""],
	["seas/exp/princess;0;0;sp","seas/cos/princess 2;26;sp",""],["seas/cos/princess sp1;0;0;sp","seas/exp/princess;22;sp",""],
	["base/5C;0;0;sp","base/5C;18;sp",""],["seas/exp/princess;0;0;sp","seas/cos/princess 1;8;sp",""],["","seas/exp/princess;0;0",""]]},
	"Spirit of Mural":{"loc":"Season of the Nine-Colored Deer",
	"tree":[["","seas/cos/mural 5;2;sh;sp",""],["","seas/cos/mural 4;1;sh;sp",""],
	["seas/cos/mural 1;50;c","seas/cos/mural 3;1;sh;sp","seas/cos/mural 2;120;c"],["","seas/icons/the Nine-Colored Deer;0;0;sp",""]]}}

static func get_cost(name) -> Dictionary:
	var c = 0
	var h = 0
	var a = 0
	var sp = 0
	var c2 = 0
	var h2 = 0
	var a2 = 0
	for row in data[name]["tree"]:
		for item in row:
			if item == "": continue
			var amnt = int(item.split(";")[1])
			var type = item.split(";")[2]
			if item.split(";").size() > 3:
				if type == "c": c2 += amnt
				if type == "h": h2 += amnt
				if type == "a": a2 += amnt
			else:
				if type == "sp": sp += amnt
				if type == "c": c += amnt
				if type == "h": h += amnt
				if type == "a": a += amnt
	return {"c":c,"h":h,"a":a,"c2":c2,"h2":h2,"a2":a2,"sp":sp}

static func get_unspent(name,bought) -> Dictionary:
	var c = 0
	var h = 0
	var a = 0
	var sp = 0
	var c2 = 0
	var h2 = 0
	var a2 = 0
	var x = 0
	for row in data[name]["tree"]:
		var y = 0
		for item in row:
			if not(item == "" || bought[x][y]):
				var amnt = int(item.split(";")[1])
				var type = item.split(";")[2]
				if item.split(";").size() > 3:
					if type == "c": c2 += amnt
					if type == "h": h2 += amnt
					if type == "a": a2 += amnt
				else:
					if type == "sp": sp += amnt
					if type == "c": c += amnt
					if type == "h": h += amnt
					if type == "a": a += amnt
			y += 1
		x += 1
	return {"c":c,"h":h,"a":a,"c2":c2,"h2":h2,"a2":a2,"sp":sp}

static func get_spent(name,bought) -> int:
	var c = 0
	var x = 0
	for row in data[name]["tree"]:
		var y = 0
		for item in row:
			if item != "" && bought[x][y]:
				c += int(item.split(";")[1])
			y += 1
		x += 1
	return c

static func get_completion(name,bought) -> int:
	var b = 0
	var t = 0
	var x = 0
	for row in data[name]["tree"]:
		var y = 0
		for item in row:
			if item != "" && bought[x][y]: b += 1
			if item != "": t += 1
			y += 1
		x += 1
	return floor(b*100.0/t)

static func get_all_wings() -> int:
	var w = 0
	for s in data:
		for row in data[s]["tree"]:
			for item in row:
				if item != "" && item.split(";")[0] == "base/wing": w += 1
	return w

static func get_wings(bought) -> int:
	var w = 0
	for s in data:
		var x = 0
		for row in data[s]["tree"]:
			var y = 0
			for item in row:
				if item != "" && bought.has(s) && item.split(";")[0] == "base/wing" && bought[s][x][y]: w += 1
				y += 1
			x += 1
	return w
