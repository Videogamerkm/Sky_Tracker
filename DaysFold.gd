extends "res://collapsible.gd"

@onready var daysTab = $"../../VBox"
@onready var main = $"../../../../../.."

func _on_confirm_confirmed():
	daysTab.bought.erase(name)
	$Tree.set_tree(daysTab.rows[name],daysTab.short[name])

func _on_clear_pressed():
	$Confirm.show()

func _on_all_pressed():
	$Tree.buy_all()

func _on_tree_bought(iconValue, press):
	daysTab.bought[name] = $Tree.export_bought()
	# Pass to DB
	main.update_cos(iconValue,press)

func _on_tree_reject():
	var newBought = []
	for r in daysTab.rows[name]:
		var row = []
		for i in r:
			if i != "": row.append(main.cosmetics.has(i.split(";")[0]))
			else: row.append(false)
		newBought.append(row)
	daysTab.bought[name] = newBought
	$Tree.import_bought(daysTab.bought[name])
