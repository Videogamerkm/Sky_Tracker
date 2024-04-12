extends VBoxContainer

var selected = ""
var bought = {}
var planned = {}
@onready var rows = JSON.parse_string(FileAccess.open("res://data/Nesting Challenges.json", FileAccess.READ).get_as_text())

func _ready():
	for c in $Nav.get_children():
		c.connect("toggled",fill_tree.bind(c.text))
	$Tree/Org1/Controls/Back.hide()
	selected = $Nav.get_child(0).text
	$Tree.set_tree(rows[selected]["tree"])
	

func fill_tree(button_pressed,chlngName):
	if not button_pressed: return
	$Tree.set_tree(rows[chlngName]["tree"])

func _on_tree_bought(iconValue,press):
	bought[selected] = $Tree.export_bought()
	# Pass to DB
	Global.main.update_cos(iconValue,press)

func _on_clear():
	bought.erase(selected)
	if planned.has(selected): planned.erase(selected)
	$Tree.set_tree(rows[selected])

func _on_tree_reject():
	var newBought = []
	for r in rows[selected]:
		var row = []
		for i in r:
			if i != "": row.append(Global.main.cosmetics.has(i.split(";")[0]))
			else: row.append(null)
		newBought.append(row)
	bought[selected] = newBought
	if planned.has(selected): planned.erase(selected)
	$Tree.import_bought(bought[selected])

func _on_tree_planned():
	planned[selected] = $Tree.get_planned()

func _on_tree_plan_clear():
	if planned.has(selected): planned.erase(selected)
