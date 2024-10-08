extends Control

var saveFile = "user://save.dat"
var configFile = "user://app.cfg"
var config = ConfigFile.new()
var cosmetics = []
var history = []
var histIndex = -1
var collHist = true
@onready var search = $Tabs/Home/Margin/VBox/Search/Search

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		if Global.saveClose:
			$Saving.show()
			save()
			if Global.wait: await create_tween().tween_interval(1).finished
		get_tree().quit()

func save(backup = true):
	if backup:
		var old = FileAccess.open(saveFile, FileAccess.READ)
		var back = FileAccess.open(saveFile+".bak", FileAccess.WRITE)
		back.store_var(old.get_var())
		old.close()
		back.close()
	var file = FileAccess.open(saveFile, FileAccess.WRITE)
	file.store_var({"V":1.3,
		"Plan":{"days":Global.planTab.days,"cpd":Global.planTab.cpd,"hpd":Global.planTab.hpd,
			"currC":Global.planTab.currCandles,"currH":Global.planTab.currHearts,"currT":Global.planTab.currTicks},
		"Reg":{"bought":Global.regSprtTab.bought,"planned":Global.regSprtTab.planned},
		"Curr":{"pass":Global.currSsnTab.get_node("Pass/Check").is_pressed(),
			"have":Global.currSsnTab.get_node("Have/Candles").value,"daily":Global.currSsnTab.daily},
		"Seas":{"bought":Global.ssnlSprtTab.bought,"planned":Global.ssnlSprtTab.planned},
		"WL":{"check":Global.wlTab.export_checked()},
		"Yearly":{"bought":Global.yrlyTab.bought,"planned":Global.yrlyTab.planned},
		"Challs":{"bought":Global.chlngTab.bought,"planned":Global.chlngTab.planned},
		"Shops":{"bought":Global.shopTab.bought},
		"Other":{"cosmetics": cosmetics}})
	file.close()
	config.set_value("Options","short",Global.setsTab.use_short)
	config.set_value("Options","spoil",Global.spoilers)
	config.set_value("Options","twelve",Global.useTwelve)
	config.set_value("Options","wait",Global.wait)
	config.set_value("Options","saveClose",Global.saveClose)
	config.set_value("Options","noMoney",Global.noMoney)
	config.set_value("Options","noWarn",Global.noWarn)
	config.set_value("Options","collapse",Global.collapse)
	config.save(configFile)

func _on_tree_entered():
	Global.load_tabs()
	var err = config.load(configFile)
	if err == OK:
		saveFile = config.get_value("Current Save","file")
		Global.setsTab.use_short = config.get_value("Options","short",false)
		Global.spoilers = config.get_value("Options","spoil",false)
		Global.useTwelve = config.get_value("Options","twelve",false)
		Global.wait = config.get_value("Options","wait",true)
		Global.saveClose = config.get_value("Options","saveClose",true)
		Global.noMoney = config.get_value("Options","noMoney",false)
		Global.noWarn = config.get_value("Options","noWarn",false)
		Global.collapse = config.get_value("Options","collapse",false)
	else: config.set_value("Current Save","file",saveFile)
	Global.homeTab.get_node("File").text = "Current Save File: "+saveFile
	load_save(saveFile)
	Global.setsTab.set_short()
	Global.setsTab.get_node("Spoilers").set_pressed_no_signal(Global.spoilers)
	Global.setsTab.get_node("Time").set_pressed_no_signal(Global.useTwelve)
	Global.setsTab.get_node("Close").set_pressed_no_signal(Global.saveClose)
	Global.setsTab.get_node("Save").set_pressed_no_signal(Global.wait)
	Global.setsTab.get_node("NoMoney").set_pressed_no_signal(Global.noMoney)
	Global.setsTab.get_node("NoWarn").set_pressed_no_signal(Global.noWarn)
	Global.setsTab.get_node("Collapse").set_pressed_no_signal(Global.collapse)

