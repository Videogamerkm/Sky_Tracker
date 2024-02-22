extends VBoxContainer

var spirits = preload("res://RegSpirits.gd")
@onready var spiritIcon = $"Spirits 1/Button".duplicate()
var curr_spirit = ""
var bought = {}

func _ready():
	for b in $"Area Selection".get_children():
		b.connect("pressed",_area_select.bind(b.name))
	setup()

func setup():
	_area_select("Isle of Dawn")

func _area_select(area):
	$Area.text = area
	for c in $"Spirits 1".get_children(): $"Spirits 1".remove_child(c)
	for c in $"Spirits 2".get_children(): $"Spirits 2".remove_child(c)
	var c = 0
	for s in spirits.data:
		if spirits.data[s]["loc"] == area:
			var sp = spiritIcon.duplicate()
			sp.text = s.replace(" ","\n").replace("Elder\nof\nthe\n","Elder of\nthe ")
			sp.connect("pressed",_spirit_select.bind(s))
			sp.set_button_icon(load("icons/"+spirits.data[s]["tree"][-1][1].split(";")[0]+".bmp"))
			if c < 5: $"Spirits 1".add_child(sp)
			else: $"Spirits 2".add_child(sp)
			c += 1

func _spirit_select(spirit):
	curr_spirit = spirit
	$Tree.set_tree(spirits.data[spirit]["tree"])
	if bought.has(spirit): $Tree.import_bought(bought[spirit])
	$Tree.show()
	$Back.show()
	$Area.add_theme_color_override("font_color",Color(1,1,1,0))
	$"Spirits 1".hide()
	$"Spirits 2".hide()
	$"Area Selection".hide()

func _on_back_pressed():
	curr_spirit = ""
	$Tree.hide()
	$Back.hide()
	$Area.remove_theme_color_override("font_color")
	$"Spirits 1".show()
	$"Spirits 2".show()
	$"Area Selection".show()

func _on_tree_bought():
	bought[curr_spirit] = $Tree.export_bought()

func _on_clear_pressed():
	$Confirm.show()

func _on_confirm_confirmed():
	if curr_spirit == "":
		for s in spirits.data:
			if spirits.data[s]["loc"] == $Area.text && bought.has(s):
				bought.erase(s)
	else:
		bought.erase(curr_spirit)
		$Tree.set_tree(spirits.data[curr_spirit]["tree"])
