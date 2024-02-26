extends Control

var saveFile = "user://save.dat"

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
	file.store_var($"Tabs/Days Of/Margin/VBox".bought)
	file.store_var($Tabs/Settings/Margin/VBox.use_short)
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
	if not $"Tabs/Days Of/Margin/VBox".is_node_ready(): await $"Tabs/Days Of/Margin/VBox".ready
	if file.get_position() < file.get_length(): $"Tabs/Days Of/Margin/VBox".bought = file.get_var()
	if file.get_position() < file.get_length(): $Tabs/Settings/Margin/VBox.use_short = file.get_var()
	$Tabs/Settings/Margin/VBox.set_short()
	$Tabs/Stats/Stats/VBox.set_values()
	$"Tabs/Days Of/Margin/VBox".import()

func _on_tabs_tab_changed(tab):
	if tab == 0: $Tabs/Stats/Stats/VBox.set_values()
	if tab == 2: $"Tabs/Current Season/Margin/VBox"._ready()

func _input(event):
	if event.is_action_pressed("Rainbow") && not $AnimationPlayer.is_playing():
		$AnimationPlayer.play("rainbow")
		get_tree().root.set_input_as_handled()
	elif event.is_action_pressed("Rainbow"):
		$AnimationPlayer.play("RESET")
		get_tree().root.set_input_as_handled()
