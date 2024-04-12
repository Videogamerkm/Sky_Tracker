extends VBoxContainer

const collapsible = preload("res://collapsible.gd")
const areas = ["Isle of Dawn","Daylight Prairie","Hidden Forest","Valley of Triumph","Golden Wasteland","Vault of Knowledge"]
const wedges = [1,2,5,10,20,35,55,75,100,120,150,200,250]

func _ready():
	var row = $"Regular Spirits/Isle of Dawn/Titles"
	for a in areas:
		var area_row = get_node("Regular Spirits/"+a)
		if not a == "Isle of Dawn": area_row.add_child(row.duplicate())
	for s in RegSpirits.data:
		for i in range(0,6):
			var spirit_row = row.get_child(i).duplicate()
			spirit_row.name += " "+s
			get_node("Regular Spirits/"+RegSpirits.data[s]["loc"]+"/Titles").add_child(spirit_row)
		if RegSpirits.data[s].has("t2"):
			for i in range(0,6):
				var spirit_row = row.get_child(i).duplicate()
				spirit_row.name += " "+s+" T2"
				if i == 0:
					spirit_row.text = "Tier 2"
					spirit_row.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
				spirit_row.set_modulate(Color(1,0.75,0.75))
				get_node("Regular Spirits/"+RegSpirits.data[s]["loc"]+"/Titles").add_child(spirit_row)
	for a in SeasonSpirits.seasons:
		var new_row = $"Seasonal Spirits/Season".duplicate()
		new_row.name = a
		if a == Global.currSsnTab.seasonName:
			new_row.get_node("Titles/c").text = "S. Candles"
			new_row.get_node("Titles/h").text = "S. Hearts"
			new_row.get_node("Titles/a").text = "Candles"
		$"Seasonal Spirits".add_child(new_row)
	for s in SeasonSpirits.data:
		for i in range(0,6):
			var new_row = $"Seasonal Spirits/Season/Titles".get_child(i).duplicate()
			new_row.name += " "+s
			get_node("Seasonal Spirits/"+SeasonSpirits.data[s]["loc"]+"/Titles").add_child(new_row)
		if SeasonSpirits.data[s].has("t2"):
			for i in range(0,6):
				var new_row = $"Seasonal Spirits/Season/Titles".get_child(i).duplicate()
				new_row.name += " "+s+" T2"
				new_row.text = "Tier 2"
				new_row.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
				new_row.set_modulate(Color(1,0.75,0.75))
				get_node("Seasonal Spirits/"+SeasonSpirits.data[s]["loc"]+"/Titles").add_child(new_row)
	$"Seasonal Spirits/Season".queue_free()
	for s in Global.yrlyTab.short.keys():
		for i in range(0,6):
			var new_row = $"Yearly Events/Titles".get_child(i).duplicate()
			new_row.name += " "+s
			$"Yearly Events/Titles".add_child(new_row)
	for b in get_all_acc_btns(self):
		if b.name == "Expand": b.connect("pressed",accordion.bind(b.get_parent().get_parent(),true))
		elif b.name == "Collapse": b.connect("pressed",accordion.bind(b.get_parent().get_parent(),false))

func get_all_acc_btns(in_node, children_acc = []):
	if in_node is Button and (in_node.name == "Expand" or in_node.name == "Collapse"):
		children_acc.push_back(in_node)
	for child in in_node.get_children():
		children_acc = get_all_acc_btns(child, children_acc)
	return children_acc

