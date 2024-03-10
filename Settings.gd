extends VBoxContainer

var use_short = false

func set_short():
	var tabNames = []
	if use_short:
		tabNames = ["Reg","C.S.","Ssnl","WL","Shrd","Yrly","Sets","Creds"]
	else:
		tabNames = ["Regular Spirits","Current Season","Seasonal Spirits","Winged Light Tracker"
			,"Shard Eruptions","Yearly Events","Settings","Credits"]
	for i in range(1,$"../../..".get_tab_count()): $"../../..".set_tab_title(i,tabNames[i-1])
	$Short.set_pressed_no_signal(use_short)

func _on_short_toggled(button_pressed):
	use_short = button_pressed
	set_short()

func _on_spoilers_toggled(button_pressed):
	Global.spoilers = button_pressed

func _on_time_toggled(button_pressed):
	Global.useTwelve = button_pressed
