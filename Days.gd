extends VBoxContainer

const timeUtils = preload("res://TimeUtils.gd")
const day = "Days of Love"
const location = "Jellyfish Cove"
const short = "love"
const start = {"day":12,"month":2,"year":2024,"hour":0}
const end = {"day":25,"month":2,"year":2024,"hour":23,"minute":59}
const left = " day(s) left in the season"
var bought = {}
const rows = {"Days of Love":[["days/love/4;15;h","days/love/5;100;c",""],["base/sheet;7;k","base/5C;5;c","days/love/3;15;h"],
	["days/love/1;14;k","base/5C;5;c","days/love/2;27;k"],["","base/teleport;0;0",""]]}

func _ready():
	if timeUtils.get_time_since(end) < 0:
		hide()
		$"../No".show()
	else:
		show()
		$Name.text = day
		$Time/Start.text = timeUtils.convert_time(start)
		$Time/End.text = timeUtils.convert_time(end)
		var days = floor(timeUtils.get_time_since(end)/86400.0)
		$Days.text = str(days) + left
		$Tree.set_tree(rows[day])

func _process(_delta):
	if not $Days.text == str(floor(timeUtils.get_time_since(end)/86400.0)) + left:
		_ready()

func _on_tree_bought():
	bought[day] = $Tree.export_bought()

func _on_all_pressed():
	$Tree.buy_all()

func import():
	if timeUtils.get_time_since(end) >= 0 && bought.has(day):
		$Tree.import_bought(bought[day])

static func get_location_override() -> String:
	if timeUtils.get_time_since(end) < 0: return ""
	else: return location
