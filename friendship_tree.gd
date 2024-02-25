extends VBoxContainer

@onready var iconRow = $"Icon Row".duplicate()
@onready var lineRow = $"Line Row".duplicate()

signal bought

func set_tree(rows):
	for c in get_children(): queue_free(c)
	var x = 0
	for r in rows:
		var icons = iconRow.duplicate()
		var lines = lineRow.duplicate()
		for i in range(0,3):
			if r[i] != "":
				var rowSplit = r[i].split(";")
				icons.get_child(i).set_button_icon(load("res://icons/"+rowSplit[0]+".bmp"))
				icons.get_child(i).set_disabled(true)
				icons.get_child(i).set_pressed(false)
				icons.get_child(i).connect("toggled",icon_pressed.bind(icons.get_child(i),x))
				icons.get_child(i).cost = rowSplit[1]
				icons.get_child(i).type = rowSplit[2]
				if rowSplit.size() > 3 && rowSplit[3] == "sp": icons.get_child(i).isSP = true
			else:
				icons.get_child(i).cost = "0"
				icons.get_child(i).type = "0"
				icons.get_child(i).hide()
				lines.get_child(i).hide()
		add_child(icons)
		add_child(lines)
		x += 1
	remove_child(get_child(-1))
	get_child(-1).get_child(1).set_disabled(false)

func icon_pressed(button_pressed,node,row):
	if button_pressed:
		row -= 1
		if row >= 0 && node.name == "Mid":
			for i in range(0,3):
				get_child(row*2).get_child(i).set_disabled(false)
	else:
		if row >= 1 && node.name == "Mid":
			for r in range(0,row):
				for i in range(0,3):
					get_child(r*2).get_child(i).set_disabled(true)
					get_child(r*2).get_child(i).set_pressed(false)
	bought.emit()

func import_bought(vals: Array):
	var c = 0
	for row in vals:
		var r = 0
		for b in row:
			get_child(c).get_child(r).set_pressed(b)
			r += 1
		c += 2

func export_bought() -> Array:
	var ret = []
	var c = 0
	for child in get_children():
		if c % 2 == 0:
			var row = []
			for i in range(0,3): row.append(child.get_child(i).is_pressed())
			ret.append(row)
		c += 1
	return ret

func buy_all() -> Array:
	var ret = []
	var c = 0
	for child in get_children():
		if c % 2 == 0:
			var row = []
			for i in range(0,3):
				if child.get_child(i).is_visible():
					row.append(true)
					child.get_child(i).set_pressed(true)
				else: row.append(false)
			ret.append(row)
		c += 1
	return ret
