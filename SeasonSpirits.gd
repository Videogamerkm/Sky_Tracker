extends Node

const util = preload("res://SpiritUtils.gd")

var seasons = ["Season of the Nine-Colored Deer",
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

@onready var data = collect_seasons()

func collect_seasons() -> Dictionary:
	var d = {}
	for s in seasons:
		if FileAccess.file_exists("res://data/"+s+".json"):
			d.merge(JSON.parse_string(FileAccess.open("res://data/"+s+".json", FileAccess.READ).get_as_text()))
	return d

func get_cost(n) -> Dictionary: return util.get_cost(data,n)
func get_unspent(n,bought) -> Dictionary: return util.get_unspent(data,n,bought)

func get_spent(n,bought) -> int:
	var c = 0
	var x = 0
	for row in data[n]["tree"]:
		var y = 0
		for item in row:
			if item != "" && item.split(";")[2] == "sp" && bought[x][y]:
				c += int(item.split(";")[1])
			y += 1
		x += 1
	return c

func get_completion(n,bought) -> int: return util.get_completion(data,n,bought)
func get_t2_completion(n,bought) -> int: return util.get_t2_completion(data,n,bought)
func get_all_wings() -> int: return util.get_all_wings(data)
func get_wings(bought) -> int: return util.get_wings(data,bought)
func get_all_t2_wings() -> int: return util.get_all_t2_wings(data)
func get_t2_wings(bought) -> int: return util.get_t2_wings(data,bought)
