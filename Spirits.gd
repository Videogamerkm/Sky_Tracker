extends VBoxContainer

@onready var spiritIcon = $"Spirits 1/Button".duplicate()
var curr_spirit = ""
var a = ""
var bought = {}
var planned = {}

func _ready():
	for b in $"Area Selection".get_children():
		b.connect("pressed",_area_select.bind(b.name))
	_area_select("Isle of Dawn")

func _area_select(area):
	$Area.text = area
	a = area
	for c in $"Spirits 1".get_children(): c.queue_free()
	for c in $"Spirits 2".get_children(): c.queue_free()
	var c = 0
	var comp = true
	for s in RegSpirits.data:
		if RegSpirits.data[s]["loc"] == area && not s.begins_with("Elder"):
			comp = comp && bought.has(s) && RegSpirits.get_completion(s,bought[s]) == 100
		if not comp: break
	for s in RegSpirits.data:
		if RegSpirits.data[s]["loc"] == area:
			if s.begins_with("Elder") && not Global.spoilers && not comp:
				continue
			var sp = spiritIcon.duplicate()
			sp.text = s.replace(" ","\n").replace("Elder\nof\nthe\n","Elder of\nthe ")
			sp.connect("pressed",_spirit_select.bind(s))
			var icon = "icons/"+RegSpirits.data[s]["tree"][-1][1].split(";")[0]+".bmp"
			sp.set_button_icon(load(icon))
			if c < 5: $"Spirits 1".add_child(sp)
			else: $"Spirits 2".add_child(sp)
			c += 1

func _spirit_select(spirit):
	curr_spirit = spirit
	$Tree.set_tree(RegSpirits.data[spirit]["tree"])
	if bought.has(spirit): $Tree.import_bought(bought[spirit])
	if planned.has(spirit): $Tree.set_planned(planned[spirit])
	$Tree.show()
	$Clear.hide()
	$Area.set_text(spirit)
	$"Spirits 1".hide()
	$"Spirits 2".hide()
	$"Area Selection".hide()

func _on_back_pressed():
	curr_spirit = ""
	$Tree.hide()
	$Clear.show()
	$Area.set_text(a)
	$"Spirits 1".show()
	$"Spirits 2".show()
	$"Area Selection".show()

func _on_tree_bought(_iconValue,_press):
	bought[curr_spirit] = $Tree.export_bought()
	# No need to pass on value, these trees are static

func _on_clear_pressed():
	if Global.noWarn: _on_clear()
	else: $Confirm.show()

func _on_clear():
	if curr_spirit == "":
		for s in RegSpirits.data:
			if RegSpirits.data[s]["loc"] == $Area.text && bought.has(s):
				bought.erase(s)
				if planned.has(s): planned.erase(s)
	else:
		bought.erase(curr_spirit)
		if planned.has(curr_spirit): planned.erase(curr_spirit)
		$Tree.set_tree(RegSpirits.data[curr_spirit]["tree"])

func _input(event):
	if event.is_action_pressed("Back") && curr_spirit != "":
		_on_back_pressed()
		get_tree().root.set_input_as_handled()

func _on_tree_planned():
	planned[curr_spirit] = $Tree.get_planned()

func _on_tree_plan_clear():
	if planned.has(curr_spirit): planned.erase(curr_spirit)
