extends Panel

@export var iconValue = ""
@export var days = ""
@export var type = "a"
@export var cost = "10"
@export var hideL = false
@export var hideR = false
var hideCost = false
signal pressed(press)

func _ready():
	$Curr.show()
	$Cost.show()
	$Btn.set_button_icon(load("res://icons/"+iconValue+".bmp"))
	var panel = get_theme_stylebox("panel").duplicate()
	remove_theme_stylebox_override("panel")
	add_theme_stylebox_override("panel",panel)
	panel.set_border_width(SIDE_RIGHT, 0 if hideR else 1)
	panel.set_border_width(SIDE_LEFT, 0 if hideL else 1)
	if type == "c":
		$Curr.set_texture(preload("res://icons/base/candle.bmp"))
	elif type == "h":
		$Curr.set_texture(preload("res://icons/base/heart.bmp"))
	elif type == "a":
		$Curr.set_texture(preload("res://icons/base/ascended.bmp"))
	elif type == "0":
		$Cost.hide()
	if type == "$":
		$Cost.position.x = 3
		$Cost.text = "$"+cost
	else:
		$Cost.position.x = 25
		$Cost.text = cost

func _on_btn_toggled(press):
	if press:
		$Curr.hide()
		$Cost.hide()
	elif type != "0" and not hideCost:
		$Curr.show()
		$Cost.show()
	pressed.emit(press)

func is_pressed():
	return $Btn.is_pressed()

func set_pressed(press):
	$Btn.set_pressed(press)

func toggle_cost(toggle):
	hideCost = toggle
	if hideCost: $Cost.hide()
	elif type != "0": $Cost.show()
