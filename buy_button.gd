extends Button

@export var iconValue = ""
@export var days = ""
@export var type = "a"
@export var cost = 10
@export var isSP = false
var locked = true
const normal = Color(0.67,0.67,1.00)
const spoiler = Color(0.5,0.5,0.5)
const hide = Color(0,0,0)

func _ready():
	set_locked(locked)
	$Curr.show()
	$Cost.show()
	if type == "c":
		$Curr.set_texture(preload("res://icons/base/candle.bmp"))
	elif type == "h":
		$Curr.set_texture(preload("res://icons/base/heart.bmp"))
	elif type == "a":
		$Curr.set_texture(preload("res://icons/base/ascended.bmp"))
	elif type == "sp":
		$Curr.set_texture(preload("res://icons/base/season_candle.bmp"))
	elif type == "sh":
		$Curr.set_texture(preload("res://icons/base/season_heart.bmp"))
	elif type == "k":
		$Curr.set_texture(load("res://icons/days/"+days+"/ticket.bmp"))
	elif type == "0":
		$Curr.set_texture(preload("res://icons/base/dot.png"))
		$Cost.hide()
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
	if state && Global.spoilers: add_theme_color_override("icon_normal_color",spoiler)
	elif state: add_theme_color_override("icon_normal_color",hide)
	else: add_theme_color_override("icon_normal_color",normal)
