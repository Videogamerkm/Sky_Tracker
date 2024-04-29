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

func load_tree():
	$Tree.set_tree(rows[selected]["tree"])
	if bought.has(selected): $Tree.import_bought(bought[selected])

func fill_tree(button_pressed,chlngName):
	if not button_pressed: return
	selected = chlngName
	load_tree()

func _on_tree_bought(iconValue,press):
	bought[selected] = $Tree.export_bought()
	# Pass to DB
	Global.main.update_cos(iconValue,press)

func _on_clear():
	bought.erase(selected)
	planned.erase(selected)
	$Tree.set_tree(rows[selected]["tree"])

func _on_tree_planned():
	planned[selected] = $Tree.get_planned()

func _on_tree_plan_clear():
	planned.erase(selected)
