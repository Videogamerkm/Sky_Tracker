extends Control

var saveFile = "user://save.dat"
var configFile = "user://app.cfg"
var config = ConfigFile.new()
var cosmetics = []
var history = []
var histIndex = -1
var collHist = true

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save()
		get_tree().quit()

func save(backup = true):
	if backup:
		var old = FileAccess.open(saveFile, FileAccess.READ)
		var back = FileAccess.open(saveFile+".bak", FileAccess.WRITE)
		while(old.get_position() < old.get_length()): back.store_var(old.get_var())
	var file = FileAccess.open(saveFile, FileAccess.WRITE)
	file.store_var(Global.regSprtTab.bought)
	file.store_var(Global.currSsnTab.get_node("Pass/Check").is_pressed())
	file.store_var(Global.currSsnTab.get_node("Have/Candles").value)
	file.store_var(Global.ssnlSprtTab.bought)
	file.store_var(Global.wlTab.export_checked())
	file.store_var(Global.yrlyTab.bought)
	file.store_var(Global.setsTab.use_short)
	file.store_var(cosmetics)
	file.store_var(Global.spoilers)
	file.store_var(Global.useTwelve)
	file.close()

func _on_tree_entered():
	Global.load_tabs()
	var err = config.load(configFile)
	if err == OK: saveFile = config.get_value("Current Save","file")
	else: config.set_value("Current Save","file",saveFile)
	Global.homeTab.get_node("File").text = "Current Save File: "+saveFile
	load_save(saveFile)

func load_save(sv):
	if not FileAccess.file_exists(sv):
		sv += ".bak"
		if not FileAccess.file_exists(sv): return
	var file = FileAccess.open(sv, FileAccess.READ)
	if not Global.regSprtTab.is_node_ready(): await Global.regSprtTab.ready
	Global.regSprtTab.bought = file.get_var()
	Global.currSsnTab.get_node("Pass/Check").set_pressed(file.get_var())
	Global.currSsnTab.get_node("Have/Candles").value = file.get_var()
	if file.get_position() < file.get_length(): Global.ssnlSprtTab.bought = file.get_var()
	if file.get_position() < file.get_length(): Global.wlTab.import_checked(file.get_var())
	if not Global.yrlyTab.is_node_ready(): await Global.yrlyTab.ready
	if file.get_position() < file.get_length(): Global.yrlyTab.bought = file.get_var()
	if file.get_position() < file.get_length(): Global.setsTab.use_short = file.get_var()
	if file.get_position() < file.get_length(): cosmetics = file.get_var()
	if file.get_position() < file.get_length(): Global.spoilers = file.get_var()
	if file.get_position() < file.get_length(): Global.useTwelve = file.get_var()
	Global.ssnlSprtTab.bought.erase("")
	if cosmetics == []:
		for s in Global.ssnlSprtTab.bought:
			fix_old(s)
		for s in Global.yrlyTab.bought:
			fix_old_day(s)
	if cosmetics.has("seas/exp/whistle"): fix_old("Herb Gatherer")
	if cosmetics.has("seas/exp/flex"): fix_old("Hunter")
	if cosmetics.has("seas/exp/cradle"): fix_old("Feudal Lord")
	if cosmetics.has("seas/exp/princess"): fix_old("Princess")
	if cosmetics.has("seas/exp/bearhug"): fix_old("Bearhug Hermit")
	if cosmetics.has("seas/exp/shake"): fix_old("Frantic Stagehand")
	if cosmetics.has("seas/exp/shrug"): fix_old("Indifferent Alchemist")
	if cosmetics.has("seas/exp/nod"): fix_old("Nodding Muralist")
	if cosmetics.has("seas/exp/calm"): fix_old("Ceasing Commodore")
	Global.setsTab.set_short()
	Global.setsTab.get_node("Spoilers").set_pressed_no_signal(Global.spoilers)
	Global.setsTab.get_node("Time").set_pressed_no_signal(Global.useTwelve)
	Global.statsTab.set_values()
	if sv.ends_with(".bak"): save(false)

func fix_old(s):
	Global.ssnlSprtTab.curr_spirit = s
	Global.ssnlSprtTab.get_node("Tree").set_tree(SeasonSpirits.data[s]["tree"])
	Global.ssnlSprtTab.get_node("Tree").import_bought(Global.ssnlSprtTab.bought[s])
	Global.ssnlSprtTab.curr_spirit = ""

func fix_old_day(s):
	Global.yrlyTab.selected = s
	Global.yrlyTab.get_node("Tree").set_tree(Global.yrlyTab.rows[s])
	Global.yrlyTab.get_node("Tree").import_bought(Global.yrlyTab.bought[s])
	Global.yrlyTab.selected = ""

func _on_tabs_tab_changed(tab):
	if tab == 1: Global.statsTab.set_values()
	if tab == 2 && Global.regSprtTab.curr_spirit != "": Global.regSprtTab._on_back_pressed()
	elif tab == 2: Global.regSprtTab._area_select(Global.regSprtTab.get_node("Area").text)
	if tab == 3: Global.currSsnTab._ready()
	if tab == 4 && Global.ssnlSprtTab.curr_spirit != "": Global.ssnlSprtTab._on_back_pressed()
	if tab == 6: Global.shrdTab.set_fields()
	if collHist:
		history.resize(histIndex + 1)
		history.append($Tabs.get_previous_tab())
		histIndex += 1

func _input(event):
	if event.is_action_pressed("Rainbow") && not $AnimationPlayer.is_playing():
		$AnimationPlayer.play("rainbow")
		get_tree().root.set_input_as_handled()
	elif event.is_action_pressed("Rainbow"):
		$AnimationPlayer.play("RESET")
		get_tree().root.set_input_as_handled()
	elif event.is_action_pressed("Back") && history.size() > 0 && histIndex >= 0:
		collHist = false
		$Tabs.set_current_tab(history[histIndex])
		if history.size() - 1 == histIndex: history.append($Tabs.get_previous_tab())
		histIndex -= 1
		collHist = true
		get_tree().root.set_input_as_handled()
	elif event.is_action_pressed("Forward") && histIndex < history.size() - 2:
		collHist = false
		histIndex += 1
		$Tabs.set_current_tab(history[histIndex + 1])
		collHist = true
		get_tree().root.set_input_as_handled()

func update_cos(value,add):
	if value == "" or (value.begins_with("base/") and not value.contains("?")): return
	if add and not cosmetics.has(value):
		if value.contains("?"):
			var split = value.split("?")[0]
			if cosmetics.has(split): cosmetics.erase(split)
		cosmetics.append(value)
	elif not add and cosmetics.has(value): cosmetics.erase(value)

func _on_save_pressed():
	save()
	var tween = create_tween()
	tween.tween_property(Global.homeTab.get_node("SaveLoad/Save"),"modulate",Color(1,1,1),2.0).from(Color(0,1,0)).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

func _on_save_as_pressed():
	Global.homeTab.get_node("SaveLoad/SaveDialog").show()

func _on_save_dialog_file_selected(path):
	config.set_value("Current Save","file",path)
	config.save(configFile)
	saveFile = path
	Global.homeTab.get_node("File").text = "Current Save File: "+path
	save(false)

func _on_load_pressed():
	Global.homeTab.get_node("SaveLoad/LoadDialog").show()

func _on_load_dialog_file_selected(path):
	config.set_value("Current Save","file",path)
	config.save(configFile)
	saveFile = path
	Global.homeTab.get_node("File").text = "Current Save File: "+path
	load_save(path)
