extends VBoxContainer

var spirits = preload("res://SeasonSpirits.gd")
@onready var spiritIcon = $"Spirits 1/Button".duplicate()
@onready var seasonIcon = $"Season Selection/Button".duplicate()
var curr_spirit = ""
var loc = ""
var bought = {}

func _ready():
	for c in $"Season Selection".get_children(): $"Season Selection".remove_child(c)
	for s in spirits.seasons:
		var season = seasonIcon.duplicate()
		season.set_button_icon(load("icons/seas/icons/"+s.replace("Season of ","")+".bmp"))
		season.connect("pressed",_area_select.bind(s))
		$"Season Selection".add_child(season)
	setup()

func setup():
	_area_select($"../../../Current Season/Margin/VBox".seasonName)

func _area_select(area):
	for c in $"Spirits 1".get_children(): $"Spirits 1".remove_child(c)
	for c in $"Spirits 2".get_children(): $"Spirits 2".remove_child(c)
	var c = 0
	for s in spirits.data:
		if spirits.data[s]["loc"] == area:
			var sp = spiritIcon.duplicate()
			sp.text = s.replace(" ","\n")
			sp.connect("pressed",_spirit_select.bind(s))
			sp.set_button_icon(load("icons/"+spirits.data[s]["tree"][-1][1].split(";")[0]+".bmp"))
			if c < 4: $"Spirits 1".add_child(sp)
			else: $"Spirits 2".add_child(sp)
			c += 1
	loc = area

func _spirit_select(spirit):
	curr_spirit = spirit
	$Tree.set_tree(spirits.data[spirit]["tree"])
	if bought.has(spirit): $Tree.import_bought(bought[spirit])
	$Tree.show()
	$Back.show()
	$"Spirits 1".hide()
	$"Spirits 2".hide()
	$"Season Selection".hide()

func _on_back_pressed():
	curr_spirit = ""
	$Tree.hide()
	$Back.hide()
	$"Spirits 1".show()
	$"Spirits 2".show()
	$"Season Selection".show()

func _on_tree_bought():
	bought[curr_spirit] = $Tree.export_bought()

func _on_clear_pressed():
	$Confirm.show()

func _on_confirm_confirmed():
	if curr_spirit == "":
		for s in spirits.data:
			if spirits.data[s]["loc"] == loc && bought.has(s):
				bought.erase(s)
	else:
		bought.erase(curr_spirit)
		$Tree.set_tree(spirits.data[curr_spirit]["tree"])
