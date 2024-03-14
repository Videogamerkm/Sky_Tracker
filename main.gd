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

func save():
	var file = FileAccess.open(saveFile, FileAccess.WRITE)
	file.store_var($"Tabs/Regular Spirits/Margin/VBox".bought)
	file.store_var($"Tabs/Current Season/Margin/VBox/Pass/Check".is_pressed())
	file.store_var($"Tabs/Current Season/Margin/VBox/Have/Candles".value)
	file.store_var($"Tabs/Seasonal Spirits/Margin/VBox".bought)
	file.store_var($"Tabs/Winged Light Tracker/Margin/VBox".export_checked())
	file.store_var($"Tabs/Yearly Events/Margin/VBox".bought)
	file.store_var($Tabs/Settings/Margin/VBox.use_short)
	file.store_var(cosmetics)
	file.store_var(Global.spoilers)
	file.store_var(Global.useTwelve)
	file.close()

func _on_tree_entered():
	var err = config.load(configFile)
	if err == OK: saveFile = config.get_value("Current Save","file")
	else: config.set_value("Current Save","file",saveFile)
	$Tabs/Home/Stats/VBox/File.text = "Current Save File: "+saveFile
	load_save(saveFile)

func load_save(save):
	if not FileAccess.file_exists(save): return
	var file = FileAccess.open(save, FileAccess.READ)
	if not $"Tabs/Regular Spirits/Margin/VBox".is_node_ready(): await $"Tabs/Regular Spirits/Margin/VBox".ready
	$"Tabs/Regular Spirits/Margin/VBox".bought = file.get_var()
	$"Tabs/Current Season/Margin/VBox/Pass/Check".set_pressed(file.get_var())
	$"Tabs/Current Season/Margin/VBox/Have/Candles".value = file.get_var()
	if file.get_position() < file.get_length(): $"Tabs/Seasonal Spirits/Margin/VBox".bought = file.get_var()
	if file.get_position() < file.get_length(): $"Tabs/Winged Light Tracker/Margin/VBox".import_checked(file.get_var())
	if not $"Tabs/Yearly Events/Margin/VBox".is_node_ready(): await $"Tabs/Yearly Events/Margin/VBox".ready
	if file.get_position() < file.get_length(): $"Tabs/Yearly Events/Margin/VBox".bought = file.get_var()
	if file.get_position() < file.get_length(): $Tabs/Settings/Margin/VBox.use_short = file.get_var()
	if file.get_position() < file.get_length(): cosmetics = file.get_var()
	if file.get_position() < file.get_length(): Global.spoilers = file.get_var()
	if file.get_position() < file.get_length(): Global.useTwelve = file.get_var()
	$"Tabs/Seasonal Spirits/Margin/VBox".bought.erase("")
	if cosmetics == []:
		for s in $"Tabs/Seasonal Spirits/Margin/VBox".bought:
			fix_old(s)
		for s in $"Tabs/Yearly Events/Margin/VBox".bought:
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
	$Tabs/Settings/Margin/VBox.set_short()
	$Tabs/Settings/Margin/VBox/Spoilers.set_pressed_no_signal(Global.spoilers)
	$Tabs/Settings/Margin/VBox/Time.set_pressed_no_signal(Global.useTwelve)
	$Tabs/Stats/Stats/VBox.set_values()

func fix_old(s):
	var seas = $"Tabs/Seasonal Spirits/Margin/VBox"
	seas.curr_spirit = s
	seas.get_node("Tree").set_tree(SeasonSpirits.data[s]["tree"])
	seas.get_node("Tree").import_bought(seas.bought[s])
	seas.curr_spirit = ""

func fix_old_day(s):
	var day = $"Tabs/Yearly Events/Margin/VBox"
	day.selected = s
	day.get_node("Tree").set_tree(day.rows[s])
	day.get_node("Tree").import_bought(day.bought[s])
	day.selected = ""

func _on_tabs_tab_changed(tab):
	var reg = $"Tabs/Regular Spirits/Margin/VBox"
	var seas = $"Tabs/Seasonal Spirits/Margin/VBox"
	if tab == 0: $Tabs/Stats/Stats/VBox.set_values()
	if tab == 1 && reg.curr_spirit != "": reg._on_back_pressed()
	elif tab == 1: reg._area_select(reg.get_node("Area").text)
	if tab == 2: $"Tabs/Current Season/Margin/VBox"._ready()
	if tab == 3 && seas.curr_spirit != "": seas._on_back_pressed()
	if tab == 5: $"Tabs/Shard Eruptions/Margin/VBox".set_fields()
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
	tween.tween_property($Tabs/Home/Stats/VBox/SaveLoad/Save,"modulate",Color(1,1,1),2.0).from(Color(0,1,0)).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

func _on_save_as_pressed():
	$Tabs/Home/Stats/VBox/SaveLoad/SaveDialog.show()

func _on_save_dialog_file_selected(path):
	config.set_value("Current Save","file",path)
	config.save(configFile)
	saveFile = path
	$Tabs/Home/Stats/VBox/File.text = "Current Save File: "+path
	save()

func _on_load_pressed():
	$Tabs/Home/Stats/VBox/SaveLoad/LoadDialog.show()

func _on_load_dialog_file_selected(path):
	config.set_value("Current Save","file",path)
	config.save(configFile)
	saveFile = path
	$Tabs/Home/Stats/VBox/File.text = "Current Save File: "+path
	load_save(path)
