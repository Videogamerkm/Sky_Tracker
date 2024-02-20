extends Control

var saveFile = "user://save.dat"

func _on_tree_exiting():
	var file = FileAccess.open(saveFile, FileAccess.WRITE)
	file.store_var($"Tabs/Regular Spirits/Margin/VBox".bought)
	file.store_var($"Tabs/Current Season/Margin/VBox/Pass/Check".is_pressed())
	file.store_var($"Tabs/Current Season/Margin/VBox/Have/Candles".value)
	file.store_var($"Tabs/Seasonal Spirits/Margin/VBox".bought)
	file.store_var($"Tabs/Winged Light Tracker/Margin/VBox".export_checked())

func _on_tree_entered():
	if not FileAccess.file_exists(saveFile): return
	var file = FileAccess.open(saveFile, FileAccess.READ)
	$"Tabs/Regular Spirits/Margin/VBox".bought = file.get_var()
	$"Tabs/Regular Spirits/Margin/VBox"._ready()
	$"Tabs/Current Season/Margin/VBox/Pass/Check".set_pressed(file.get_var())
	$"Tabs/Current Season/Margin/VBox/Have/Candles".value = file.get_var()
	if file.get_position() < file.get_length(): $"Tabs/Seasonal Spirits/Margin/VBox".bought = file.get_var()
	if file.get_position() < file.get_length(): $"Tabs/Winged Light Tracker/Margin/VBox".import_checked(file.get_var())

func _on_tabs_tab_changed(tab):
	if tab == 0: $Tabs/Stats/Stats/VBox.set_values()
	if tab == 2: $"Tabs/Current Season/Margin/VBox"._ready()
