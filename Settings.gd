extends VBoxContainer

var use_short = false

func set_short():
	var tabNames = []
	if use_short:
		tabNames = ["Plan","Reg","C.S.","Ssnl","WL","Shrd","Yrly","Sets","Creds"]
	else:
		tabNames = ["Planning","Regular Spirits","Current Season","Seasonal Spirits",
			"Winged Light Tracker","Shard Eruptions","Yearly Events","Settings","Credits"]
	for i in range(2,$"../../..".get_tab_count()): $"../../..".set_tab_title(i,tabNames[i-2])
	$Short.set_pressed_no_signal(use_short)

func _on_short_toggled(button_pressed):
	use_short = button_pressed
	set_short()

func _on_spoilers_toggled(button_pressed):
	Global.spoilers = button_pressed

func _on_time_toggled(button_pressed):
	Global.useTwelve = button_pressed
