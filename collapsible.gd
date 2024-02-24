extends VBoxContainer

@export var sub = false
@export var collapse = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Margin/Title.text = name
	if collapse: _on_collapse_toggled(true)
	if sub:
		$Margin/Title.add_theme_stylebox_override("normal",preload("res://sub_collapse.tres"))
		$Margin/Title.add_theme_stylebox_override("hover",preload("res://sub_collapse.tres"))
		$Margin/Title.add_theme_stylebox_override("pressed",preload("res://sub_collapse.tres"))
		$Margin.add_theme_constant_override("margin_left",20)
		$Margin.add_theme_constant_override("margin_right",20)

func _on_collapse_toggled(button_pressed):
	if button_pressed:
		for c in get_children():
			if c == $Margin: continue
			else: c.hide()
		$Margin/Title/Label.text = "v"
	else:
		for c in get_children():
			if c == $Margin: continue
			else: c.show()
		$Margin/Title/Label.text = "^"
