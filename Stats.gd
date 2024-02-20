extends VBoxContainer

@onready var current = $"../../../Current Season/Margin/VBox"
@onready var regular = $"../../../Regular Spirits/Margin/VBox"
var spirits = preload("res://RegSpirits.gd")
var seas_spirits = preload("res://SeasonSpirits.gd")
var areas = ["Isle of Dawn","Daylight Prairie","Hidden Forest","Valley of Triumph","Golden Wasteland","Vault of Knowledge"]

func _ready():
	set_values()

func set_values():
	# Current season values
	$"Current Season/Spent/Season Spent".text = current.get_node("Spent/Val").text
	var coll = int(current.get_node("Total/Val").text)
	var need = (current.needPass if current.get_node("Pass/Check").button_pressed else current.needNoPass)
	$"Current Season/Needed/Season Need".text = str(need - coll)
	$"Current Season/Avail/Season Avail".text = current.get_node("Candles/Val").text
	$"Current Season/Completion/Season Avail".text = "0%" # TODO: Get season completion %
	
	# Regular spirit values
	var spentTotal = {"c":0,"h":0,"a":0,"c2":0,"h2":0,"a2":0}
	var neededTotal = {"c":0,"h":0,"a":0,"c2":0,"h2":0,"a2":0}
	for a in areas:
		var costsSpent = {"c":0,"h":0,"a":0,"c2":0,"h2":0,"a2":0}
		var costsNeeded = {"c":0,"h":0,"a":0,"c2":0,"h2":0,"a2":0}
		for s in spirits.data:
			if spirits.data[s]["loc"] == a:
				var sCost = spirits.get_cost(s)
				if regular.bought.has(s):
					var sUnspent = spirits.get_unspent(s,regular.bought[s])
					for key in costsNeeded.keys():
						costsNeeded[key] += sUnspent[key]
						costsSpent[key] += sCost[key] - sUnspent[key]
				else:
					for key in costsNeeded.keys():
						costsNeeded[key] += sCost[key]
		var overall = 0
		for type in ["c","h","a"]:
			var tCap = type.capitalize()
			get_node("Regular Spirits/"+a+"/Grid/"+tCap+" Spent").text = str(costsSpent[type])
			get_node("Regular Spirits/"+a+"/Grid/"+tCap+" Needed").text = str(costsNeeded[type])
			overall += costsSpent[type]*100/(costsSpent[type]+costsNeeded[type])
			get_node("Regular Spirits/"+a+"/Grid/"+tCap+" Comp").text = str(floor(costsSpent[type]*100.0/(costsSpent[type]+costsNeeded[type])))+"%"
			if has_node("Regular Spirits/"+a+"/Grid/"+tCap+" T2"):
				get_node("Regular Spirits/"+a+"/Grid/"+tCap+" T2").text = str(costsNeeded[type+"2"])
		get_node("Regular Spirits/"+a+"/Completion/Need").text = str(floor(overall/3.0))+"%"
		for key in costsNeeded.keys():
			spentTotal[key] += costsSpent[key]
			neededTotal[key] += costsNeeded[key]
	var overall = 0
	for type in ["c","h","a"]:
		var tCap = type.capitalize()
		get_node("Regular Spirits/Grid/"+tCap+" Spent").text = str(spentTotal[type])
		get_node("Regular Spirits/Grid/"+tCap+" Needed").text = str(neededTotal[type])
		overall += spentTotal[type]*100/(spentTotal[type]+neededTotal[type])
		get_node("Regular Spirits/Grid/"+tCap+" Comp").text = str(floor(spentTotal[type]*100.0/(spentTotal[type]+neededTotal[type])))+"%"
		if has_node("Regular Spirits/Grid/"+tCap+" T2"):
			get_node("Regular Spirits/Grid/"+tCap+" T2").text = str(neededTotal[type+"2"])
	get_node("Regular Spirits/Completion/Need").text = str(floor(overall/3.0))+"%"
	
	# Seasonal spirit values
	# TODO: Seasonal spirits
	
	# Winged Light
	var light_areas = areas.duplicate()
	light_areas.append_array(["Eye of Eden","Shattered Memories"])
	var light_coll = 0
	var light_avail = 0
	for a in light_areas:
		var check = $"../../../Winged Light Tracker/Margin/VBox".get_checked(a)
		var uncheck = $"../../../Winged Light Tracker/Margin/VBox".get_unchecked(a)
		light_coll += check
		light_avail += uncheck
		$"Winged Light/Grid".get_node(a+" Coll").text = str(check)
		$"Winged Light/Grid".get_node(a+" Avail").text = str(uncheck)
	$"Winged Light/Grid".get_node("Total Coll").text = str(light_coll)
	$"Winged Light/Grid".get_node("Total Avail").text = str(light_avail)

func _on_expand_pressed():
	for c in get_children():
		if c == $Main: continue
		if c.get_node("Title/Label").text == "v": c.get_node("Title").set_pressed(false)

func _on_collapse_pressed():
	for c in get_children():
		if c == $Main: continue
		if c.get_node("Title/Label").text == "^": c.get_node("Title").set_pressed(true)