func load_save(sv):
	if not FileAccess.file_exists(sv):
		sv += ".bak"
		if not FileAccess.file_exists(sv): return
	var file = FileAccess.open(sv, FileAccess.READ)
	var data = file.get_var()
	if not Global.regSprtTab.is_node_ready(): await Global.regSprtTab.ready
	if not data.has("V"):
		load_legacy(sv)
		return
	var V = data["V"]
	Global.planTab.days = data["Plan"]["days"]
	Global.planTab.cpd = data["Plan"]["cpd"]
	Global.planTab.hpd = data["Plan"]["hpd"]
	Global.planTab.currCandles = data["Plan"]["currC"]
	Global.planTab.currHearts = data["Plan"]["currH"]
	Global.planTab.currTicks = data["Plan"]["currT"]
	Global.regSprtTab.bought = data["Reg"]["bought"]
	Global.regSprtTab.planned = data["Reg"]["planned"]
	Global.currSsnTab.get_node("Pass/Check").set_pressed(data["Curr"]["pass"])
	Global.currSsnTab.get_node("Have/Candles").value = data["Curr"]["have"]
	Global.ssnlSprtTab.bought = data["Seas"]["bought"]
	Global.ssnlSprtTab.planned = data["Seas"]["planned"]
	Global.wlTab.import_checked(data["WL"]["check"])
	Global.yrlyTab.bought = data["Yearly"]["bought"]
	Global.yrlyTab.planned = data["Yearly"]["planned"]
	if V > 1.0:
		Global.shopTab.bought = data["Shops"]["bought"]
	if V > 1.1:
		Global.chlngTab.bought = data["Challs"]["bought"]
		Global.chlngTab.planned = data["Challs"]["planned"]
	if V > 1.2:
		Global.currSsnTab.daily = data["Curr"]["daily"]
		if Global.currSsnTab.daily != "": Global.currSsnTab.get_node("Dailies").set_pressed_no_signal(true)
	cosmetics = data["Other"]["cosmetics"]
	if sv.ends_with(".bak"): save(false)

func load_legacy(sv):
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
	if tab == 2: Global.planTab._ready()
	if tab == 3 && Global.regSprtTab.curr_spirit != "": Global.regSprtTab._on_back_pressed()
	elif tab == 3: Global.regSprtTab._area_select(Global.regSprtTab.get_node("Area").text)
	if tab == 4: Global.currSsnTab._ready()
	if tab == 5 && Global.ssnlSprtTab.curr_spirit != "": Global.ssnlSprtTab._on_back_pressed()
	if tab == 7: Global.shrdTab.set_fields()
	if tab == 9: Global.chlngTab.load_tree()
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
	tween.tween_property(Global.homeTab.get_node("SaveLoad/Save"),"modulate",Color.WHITE,2.0).from(Color.GREEN).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

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

func _on_search_text_changed(new_text):
	var list = []
	for c in $Tabs/Home/Margin/VBox/Items/Items.get_children():
		$Tabs/Home/Margin/VBox/Items/Items.remove_child(c)
		c.queue_free()
	list.append_array(RegSpirits.data.keys())
	list.append_array(SeasonSpirits.data.keys())
	list.append_array(Global.yrlyTab.rows.keys())
	for i in list:
		if new_text.to_lower() in i.to_lower():
			var btn = Button.new()
			btn.flat = true
			btn.text = i
			btn.add_theme_color_override("font_color",Color(1,1,1,0.5))
			btn.focus_mode = Control.FOCUS_NONE
			btn.connect("pressed",_on_search_pressed.bind(i))
			$Tabs/Home/Margin/VBox/Items/Items.add_child(btn)
			if i.to_lower().begins_with(new_text.to_lower()):
				$Tabs/Home/Margin/VBox/Items/Items.move_child(btn,0)

func _on_search_pressed(text):
	if text in RegSpirits.data.keys(): # Tab 3
		$Tabs.set_current_tab(3)
		Global.regSprtTab.find_child(RegSpirits.data[text]["loc"]).set_pressed(true)
		Global.regSprtTab._area_select(RegSpirits.data[text]["loc"])
		Global.regSprtTab._spirit_select(text)
	elif text in SeasonSpirits.data.keys(): # Tab 5
		$Tabs.set_current_tab(5)
		Global.ssnlSprtTab.find_child(SeasonSpirits.data[text]["loc"],true,false).set_pressed(true)
		Global.ssnlSprtTab._area_select(SeasonSpirits.data[text]["loc"])
		Global.ssnlSprtTab._spirit_select(text)
	elif text in Global.yrlyTab.rows.keys(): # Tab 8
		Global.yrlyTab._press_event_button(Global.yrlyTab.find_child(Global.yrlyTab.short[text]))
		$Tabs.set_current_tab(8)
	$Tabs/Home/Margin/VBox/Search/Search.clear()
	$Tabs/Home/Margin/VBox/Search/Search.release_focus()
