extends VBoxContainer

@onready var current = $"../../../Current Season/Margin/VBox"
@onready var regular = $"../../../Regular Spirits/Margin/VBox"
@onready var seasonal = $"../../../Seasonal Spirits/Margin/VBox"
var spirits = preload("res://RegSpirits.gd")
var seas_spirits = preload("res://SeasonSpirits.gd")
var areas = ["Isle of Dawn","Daylight Prairie","Hidden Forest","Valley of Triumph","Golden Wasteland","Vault of Knowledge"]
var wedges = [1,2,5,10,20,35,55,75,100,120,150,200,250]

func _ready():
	set_values()

func set_values():
	# Current season values
	if current.get_node("Spent/Val").text == "0": current._ready()
	var spent = current.get_node("Spent/Val").text
	$"Current Season/Spent/Season Spent".text = spent
	spent = int(spent)
	var coll = int(current.get_node("Total/Val").text)
	var need = (current.needPass if current.get_node("Pass/Check").button_pressed else current.needNoPass)
	$"Current Season/Needed/Season Need".text = str(max(need - coll,0))
	$"Current Season/Avail/Season Avail".text = current.get_node("Candles/Val").text
	$"Current Season/Completion/Season".text = str(floor(spent*100/need))+"%"
	var comp = 0
	for s in seas_spirits.data:
		if seas_spirits.data[s]["loc"] == current.seasonName && seasonal.bought.has(s):
			comp += seas_spirits.get_completion(s,seasonal.bought[s])
	$"Current Season/Completion2/Season".text = str(floor(comp/4.0))+"%"
	
	# Regular spirit values
	var spentTotal = {"c":0,"h":0,"a":0,"c2":0,"h2":0,"a2":0}
	var neededTotal = {"c":0,"h":0,"a":0,"c2":0,"h2":0,"a2":0}
	var spiritTotal = 0
	var compTotal = 0.0
	for a in areas:
		var costsSpent = {"c":0,"h":0,"a":0,"c2":0,"h2":0,"a2":0}
		var costsNeeded = {"c":0,"h":0,"a":0,"c2":0,"h2":0,"a2":0}
		var spiritCount = 0
		var compPercent = 0.0
		for s in spirits.data:
			if spirits.data[s]["loc"] == a:
				spiritCount += 1
				var sCost = spirits.get_cost(s)
				if regular.bought.has(s):
					compPercent += spirits.get_completion(s,regular.bought[s])
					var sUnspent = spirits.get_unspent(s,regular.bought[s])
					for key in costsNeeded.keys():
						costsNeeded[key] += sUnspent[key]
						costsSpent[key] += sCost[key] - sUnspent[key]
				else:
					for key in costsNeeded.keys():
						costsNeeded[key] += sCost[key]
		var overall_spent = 0
		var overall_need = 0
		for type in ["c","h","a"]:
			var tCap = type.capitalize()
			get_node("Regular Spirits/"+a+"/Grid/"+tCap+" Spent").text = str(costsSpent[type])
			get_node("Regular Spirits/"+a+"/Grid/"+tCap+" Needed").text = str(costsNeeded[type])
			overall_spent += costsSpent[type]
			overall_need += costsNeeded[type]
			get_node("Regular Spirits/"+a+"/Grid/"+tCap+" Comp").text = str(floor(costsSpent[type]*100.0/(costsSpent[type]+costsNeeded[type])))+"%"
			if has_node("Regular Spirits/"+a+"/Grid/"+tCap+" T2"):
				get_node("Regular Spirits/"+a+"/Grid/"+tCap+" T2").text = str(costsNeeded[type+"2"])
		get_node("Regular Spirits/"+a+"/Completion/Need").text = str(floor(overall_spent*100.0/(overall_spent+overall_need)))+"%"
		get_node("Regular Spirits/"+a+"/Completion2/Need").text = str(floor(compPercent/spiritCount))+"%"
		for key in costsNeeded.keys():
			spentTotal[key] += costsSpent[key]
			neededTotal[key] += costsNeeded[key]
		spiritTotal += spiritCount
		compTotal += compPercent
	var overall_spent = 0
	var overall_need = 0
	for type in ["c","h","a"]:
		var tCap = type.capitalize()
		get_node("Regular Spirits/Total/Grid/"+tCap+" Spent").text = str(spentTotal[type])
		get_node("Regular Spirits/Total/Grid/"+tCap+" Needed").text = str(neededTotal[type])
		overall_spent += spentTotal[type]
		overall_need += neededTotal[type]
		get_node("Regular Spirits/Total/Grid/"+tCap+" Comp").text = str(floor(spentTotal[type]*100.0/(spentTotal[type]+neededTotal[type])))+"%"
		if has_node("Regular Spirits/Total/Grid/"+tCap+" T2"):
			get_node("Regular Spirits/Total/Grid/"+tCap+" T2").text = str(neededTotal[type+"2"])
	get_node("Regular Spirits/Total/Completion/Need").text = str(floor(overall_spent*100.0/(overall_spent+overall_need)))+"%"
	get_node("Regular Spirits/Total/Completion2/Need").text = str(floor(compTotal/spiritTotal))+"%"
	
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
	var reg_coll = spirits.get_wings(regular.bought)
	var reg_avail = spirits.get_all_wings() - reg_coll
	$"Winged Light/Grid".get_node("Regular Coll").text = str(reg_coll)
	$"Winged Light/Grid".get_node("Regular Avail").text = str(reg_avail)
	var seas_coll = seas_spirits.get_wings(seasonal.bought)
	var seas_avail = seas_spirits.get_all_wings() - seas_coll
	$"Winged Light/Grid".get_node("Seasonal Coll").text = str(seas_coll)
	$"Winged Light/Grid".get_node("Seasonal Avail").text = str(seas_avail)
	$"Winged Light/Grid".get_node("Total Coll2").text = str(light_coll + reg_coll + seas_coll)
	$"Winged Light/Grid".get_node("Total Avail2").text = str(light_avail + reg_avail + seas_avail)
	var w = 0
	while light_coll + reg_coll + seas_coll >= wedges[w]: w += 1
	$"Winged Light/Wings".text = "You should have "+str(w)+" cape wedges."

func _on_expand_pressed():
	for c in get_children():
		if c == $Main: continue
		if c.get_node("Margin/Title/Label").text == "v": c.get_node("Margin/Title").set_pressed(false)

func _on_collapse_pressed():
	for c in get_children():
		if c == $Main: continue
		if c.get_node("Margin/Title/Label").text == "^": c.get_node("Margin/Title").set_pressed(true)

func _on_expand_reg_pressed():
	for c in $"Regular Spirits".get_children():
		if c == $"Regular Spirits/Main": continue
		if c.name == "Margin": continue
		if c.get_node("Margin/Title/Label").text == "v": c.get_node("Margin/Title").set_pressed(false)

func _on_collapse_reg_pressed():
	for c in $"Regular Spirits".get_children():
		if c == $"Regular Spirits/Main": continue
		if c.name == "Margin": continue
		if c.get_node("Margin/Title/Label").text == "^": c.get_node("Margin/Title").set_pressed(true)
