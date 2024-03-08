extends Control

var saveFile = "user://save.dat"
var cosmetics = []

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
	file.store_var($"Tabs/Days Of/Margin/VBox/VBox".bought)
	file.store_var($Tabs/Settings/Margin/VBox.use_short)
	file.store_var(cosmetics)
	file.store_var(Global.spoilers)
	file.close()

func _on_tree_entered():
	if not FileAccess.file_exists(saveFile): return
	var file = FileAccess.open(saveFile, FileAccess.READ)
	if not $"Tabs/Regular Spirits/Margin/VBox".is_node_ready(): await $"Tabs/Regular Spirits/Margin/VBox".ready
	$"Tabs/Regular Spirits/Margin/VBox".bought = file.get_var()
	$"Tabs/Current Season/Margin/VBox/Pass/Check".set_pressed(file.get_var())
	$"Tabs/Current Season/Margin/VBox/Have/Candles".value = file.get_var()
	if file.get_position() < file.get_length(): $"Tabs/Seasonal Spirits/Margin/VBox".bought = file.get_var()
	if file.get_position() < file.get_length(): $"Tabs/Winged Light Tracker/Margin/VBox".import_checked(file.get_var())
	if not $"Tabs/Days Of/Margin/VBox/VBox".is_node_ready(): await $"Tabs/Days Of/Margin/VBox/VBox".ready
	if file.get_position() < file.get_length(): $"Tabs/Days Of/Margin/VBox/VBox".bought = file.get_var()
	if file.get_position() < file.get_length(): $Tabs/Settings/Margin/VBox.use_short = file.get_var()
	if file.get_position() < file.get_length(): cosmetics = file.get_var()
	if file.get_position() < file.get_length(): Global.spoilers = file.get_var()
	$"Tabs/Seasonal Spirits/Margin/VBox".bought.erase("")
	if cosmetics == []:
		for s in $"Tabs/Seasonal Spirits/Margin/VBox".bought:
			fix_old(s)
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
	$Tabs/Settings/Margin/VBox/CheckButton2.set_pressed_no_signal(Global.spoilers)
	$Tabs/Stats/Stats/VBox.set_values()
	$"Tabs/Days Of/Margin/VBox/VBox".import()

func fix_old(s):
	var seas = $"Tabs/Seasonal Spirits/Margin/VBox"
	seas.curr_spirit = s
	seas.get_node("Tree").set_tree(SeasonSpirits.data[s]["tree"])
	seas.get_node("Tree").import_bought(seas.bought[s])
	seas.curr_spirit = ""

func _on_tabs_tab_changed(tab):
	var reg = $"Tabs/Regular Spirits/Margin/VBox"
	var seas = $"Tabs/Seasonal Spirits/Margin/VBox"
	var days = $"Tabs/Days Of/Margin/VBox"
	if tab == 0: $Tabs/Stats/Stats/VBox.set_values()
	if tab == 1 && reg.curr_spirit != "": reg._on_back_pressed()
	elif tab == 1: reg._area_select(reg.get_node("Area").text)
	if tab == 2: $"Tabs/Current Season/Margin/VBox"._ready()
	if tab == 3 && seas.curr_spirit != "": seas._on_back_pressed()
#	if tab == 6 && days.current != "": days._on_back_pressed()

func _input(event):
	if event.is_action_pressed("Rainbow") && not $AnimationPlayer.is_playing():
		$AnimationPlayer.play("rainbow")
		get_tree().root.set_input_as_handled()
	elif event.is_action_pressed("Rainbow"):
		$AnimationPlayer.play("RESET")
		get_tree().root.set_input_as_handled()

func update_cos(value,add):
	if value == "" or (value.begins_with("base/") and not value.contains("?")): return
	if add and not cosmetics.has(value):
		if value.contains("?"):
			var split = value.split("?")[0]
			if cosmetics.has(split): cosmetics.erase(split)
		cosmetics.append(value)
	elif not add and cosmetics.has(value): cosmetics.erase(value)
