extends Node

@onready var data = JSON.parse_string(FileAccess.open("res://data/Regular.json", FileAccess.READ).get_as_text())

func get_cost(n) -> Dictionary:
	var ret = SpiritUtils.get_cost(data,n)
	ret.erase("sp")
	ret.erase("sh")
	return ret

func get_unspent(n,bought) -> Dictionary:
	var ret = SpiritUtils.get_unspent(data,n,bought)
	ret.erase("sp")
	ret.erase("sh")
	return ret

func get_completion(n,bought) -> int: return SpiritUtils.get_completion(data,n,bought)
func get_t2_completion(n,bought) -> int: return SpiritUtils.get_t2_completion(data,n,bought)
func get_all_wings() -> int: return SpiritUtils.get_all_wings(data)
func get_all_t2_wings() -> int: return SpiritUtils.get_all_t2_wings(data)
func get_wings(bought) -> int: return SpiritUtils.get_wings(data,bought)
func get_t2_wings(bought) -> int: return SpiritUtils.get_t2_wings(data,bought)
