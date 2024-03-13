extends VBoxContainer

@onready var spiritIcon = $"Spirits 1/Button".duplicate()
@onready var seasonIcon = $"Season Selection/Button".duplicate()
@onready var main = $"../../../.."
var curr_spirit = ""
var a = ""
var bought = {}

func _ready():
	for c in $"Season Selection".get_children(): c.queue_free()
	for s in SeasonSpirits.seasons:
		var season = seasonIcon.duplicate()
		season.name = s
		season.set_button_icon(load("icons/seas/icons/"+s.replace("Season of ","")+".bmp"))
		season.connect("pressed",_area_select.bind(s))
		$"Season Selection".add_child(season)
	$"Season Selection".get_node($"../../../Current Season/Margin/VBox".seasonName).set_pressed(true)
	_area_select($"../../../Current Season/Margin/VBox".seasonName)

func _area_select(area):
	$Season.text = area
	a = area
	for c in $"Spirits 1".get_children(): c.queue_free()
	for c in $"Spirits 2".get_children(): c.queue_free()
	var c = 0
	for s in SeasonSpirits.data:
		if SeasonSpirits.data[s]["loc"] == area:
			var sp = spiritIcon.duplicate()
			sp.text = s.replace(" ","\n").replace("Spirit\nof\n","Spirit of ")
			sp.connect("pressed",_spirit_select.bind(s))
			sp.set_button_icon(load("icons/"+SeasonSpirits.data[s]["tree"][-1][1].split(";")[0].split("?")[0]+".bmp"))
			if c < 4: $"Spirits 1".add_child(sp)
			else: $"Spirits 2".add_child(sp)
			c += 1

func _spirit_select(spirit):
	curr_spirit = spirit
	$Tree.set_tree(SeasonSpirits.data[spirit]["tree"])
	if bought.has(spirit): $Tree.import_bought(bought[spirit])
	$Tree.show()
	$Clear.hide()
	$Season.set_text(spirit)
	$"Spirits 1".hide()
	$"Spirits 2".hide()
	$"Season Selection".hide()

func _on_back_pressed():
	curr_spirit = ""
	$Tree.hide()
	$Clear.show()
	$Season.set_text(a)
	$"Spirits 1".show()
	$"Spirits 2".show()
	$"Season Selection".show()

func _on_tree_bought(iconValue,press):
	bought[curr_spirit] = $Tree.export_bought()
	# Pass that value into a DB
	main.update_cos(iconValue,press)

func _on_clear_pressed():
	$Confirm.show()

func _on_clear():
	if curr_spirit == "":
		for s in SeasonSpirits.data:
			if SeasonSpirits.data[s]["loc"] == $Season.text && bought.has(s):
				bought.erase(s)
	else:
		bought.erase(curr_spirit)
		$Tree.set_tree(SeasonSpirits.data[curr_spirit]["tree"])

func _on_tree_reject():
	var newBought = []
	for r in SeasonSpirits.data[curr_spirit]["tree"]:
		var row = []
		for i in r:
			if i != "": row.append(main.cosmetics.has(i.split(";")[0]))
			else: row.append(false)
		newBought.append(row)
	bought[curr_spirit] = newBought
	$Tree.import_bought(bought[curr_spirit])

func _input(event):
	if event.is_action_pressed("Back") && curr_spirit != "":
		_on_back_pressed()
		get_tree().root.set_input_as_handled()
