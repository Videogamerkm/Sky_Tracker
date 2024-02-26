extends VBoxContainer

var use_short = false

func _on_check_button_toggled(button_pressed):
	use_short = button_pressed
	set_short()

func set_short():
	if use_short:
		$"../../..".set_tab_title(1,"Reg")
		$"../../..".set_tab_title(2,"C.S.")
		$"../../..".set_tab_title(3,"Ssnl")
		$"../../..".set_tab_title(4,"WL")
		$"../../..".set_tab_title(5,"Shrd")
		$"../../..".set_tab_title(6,"Days")
		$"../../..".set_tab_title(7,"Sets")
	else:
		$"../../..".set_tab_title(1,"Regular Spirits")
		$"../../..".set_tab_title(2,"Current Season")
		$"../../..".set_tab_title(3,"Seasonal Spirits")
		$"../../..".set_tab_title(4,"Winged Light Tracker")
		$"../../..".set_tab_title(5,"Shard Eruptions")
		$"../../..".set_tab_title(6,"Days Of")
		$"../../..".set_tab_title(7,"Settings")
