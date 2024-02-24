extends Button

@export var type = "a"
@export var cost = 10
@export var isSP = false

func _ready():
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
	elif type == "0":
		$Curr.hide()
		$Cost.hide()
	$Cost.text = str(cost)
	if isSP: $SP.show()

func _on_toggled(button_pressed):
	if button_pressed:
		$Curr.hide()
		$Cost.hide()
	elif type != "0":
		$Curr.show()
		$Cost.show()