func set_values():
	# Current season values
	if floor(TimeUtils.get_time_until(Global.currSsnTab.end)/86400.0) < 0 or\
		TimeUtils.get_time_until(Global.currSsnTab.start) > 0: $"Current Season".hide()
	else:
		if Global.currSsnTab.get_node("Spent/Val").text == "0": Global.currSsnTab._ready()
		var spent = Global.currSsnTab.get_node("Spent/Val").text
		$"Current Season/Spent/Season Spent".text = spent
		spent = int(spent)
		var coll = int(Global.currSsnTab.get_node("Total/Val").text)
		var need = (Global.currSsnTab.needPass if Global.currSsnTab.get_node("Pass/Check").button_pressed else Global.currSsnTab.needNoPass)
		$"Current Season/Needed/Season Need".text = str(max(need - coll,0))
		$"Current Season/Avail/Season Avail".text = Global.currSsnTab.get_node("Candles/Val").text
		$"Current Season/Completion3/Season".text = str(floor(spent*100/need))+"%"
		var comp = 0
		var guideComp = 0
		var seasonSpirits = 0.0
		for s in SeasonSpirits.data:
			if SeasonSpirits.data[s]["loc"] == Global.currSsnTab.seasonName:
				seasonSpirits += 1
				if Global.ssnlSprtTab.bought.has(s):
					comp += SeasonSpirits.get_completion(s,Global.ssnlSprtTab.bought[s])
					if SeasonSpirits.data[s].has("isGuide"): guideComp = SeasonSpirits.get_completion(s,Global.ssnlSprtTab.bought[s])
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
		for s in RegSpirits.data:
			if RegSpirits.data[s]["loc"] == a:
				spiritCount += 1
				var sCost = RegSpirits.get_cost(s)
				get_node("Regular Spirits/"+a+"/Titles/Spirit "+s).text = s
				var currency = 0
				var curr_spent = 0
				var asc = 0
				var asc_spent = 0
				get_node("Regular Spirits/"+a+"/Titles/By Purchase "+s).text = "0%"
				if RegSpirits.data[s].has("t2"): get_node("Regular Spirits/"+a+"/Titles/By Purchase "+s+" T2").text = "0%"
				if Global.regSprtTab.bought.has(s):
					compPercent += RegSpirits.get_completion(s,Global.regSprtTab.bought[s])
					if s.begins_with("Elder of"): elderPercent = RegSpirits.get_completion(s,Global.regSprtTab.bought[s])
					get_node("Regular Spirits/"+a+"/Titles/By Purchase "+s).text = str(RegSpirits.get_completion(s,Global.regSprtTab.bought[s]))+"%"
					if RegSpirits.data[s].has("t2"): get_node("Regular Spirits/"+a+"/Titles/By Purchase "+s+" T2").text = str(RegSpirits.get_t2_completion(s,Global.regSprtTab.bought[s]))+"%"
				for key in sCost.keys():
					if key == "k": continue
					if not key.contains("2"): currency += sCost[key]
					elif RegSpirits.data[s].has("t2"): asc += sCost[key]
					if Global.regSprtTab.bought.has(s):
						var sUnspent = RegSpirits.get_unspent(s,Global.regSprtTab.bought[s])
						if key == "a" && s.contains("Elder of"):
							costsNeeded["u"] += sUnspent[key]
							costsSpent["u"] += sCost[key] - sUnspent[key]
						else:
							costsNeeded[key] += sUnspent[key]
							costsSpent[key] += sCost[key] - sUnspent[key]
						if not key.contains("2"):
							get_node("Regular Spirits/"+a+"/Titles/"+key+" "+s).text = str(sUnspent[key])
							curr_spent += sCost[key] - sUnspent[key]
						elif RegSpirits.data[s].has("t2"):
							asc_spent += sCost[key] - sUnspent[key]
							get_node("Regular Spirits/"+a+"/Titles/"+key.replace("2","")+" "+s+" T2").text = str(sUnspent[key])
					else:
						if key == "a" && s.contains("Elder of"): costsNeeded["u"] += sCost[key]
						else: costsNeeded[key] += sCost[key]
						if not key.contains("2"): get_node("Regular Spirits/"+a+"/Titles/"+key+" "+s).text = str(sCost[key])
						elif RegSpirits.data[s].has("t2"): get_node("Regular Spirits/"+a+"/Titles/"+key.replace("2","")+" "+s+" T2").text = str(sCost[key])
				get_node("Regular Spirits/"+a+"/Titles/By Currency "+s).text = str(floor(curr_spent*100.0/currency))+"%"
				var start = get_node("Regular Spirits/"+a+"/Titles/Spirit "+s).get_index()
				if get_node("Regular Spirits/"+a+"/Titles/By Currency "+s).text == "100%" && get_node("Regular Spirits/"+a+"/Titles/By Purchase "+s).text == "100%":
					for i in range(start,start+6):
						get_node("Regular Spirits/"+a+"/Titles").get_child(i).set_modulate(Color(0.75,1,0.75))
				else:
					for i in range(start,start+6):
						get_node("Regular Spirits/"+a+"/Titles").get_child(i).set_modulate(Color(1,1,1))
				if RegSpirits.data[s].has("t2"):
					start = get_node("Regular Spirits/"+a+"/Titles/Spirit "+s+" T2").get_index()
					get_node("Regular Spirits/"+a+"/Titles/By Currency "+s+" T2").text = str(floor(asc_spent*100.0/asc))+"%"
					var color = Color(0.75,1,0.75) if get_node("Regular Spirits/"+a+"/Titles/By Currency "+s+" T2").text == "100%" else Color(1,0.75,0.75)
					for i in range(start,start+6):
						get_node("Regular Spirits/"+a+"/Titles").get_child(i).set_modulate(color)
		var overall_spent = 0
		var overall_need = 0
		for type in ["c","h","a","u"]:
			var tCap = type.capitalize()
			get_node("Constellations/"+a+"/Grid/"+tCap+" Spent").text = str(costsSpent[type])
			get_node("Constellations/"+a+"/Grid/"+tCap+" Needed").text = str(costsNeeded[type])
			overall_spent += costsSpent[type]
			overall_need += costsNeeded[type]
			var perc = floor(costsSpent[type]*100.0/(costsSpent[type]+costsNeeded[type]))
			get_node("Constellations/"+a+"/Grid/"+tCap+" Comp").text = str(perc)+"%"
			var color = Color(0.75,1,0.75) if perc == 100 else Color(1,1,1)
			if has_node("Constellations/"+a+"/Grid/"+tCap+" T2"):
				get_node("Constellations/"+a+"/Grid/"+tCap+" T2").text = str(costsNeeded[type+"2"])
				get_node("Constellations/"+a+"/Grid/"+tCap+" T2").set_modulate(color if costsNeeded[type+"2"] == 0 else Color(1,0.75,0.75))
			get_node("Constellations/"+a+"/Grid/"+tCap).set_modulate(color)
			get_node("Constellations/"+a+"/Grid/"+tCap+" Spent").set_modulate(color)
			get_node("Constellations/"+a+"/Grid/"+tCap+" Needed").set_modulate(color)
			get_node("Constellations/"+a+"/Grid/"+tCap+" Comp").set_modulate(color)
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
	for type in ["c","h","a","u"]:
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
	for s in SeasonSpirits.data:
		var costsNeeded = {"c":0,"h":0,"a":0,"c2":0,"h2":0,"a2":0,"sp":0,"sh":0}
		var sCost = SeasonSpirits.get_cost(s)
		var a = SeasonSpirits.data[s]["loc"]
		get_node("Seasonal Spirits/"+a+"/Titles/Spirit "+s).text = s
		var currency = 0
		var curr_spent = 0
		var asc = 0
		var asc_spent = 0
		get_node("Seasonal Spirits/"+a+"/Titles/By Purchase "+s).text = "0%"
		if SeasonSpirits.data[s].has("t2"): get_node("Seasonal Spirits/"+a+"/Titles/By Purchase "+s+" T2").text = "0%"
		if Global.ssnlSprtTab.bought.has(s):
			get_node("Seasonal Spirits/"+a+"/Titles/By Purchase "+s).text = str(SeasonSpirits.get_completion(s,Global.ssnlSprtTab.bought[s]))+"%"
			if SeasonSpirits.data[s].has("t2"): get_node("Seasonal Spirits/"+a+"/Titles/By Purchase "+s+" T2").text = str(SeasonSpirits.get_t2_completion(s,Global.ssnlSprtTab.bought[s]))+"%"
		for key in sCost.keys():
			if key == "k": continue
			if not key.contains("2"): currency += sCost[key]
			elif SeasonSpirits.data[s].has("t2"): asc += sCost[key]
			if Global.ssnlSprtTab.bought.has(s):
				var sUnspent = SeasonSpirits.get_unspent(s,Global.ssnlSprtTab.bought[s])
				costsNeeded[key] += sUnspent[key]
				if key == "sp" && a == Global.currSsnTab.seasonName:
					get_node("Seasonal Spirits/"+a+"/Titles/c "+s).text = str(sUnspent[key])
					curr_spent += sCost[key] - sUnspent[key]
				elif key == "c" && a != Global.currSsnTab.seasonName:
					get_node("Seasonal Spirits/"+a+"/Titles/c "+s).text = str(sUnspent[key]+sUnspent["sp"])
					curr_spent += sCost[key] - sUnspent[key]
					curr_spent += sCost["sp"] - sUnspent["sp"]
				elif key == "sh" && a == Global.currSsnTab.seasonName:
					get_node("Seasonal Spirits/"+a+"/Titles/h "+s).text = str(sUnspent[key])
					curr_spent += sCost[key] - sUnspent[key]
				elif key == "h" && a != Global.currSsnTab.seasonName:
					get_node("Seasonal Spirits/"+a+"/Titles/h "+s).text = str(sUnspent[key]+sUnspent["sh"])
					curr_spent += sCost[key] - sUnspent[key]
					curr_spent += sCost["sh"] - sUnspent["sh"]
				elif key == "c" && a == Global.currSsnTab.seasonName:
					get_node("Seasonal Spirits/"+a+"/Titles/a "+s).text = str(sUnspent[key])
					curr_spent += sCost[key] - sUnspent[key]
				elif key == "a" && a == Global.currSsnTab.seasonName: continue
				elif not key.contains("2") && not key.contains("s"):
					get_node("Seasonal Spirits/"+a+"/Titles/"+key+" "+s).text = str(sUnspent[key])
					curr_spent += sCost[key] - sUnspent[key]
				elif SeasonSpirits.data[s].has("t2"):
					asc_spent += sCost[key] - sUnspent[key]
					get_node("Seasonal Spirits/"+a+"/Titles/"+key.replace("2","")+" "+s+" T2").text = str(sUnspent[key])
			else:
				costsNeeded[key] += sCost[key]
				if key == "sp" && a == Global.currSsnTab.seasonName: get_node("Seasonal Spirits/"+a+"/Titles/c "+s).text = str(sCost[key])
				elif key == "sp": get_node("Seasonal Spirits/"+a+"/Titles/c "+s).text = str(sCost[key]+sCost["c"])
				elif key == "sh" && a == Global.currSsnTab.seasonName: get_node("Seasonal Spirits/"+a+"/Titles/h "+s).text = str(sCost[key])
				elif key == "sh": get_node("Seasonal Spirits/"+a+"/Titles/h "+s).text = str(sCost[key]+sCost["h"])
				elif key == "c" && a == Global.currSsnTab.seasonName: get_node("Seasonal Spirits/"+a+"/Titles/a "+s).text = str(sCost[key])
				elif key == "a" && a == Global.currSsnTab.seasonName: continue
				elif not key.contains("2") && not key.contains("s"): get_node("Seasonal Spirits/"+a+"/Titles/"+key+" "+s).text = str(sCost[key])
				elif SeasonSpirits.data[s].has("t2"): get_node("Seasonal Spirits/"+a+"/Titles/"+key.replace("2","")+" "+s+" T2").text = str(sCost[key])
		if currency != 0: get_node("Seasonal Spirits/"+a+"/Titles/By Currency "+s).text = str(floor(curr_spent*100.0/currency))+"%"
		var start = get_node("Seasonal Spirits/"+a+"/Titles/Spirit "+s).get_index()
		if get_node("Seasonal Spirits/"+a+"/Titles/By Currency "+s).text == "100%" && get_node("Seasonal Spirits/"+a+"/Titles/By Purchase "+s).text == "100%":
			for i in range(start,start+6):
				get_node("Seasonal Spirits/"+a+"/Titles").get_child(i).set_modulate(Color(0.75,1,0.75))
		else:
			for i in range(start,start+6):
				get_node("Seasonal Spirits/"+a+"/Titles").get_child(i).set_modulate(Color(1,1,1))
		if SeasonSpirits.data[s].has("t2"):
			start = get_node("Seasonal Spirits/"+a+"/Titles/Spirit "+s+" T2").get_index()
			get_node("Seasonal Spirits/"+a+"/Titles/By Currency "+s+" T2").text = str(floor(asc_spent*100.0/asc))+"%"
			var color = Color(0.75,1,0.75) if get_node("Seasonal Spirits/"+a+"/Titles/By Currency "+s+" T2").text == "100%" else Color(1,0.75,0.75)
			for i in range(start,start+6):
				get_node("Seasonal Spirits/"+a+"/Titles").get_child(i).set_modulate(color)
	
	# Event info
	if not Global.yrlyTab.is_node_ready(): await Global.yrlyTab.ready
	for s in Global.yrlyTab.short.keys():
		var row = $"Yearly Events/Titles".get_node("Event "+s).get_index()
		$"Yearly Events/Titles".get_child(row).text = s
		var cost = SpiritUtils.get_cost(Global.yrlyTab.rows,s)
		$"Yearly Events/Titles".get_child(row+4).text = "0%"
		$"Yearly Events/Titles".get_child(row+5).text = "0%"
		var total = cost["c"] + cost["h"] + cost["k"]
		if Global.yrlyTab.bought.has(s):
			$"Yearly Events/Titles".get_child(row+5).text = str(SpiritUtils.get_completion(Global.yrlyTab.rows,s,Global.yrlyTab.bought[s]))+"%"
			var unspent = SpiritUtils.get_unspent(Global.yrlyTab.rows,s,Global.yrlyTab.bought[s])
			$"Yearly Events/Titles".get_child(row+1).text = str(unspent["c"])
			$"Yearly Events/Titles".get_child(row+2).text = str(unspent["h"])
			$"Yearly Events/Titles".get_child(row+3).text = str(unspent["k"])
			var left = total - unspent["c"] - unspent["h"] - unspent["k"]
			$"Yearly Events/Titles".get_child(row+4).text = str(floor(left*100.0/total))+"%"
		else:
			$"Yearly Events/Titles".get_child(row+1).text = str(cost["c"])
			$"Yearly Events/Titles".get_child(row+2).text = str(cost["h"])
			$"Yearly Events/Titles".get_child(row+3).text = str(cost["k"])
		var color = Color(0.75,1,0.75) if $"Yearly Events/Titles".get_child(row+4).text == "100%" && $"Yearly Events/Titles".get_child(row+5).text == "100%" else Color(1,1,1)
		for i in range(row,row+6):
			$"Yearly Events/Titles".get_child(i).set_modulate(color)
	
	# Winged Light
	var light_areas = areas.duplicate()
	light_areas.append_array(["Eye of Eden","Shattered Memories"])
	var light_coll = 0
	var light_avail = 0
	for a in light_areas:
		var check = Global.wlTab.get_checked(a)
		var uncheck = Global.wlTab.get_unchecked(a)
		light_coll += check
		light_avail += uncheck
		$"Winged Light/Grid".get_node(a+" Coll").text = str(check)
		$"Winged Light/Grid".get_node(a+" Avail").text = str(uncheck)
	$"Winged Light/Grid".get_node("Total Coll").text = str(light_coll)
	$"Winged Light/Grid".get_node("Total Avail").text = str(light_avail)
	var reg_t2 = RegSpirits.get_t2_wings(Global.regSprtTab.bought)
	var reg_t2_avail = RegSpirits.get_all_t2_wings() - reg_t2
	var reg_coll = RegSpirits.get_wings(Global.regSprtTab.bought) - reg_t2
	var reg_avail = RegSpirits.get_all_wings() - reg_coll - reg_t2_avail - reg_t2
	$"Winged Light/Grid".get_node("Regular Coll").text = str(reg_coll)
	$"Winged Light/Grid".get_node("Regular Avail").text = str(reg_avail)
	$"Winged Light/Grid".get_node("Tier2 Coll").text = str(reg_t2)
	$"Winged Light/Grid".get_node("Tier2 Avail").text = str(reg_t2_avail)
	var seas_t2 = SeasonSpirits.get_t2_wings(Global.ssnlSprtTab.bought)
	var seas_t2_avail = SeasonSpirits.get_all_t2_wings() - seas_t2
	var seas_coll = SeasonSpirits.get_wings(Global.ssnlSprtTab.bought) - seas_t2
	var seas_avail = SeasonSpirits.get_all_wings() - seas_coll - seas_t2_avail - seas_t2
	$"Winged Light/Grid".get_node("Seasonal Coll").text = str(seas_coll)
	$"Winged Light/Grid".get_node("Seasonal Avail").text = str(seas_avail)
	$"Winged Light/Grid".get_node("SeasTier2 Coll").text = str(seas_t2)
	$"Winged Light/Grid".get_node("SeasTier2 Avail").text = str(seas_t2_avail)
	$"Winged Light/Grid".get_node("Total Coll2").text = str(light_coll + reg_coll + reg_t2 + seas_coll + seas_t2)
	$"Winged Light/Grid".get_node("Total Avail2").text = str(light_avail + reg_avail + seas_avail + reg_t2_avail + seas_t2_avail)
	var w = 0
	while light_coll + reg_coll + seas_coll >= wedges[w]: w += 1
	$"Winged Light/Wings".text = "You should have "+str(w)+" cape wedges."

func accordion(parent,expand):
	for c in parent.get_children():
		if not c is collapsible: continue
		if c.get_node("Margin/Title/Label").text == ("v" if expand else "^"):
			c.get_node("Margin/Title").set_pressed(not expand)
