extends Button

@export var iconValue = ""
@export var days = ""
@export var type = "a"
@export var cost = 10
@export var isSP = false
var planned = false:
	set(val):
		planned = val
		for p in panels: panels[p].set_border_width_all(2 if planned else 0)
var locked = true
const normal = Color(0.67,0.67,1.00)
const spoiler = Color(0.5,0.5,0.5)
const hide = Color(0,0,0)
@onready var panels = {}
signal planAdded(isPlanned)

func _ready():
	set_locked(locked)
	if Global.spoilers: add_theme_color_override("icon_disabled_color",Color(0.5,0.5,0.5))
	else: add_theme_color_override("icon_disabled_color",Color(0,0,0))
	for p in ["normal","hover","pressed","disabled"]:
		panels[p] = get_theme_stylebox(p).duplicate()
		remove_theme_stylebox_override(p)
		add_theme_stylebox_override(p,panels[p])
	$Curr.show()
	$Cost.show()
	if type == "c":
		$Curr.set_texture(preload("res://icons/base/candle.bmp"))
	elif type == "h":
		$Curr.set_texture(preload("res://icons/base/heart.bmp"))
	elif type == "a":
		$Curr.set_texture(preload("res://icons/base/ascended.bmp"))
	elif type == "sp":
		$Curr.set_texture(preload("res://icons/base/season_candle.png"))
	elif type == "sh":
		$Curr.set_texture(preload("res://icons/base/season_heart.png"))
	elif type == "k":
		$Curr.set_texture(load("res://icons/days/"+days+"/ticket.bmp"))
	elif type == "0":
		$Curr.set_texture(preload("res://icons/base/dot.png"))
		$Cost.hide()
	if iconValue.contains("exp") and iconValue.contains("?"):
		$Lvl.show()
		$Lvl.set_text(iconValue.split("?")[1])
	$Cost.text = str(cost)
	if isSP: $SP.show()

func _process(_delta):
	if type == "0" && (button_pressed || locked): $Curr.hide()
	elif type == "0": $Curr.show()

func _on_toggled(press):
	if press:
		$Curr.hide()
		$Cost.hide()
	elif type != "0":
		$Curr.show()
		$Cost.show()

func set_locked(state):
	locked = state
	if locked: set_pressed(false)
	if state && Global.spoilers: add_theme_color_override("icon_normal_color",spoiler)
	elif state: add_theme_color_override("icon_normal_color",hide)
	else: add_theme_color_override("icon_normal_color",normal)

func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		planned = not planned
		planAdded.emit()
