extends VBoxContainer

@onready var spiritIcon = $"Spirits 1/Button".duplicate()
@onready var seasonIcon = $"Season Selection/Button".duplicate()
var curr_spirit = ""
var a = ""
var bought = {}
var planned = {}

func _ready():
	for c in $"Season Selection".get_children(): c.queue_free()
	for s in SeasonSpirits.seasons:
		var season = seasonIcon.duplicate()
		season.name = s
		season.set_button_icon(load("icons/seas/icons/"+s.replace("Season of ","")+".bmp"))
		season.connect("pressed",_area_select.bind(s))
		$"Season Selection".add_child(season)
	$"Season Selection".get_node(Global.currSsnTab.seasonName).set_pressed(true)
	_area_select(Global.currSsnTab.seasonName)

func _area_select(area):
	$Season.text = area
	a = area
	for c in $"Spirits 1".get_children(): c.queue_free()
	for c in $"Spirits 2".get_children(): c.queue_free()
	var c = 0
	for s in SeasonSpirits.data:
		if SeasonSpirits.data[s]["loc"] == area:
			var sp = spiritIcon.duplicate()
			sp.connect("pressed",_spirit_select.bind(s))
			if SeasonSpirits.data[s].has("isGuide"):
				sp.set_button_icon(load("icons/seas/icons/"+area.replace("Season of ","")+".bmp"))
				sp.text = s
			elif s.contains("of a"):
				sp.text = s.replace(" a "," a\n").replace(" an "," an\n")
				if s.begins_with("Vestige"):
					sp.set_button_icon(load("icons/"+SeasonSpirits.data[s]["tree"][1][0].split(";")[0].split("?")[0]+".bmp"))
				elif s.begins_with("Memory"):
					sp.set_button_icon(load("icons/"+SeasonSpirits.data[s]["tree"][2][0].split(";")[0].split("?")[0]+".bmp"))
				elif s.begins_with("Echo"):
					sp.set_button_icon(load("icons/"+SeasonSpirits.data[s]["tree"][1][0].split(";")[0].split("?")[0]+".bmp"))
				elif s.begins_with("Remnant"):
					sp.set_button_icon(load("icons/"+SeasonSpirits.data[s]["tree"][2][1].split(";")[0].split("?")[0]+".bmp"))
			elif s.contains("Nesting"):
				sp.text = s
				if s.ends_with("Loft"):
					sp.set_button_icon(load("icons/"+SeasonSpirits.data[s]["tree"][-2][0].split(";")[0].split("?")[0]+".bmp"))
				elif s.ends_with("Solarium"):
					sp.set_button_icon(load("icons/"+SeasonSpirits.data[s]["tree"][1][0].split(";")[0].split("?")[0]+".bmp"))
				else:
					sp.set_button_icon(load("icons/"+SeasonSpirits.data[s]["tree"][-1][1].split(";")[0].split("?")[0]+".bmp"))
			elif s.begins_with("The "):
				sp.text = s
				if s.ends_with("list's Beginnings"):
					sp.set_button_icon(load("icons/"+SeasonSpirits.data[s]["tree"][1][1].split(";")[0].split("?")[0]+".bmp"))
				elif s.ends_with("nist's Beginnings") or s.ends_with("Legacy"):
					sp.set_button_icon(load("icons/"+SeasonSpirits.data[s]["tree"][1][0].split(";")[0].split("?")[0]+".bmp"))
				elif s.ends_with("list's Flourishing"):
					sp.set_button_icon(load("icons/"+SeasonSpirits.data[s]["tree"][2][1].split(";")[0].split("?")[0]+".bmp"))
				elif s.ends_with("nist's Flourishing"):
					sp.set_button_icon(load("icons/"+SeasonSpirits.data[s]["tree"][0][0].split(";")[0].split("?")[0]+".bmp"))
			else:
				sp.set_button_icon(load("icons/"+SeasonSpirits.data[s]["tree"][-1][1].split(";")[0].split("?")[0]+".bmp"))
				sp.text = s.replace(" ","\n").replace("Spirit\nof\n","Spirit of ").replace("\nof\n"," of ")\
					.replace("Ancient\n","Ancient ").replace("Shell\n","Shell ").replace("Spin\n","Spin ")\
					.replace("\nLight\n","\nLight ")
			if c < 4: $"Spirits 1".add_child(sp)
			else: $"Spirits 2".add_child(sp)
			c += 1

func _spirit_select(spirit):
	curr_spirit = spirit
	$Tree.set_tree(SeasonSpirits.data[spirit]["tree"])
	if bought.has(spirit): $Tree.import_bought(bought[spirit])
	if planned.has(spirit): $Tree.set_planned(planned[spirit])
	$Tree.show()
	$Clear.hide()
	$Season.set_text(spirit)
	$"Spirits 1".hide()
	$"Spirits 2".hide()
	$"Season Selection".hide()

func _on_back_pressed():
	curr_spirit = ""
	$Tree.hide()
	$Clear.show()
	$Season.set_text(a)
	$"Spirits 1".show()
	$"Spirits 2".show()
	$"Season Selection".show()

func _on_tree_bought(iconValue,press):
	bought[curr_spirit] = $Tree.export_bought()
	# Pass that value into a DB
	if iconValue.begins_with("|"): iconValue = iconValue.substr(1)
	Global.main.update_cos(iconValue,press)

func _on_clear_pressed():
	$Confirm.show()

func _on_clear():
	if curr_spirit == "":
		for s in SeasonSpirits.data:
			if SeasonSpirits.data[s]["loc"] == $Season.text && bought.has(s):
				bought.erase(s)
				if planned.has(s): planned.erase(s)
	else:
		bought.erase(curr_spirit)
		if planned.has(curr_spirit): planned.erase(curr_spirit)
	$Tree.set_tree(SeasonSpirits.data[curr_spirit]["tree"])

func _on_tree_reject():
	var newBought = []
	for r in SeasonSpirits.data[curr_spirit]["tree"]:
		var row = []
		for i in r:
			var split = i.split(";")[0]
			if split.begins_with("|"): split = split.substr(1)
			if i != "": row.append(Global.main.cosmetics.has(split))
			else: row.append(false)
		newBought.append(row)
	bought[curr_spirit] = newBought
	if planned.has(curr_spirit): planned.erase(curr_spirit)
	$Tree.import_bought(bought[curr_spirit])

func _input(event):
	if event.is_action_pressed("Back") && curr_spirit != "":
		_on_back_pressed()
		get_tree().root.set_input_as_handled()

func _on_tree_planned():
	planned[curr_spirit] = $Tree.get_planned()

func _on_tree_plan_clear():
	if planned.has(curr_spirit): planned.erase(curr_spirit)
