extends VBoxContainer

@export var sub = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Title.text = name
	if sub:
		$Title.add_theme_stylebox_override("normal",preload("res://sub_collapse.tres"))
		$Title.add_theme_stylebox_override("hover",preload("res://sub_collapse.tres"))
		$Title.add_theme_stylebox_override("pressed",preload("res://sub_collapse.tres"))

func _on_collapse_toggled(button_pressed):
	if button_pressed:
		for c in get_children():
			if c == $Title: continue
			else: c.hide()
		$Title/Label.text = "v"
	else:
		for c in get_children():
			if c == $Title: continue
			else: c.show()
		$Title/Label.text = "^"
