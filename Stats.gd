extends VBoxContainer

@onready var current = $"../../../Current Season/Margin/VBox"
@onready var regular = $"../../../Regular Spirits/Margin/VBox"
@onready var seasonal = $"../../../Seasonal Spirits/Margin/VBox"
var spirits = preload("res://RegSpirits.gd")
var seas_spirits = preload("res://SeasonSpirits.gd")
var areas = ["Isle of Dawn","Daylight Prairie","Hidden Forest","Valley of Triumph","Golden Wasteland","Vault of Knowledge"]
var wedges = [1,2,5,10,20,35,55,75,100,120,150,200,250]

func _ready():
	var row = $"Regular Spirits/Isle of Dawn/Titles"
	for a in areas:
		var area_row = get_node("Regular Spirits/"+a)
		if not a == "Isle of Dawn": area_row.add_child(row.duplicate())
	for s in spirits.data:
		var spirit_row = row.duplicate()
		spirit_row.name = s
		get_node("Regular Spirits/"+spirits.data[s]["loc"]).add_child(spirit_row)
		if spirits.data[s].has("t2"):
			spirit_row = row.duplicate()
			spirit_row.name = s+" T2"
			spirit_row.get_node("Spirit").text = "Tier 2"
			spirit_row.get_node("Spirit").horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
			spirit_row.get_node("By Purchase").text = "100%"
			spirit_row.set_modulate(Color(1,0.75,0.75))
			get_node("Regular Spirits/"+spirits.data[s]["loc"]).add_child(spirit_row)
	for a in seas_spirits.seasons:
		var new_row = $"Seasonal Spirits/Season".duplicate()
		new_row.name = a
		if a == current.seasonName:
			new_row.get_node("Titles/c").text = "S. Candles"
			new_row.get_node("Titles/h").text = "S. Hearts"
			new_row.get_node("Titles/a").text = "Candles"
		$"Seasonal Spirits".add_child(new_row)
	for s in seas_spirits.data:
		var new_row = $"Seasonal Spirits/Season/Titles".duplicate()
		new_row.name = s
		get_node("Seasonal Spirits/"+seas_spirits.data[s]["loc"]).add_child(new_row)
	$"Seasonal Spirits/Season".queue_free()
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
	$"Current Season/Completion3/Season".text = str(floor(spent*100/need))+"%"
	var comp = 0
	var guideComp = 0
	var seasonSpirits = 0.0
	for s in seas_spirits.data:
		if seas_spirits.data[s]["loc"] == current.seasonName:
			seasonSpirits += 1
			if seasonal.bought.has(s):
				comp += seas_spirits.get_completion(s,seasonal.bought[s])
				if seas_spirits.data[s].has("isGuide"): guideComp = seas_spirits.get_completion(s,seasonal.bought[s])
	$"Current Season/Completion2/Season".text = str(floor(comp/seasonSpirits))+"%"
	$"Current Season/Completion/Season".text = str(floor((comp-guideComp)/(seasonSpirits-1)))+"%"
	
	# Regular spirit values
	var spentTotal = {"c":0,"h":0,"a":0,"c2":0,"h2":0,"a2":0,"u":0}
	var neededTotal = {"c":0,"h":0,"a":0,"c2":0,"h2":0,"a2":0,"u":0}
	var spiritTotal = 0
	var compTotal = 0.0
	var elderTotal = 0
	for a in areas:
		var costsSpent = {"c":0,"h":0,"a":0,"c2":0,"h2":0,"a2":0,"u":0}
		var costsNeeded = {"c":0,"h":0,"a":0,"c2":0,"h2":0,"a2":0,"u":0}
		var spiritCount = 0
		var compPercent = 0.0
		var elderPercent = 0
		for s in spirits.data:
			if spirits.data[s]["loc"] == a:
				spiritCount += 1
				var sCost = spirits.get_cost(s)
				get_node("Regular Spirits/"+a+"/"+s+"/Spirit").text = s
				var currency = 0
				var curr_spent = 0
				var asc = 0
				var asc_spent = 0
				get_node("Regular Spirits/"+a+"/"+s+"/By Purchase").text = "0%"
				if regular.bought.has(s):
					compPercent += spirits.get_completion(s,regular.bought[s])
					if s.begins_with("Elder of"): elderPercent = spirits.get_completion(s,regular.bought[s])
					get_node("Regular Spirits/"+a+"/"+s+"/By Purchase").text = str(spirits.get_completion(s,regular.bought[s]))+"%"
				for key in sCost.keys():
					if not key.contains("2"): currency += sCost[key]
					elif spirits.data[s].has("t2"): asc += sCost[key]
					if regular.bought.has(s):
						var sUnspent = spirits.get_unspent(s,regular.bought[s])
						if key == "a" && s.contains("Elder of"):
							costsNeeded["u"] += sUnspent[key]
							costsSpent["u"] += sCost[key] - sUnspent[key]
						else:
							costsNeeded[key] += sUnspent[key]
							costsSpent[key] += sCost[key] - sUnspent[key]
						if not key.contains("2"):
							get_node("Regular Spirits/"+a+"/"+s+"/"+key).text = str(sUnspent[key])
							curr_spent += sCost[key] - sUnspent[key]
						elif spirits.data[s].has("t2"):
							asc_spent += sCost[key] - sUnspent[key]
							get_node("Regular Spirits/"+a+"/"+s+" T2/"+key.replace("2","")).text = str(sUnspent[key])
					else:
						if key == "a" && s.contains("Elder of"): costsNeeded["u"] += sCost[key]
						else: costsNeeded[key] += sCost[key]
						if not key.contains("2"): get_node("Regular Spirits/"+a+"/"+s+"/"+key).text = str(sCost[key])
						elif spirits.data[s].has("t2"): get_node("Regular Spirits/"+a+"/"+s+" T2/"+key.replace("2","")).text = str(sCost[key])
				get_node("Regular Spirits/"+a+"/"+s+"/By Currency").text = str(floor(curr_spent*100.0/currency))+"%"
				if get_node("Regular Spirits/"+a+"/"+s+"/By Currency").text == "100%" && get_node("Regular Spirits/"+a+"/"+s+"/By Purchase").text == "100%":
					get_node("Regular Spirits/"+a+"/"+s).set_modulate(Color(0.75,1,0.75))
				else: get_node("Regular Spirits/"+a+"/"+s).set_modulate(Color(1,1,1))
				if spirits.data[s].has("t2"):
					get_node("Regular Spirits/"+a+"/"+s+" T2/By Currency").text = str(floor(asc_spent*100.0/asc))+"%"
					get_node("Regular Spirits/"+a+"/"+s+" T2").set_modulate(Color(1,0.75,0.75))
					if get_node("Regular Spirits/"+a+"/"+s+" T2/By Currency").text == "100%":
						get_node("Regular Spirits/"+a+"/"+s+" T2").set_modulate(Color(0.75,1,0.75))
		var overall_spent = 0
		var overall_need = 0
		for type in ["c","h","a","u"]:
			var tCap = type.capitalize()
			get_node("Constellations/"+a+"/Grid/"+tCap+" Spent").text = str(costsSpent[type])
			get_node("Constellations/"+a+"/Grid/"+tCap+" Needed").text = str(costsNeeded[type])
			overall_spent += costsSpent[type]
			overall_need += costsNeeded[type]
			get_node("Constellations/"+a+"/Grid/"+tCap+" Comp").text = str(floor(costsSpent[type]*100.0/(costsSpent[type]+costsNeeded[type])))+"%"
			if has_node("Constellations/"+a+"/Grid/"+tCap+" T2"):
				get_node("Constellations/"+a+"/Grid/"+tCap+" T2").text = str(costsNeeded[type+"2"])
		get_node("Constellations/"+a+"/Completion/Need").text = str(floor((compPercent-elderPercent)/(spiritCount-1)))+"%"
		get_node("Constellations/"+a+"/Completion3/Need").text = str(floor(overall_spent*100.0/(overall_spent+overall_need)))+"%"
		get_node("Constellations/"+a+"/Completion2/Need").text = str(floor(compPercent/spiritCount))+"%"
		for key in costsNeeded.keys():
			spentTotal[key] += costsSpent[key]
			neededTotal[key] += costsNeeded[key]
		spiritTotal += spiritCount
		compTotal += compPercent
		elderTotal += elderPercent
	var overall_spent = 0
	var overall_need = 0
	for type in ["c","h","a"]:
		var tCap = type.capitalize()
		get_node("Constellations/Total/Grid/"+tCap+" Spent").text = str(spentTotal[type])
		get_node("Constellations/Total/Grid/"+tCap+" Needed").text = str(neededTotal[type])
		overall_spent += spentTotal[type]
		overall_need += neededTotal[type]
		get_node("Constellations/Total/Grid/"+tCap+" Comp").text = str(floor(spentTotal[type]*100.0/(spentTotal[type]+neededTotal[type])))+"%"
		if has_node("Constellations/Total/Grid/"+tCap+" T2"):
			get_node("Constellations/Total/Grid/"+tCap+" T2").text = str(neededTotal[type+"2"])
	get_node("Constellations/Total/Completion/Need").text = str(floor((compTotal-elderTotal)/(spiritTotal-6)))+"%"
	get_node("Constellations/Total/Completion3/Need").text = str(floor(overall_spent*100.0/(overall_spent+overall_need)))+"%"
	get_node("Constellations/Total/Completion2/Need").text = str(floor(compTotal/spiritTotal))+"%"
	
	# Seasonal spirit values
	for s in seas_spirits.data:
		var costsNeeded = {"c":0,"h":0,"a":0,"c2":0,"h2":0,"a2":0,"sp":0,"sh":0}
		var sCost = seas_spirits.get_cost(s)
		var a = seas_spirits.data[s]["loc"]
		get_node("Seasonal Spirits/"+a+"/"+s+"/Spirit").text = s
		var currency = 0
		var curr_spent = 0
		var asc = 0
		var asc_spent = 0
		get_node("Seasonal Spirits/"+a+"/"+s+"/By Purchase").text = "0%"
		if seasonal.bought.has(s):
			get_node("Seasonal Spirits/"+a+"/"+s+"/By Purchase").text = str(seas_spirits.get_completion(s,seasonal.bought[s]))+"%"
		for key in sCost.keys():
			if not key.contains("2"): currency += sCost[key]
			elif seas_spirits.data[s].has("t2"): asc += sCost[key]
			if seasonal.bought.has(s):
				var sUnspent = seas_spirits.get_unspent(s,seasonal.bought[s])
				costsNeeded[key] += sUnspent[key]
				if key == "sp" && a == current.seasonName:
					get_node("Seasonal Spirits/"+a+"/"+s+"/c").text = str(sUnspent[key])
					curr_spent += sCost[key] - sUnspent[key]
				elif key == "sh" && a == current.seasonName:
					get_node("Seasonal Spirits/"+a+"/"+s+"/h").text = str(sUnspent[key])
					curr_spent += sCost[key] - sUnspent[key]
				elif key == "c" && a == current.seasonName:
					get_node("Seasonal Spirits/"+a+"/"+s+"/a").text = str(sUnspent[key])
					curr_spent += sCost[key] - sUnspent[key]
				elif key == "a" && a == current.seasonName: continue
				elif not key.contains("2") && not key.contains("s"):
					get_node("Seasonal Spirits/"+a+"/"+s+"/"+key).text = str(sUnspent[key])
					curr_spent += sCost[key] - sUnspent[key]
				elif seas_spirits.data[s].has("t2"):
					asc_spent += sCost[key] - sUnspent[key]
					get_node("Seasonal Spirits/"+a+"/"+s+" T2/"+key.replace("2","")).text = str(sUnspent[key])
			else:
				costsNeeded[key] += sCost[key]
				if key == "sp" && a == current.seasonName: get_node("Seasonal Spirits/"+a+"/"+s+"/c").text = str(sCost[key])
				elif key == "sh" && a == current.seasonName: get_node("Seasonal Spirits/"+a+"/"+s+"/h").text = str(sCost[key])
				elif key == "c" && a == current.seasonName: get_node("Seasonal Spirits/"+a+"/"+s+"/a").text = str(sCost[key])
				elif key == "a" && a == current.seasonName: continue
				elif not key.contains("2") && not key.contains("s"): get_node("Seasonal Spirits/"+a+"/"+s+"/"+key).text = str(sCost[key])
				elif seas_spirits.data[s].has("t2"): get_node("Seasonal Spirits/"+a+"/"+s+" T2/"+key.replace("2","")).text = str(sCost[key])
		get_node("Seasonal Spirits/"+a+"/"+s+"/By Currency").text = str(floor(curr_spent*100.0/currency))+"%"
		if get_node("Seasonal Spirits/"+a+"/"+s+"/By Currency").text == "100%" && get_node("Seasonal Spirits/"+a+"/"+s+"/By Purchase").text == "100%":
			get_node("Seasonal Spirits/"+a+"/"+s).set_modulate(Color(0.75,1,0.75))
		else: get_node("Seasonal Spirits/"+a+"/"+s).set_modulate(Color(1,1,1))
		if seas_spirits.data[s].has("t2"):
			get_node("Seasonal Spirits/"+a+"/"+s+" T2/By Currency").text = str(floor(asc_spent*100.0/asc))+"%"
			get_node("Seasonal Spirits/"+a+"/"+s+" T2").set_modulate(Color(1,0.75,0.75))
			if get_node("Seasonal Spirits/"+a+"/"+s+" T2/By Currency").text == "100%":
				get_node("Seasonal Spirits/"+a+"/"+s+" T2").set_modulate(Color(0.75,1,0.75))
	
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

func accordion(parent,expand):
	for c in parent.get_children():
		if c.name == "Main" || c.name == "Margin": continue
		if c.get_node("Margin/Title/Label").text == ("v" if expand else "^"):
			c.get_node("Margin/Title").set_pressed(not expand)

func accordion_text(id: String,expand: bool): accordion(get_node(id),expand)
