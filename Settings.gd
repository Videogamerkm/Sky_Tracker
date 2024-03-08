extends VBoxContainer

var use_short = false

func _on_check_button_toggled(button_pressed):
	use_short = button_pressed
	set_short()

func set_short():
	var tabNames = []
	if use_short:
		tabNames = ["Reg","C.S.","Ssnl","WL","Shrd","Days","Sets","Creds"]
	else:
		tabNames = ["Regular Spirits","Current Season","Seasonal Spirits","Winged Light Tracker"
			,"Shard Eruptions","Days Of","Settings","Credits"]
	for i in range(1,$"../../..".get_tab_count()): $"../../..".set_tab_title(i,tabNames[i-1])
	$CheckButton.set_pressed_no_signal(use_short)

func _on_check_button_2_toggled(button_pressed):
	Global.spoilers = button_pressed
