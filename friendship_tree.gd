extends VBoxContainer

@onready var iconRow = %Rows/"Icon Row".duplicate()
@onready var lineRow =  %Rows/"Line Row".duplicate()

signal bought(iconValue,press)
signal reject
signal treeBack
signal treeClear

func set_tree(rows,days=""):
	for c in %Rows.get_children():
		%Rows.remove_child(c)
		c.queue_free()
	var x = 0
	for r in rows:
		var icons = iconRow.duplicate()
		var lines = lineRow.duplicate()
		for i in range(0,3):
			if r[i] != "":
				var rowSplit = r[i].split(";")
				icons.get_child(i).iconValue = rowSplit[0]
				icons.get_child(i).cost = rowSplit[1]
				icons.get_child(i).type = rowSplit[2]
				if days != "": icons.get_child(i).days = days
				if rowSplit[0].contains("?"): rowSplit[0] = rowSplit[0].split("?")[0]
				icons.get_child(i).set_button_icon(load("res://icons/"+rowSplit[0]+".bmp"))
				icons.get_child(i).set_pressed(false)
				icons.get_child(i).connect("toggled",icon_pressed.bind(icons.get_child(i),x))
				if rowSplit.size() > 3 && rowSplit[3] == "sp": icons.get_child(i).isSP = true
			else:
				icons.get_child(i).cost = "0"
				icons.get_child(i).type = "0"
				icons.get_child(i).hide()
				lines.get_child(i).hide()
		%Rows.add_child(icons)
		%Rows.add_child(lines)
		x += 1
	custom_minimum_size = Vector2(0,x*100-25)
	%Rows.remove_child(%Rows.get_child(-1))
	%Rows.get_child(-1).get_child(1).set_locked(false)

func icon_pressed(button_pressed,node,row):
	if button_pressed:
		row -= 1
		if row >= 0 && node.name == "Mid":
			for i in range(0,3):
				%Rows.get_child(row*2).get_child(i).set_locked(false)
		if row >= -1 && row < %Rows.get_children().size() / 2.0:
			for r in range(row+2,%Rows.get_children().size()/2.0 + 1):
				%Rows.get_child(r*2).get_child(1).set_locked(false)
				%Rows.get_child(r*2).get_child(1).set_pressed(true)
	else:
		if row >= 1 && node.name == "Mid":
			for r in range(0,row):
				for i in range(0,3):
					%Rows.get_child(r*2).get_child(i).set_locked(true)
					%Rows.get_child(r*2).get_child(i).set_pressed(false)
	bought.emit(node.iconValue,button_pressed)

func import_bought(vals: Array):
	if 2 * vals.size() - 1 != %Rows.get_child_count():
		reject.emit()
		return
	var c = 0
	for row in vals:
		var r = 0
		for b in row:
			if (b and not %Rows.get_child(c).get_child(r).is_visible()) or (b == null and %Rows.get_child(c).get_child(r).is_visible()):
				reject.emit()
				return
			if b != null: %Rows.get_child(c).get_child(r).set_pressed(b)
			r += 1
		c += 2

func export_bought() -> Array:
	var ret = []
	var c = 0
	for child in %Rows.get_children():
		if c % 2 == 0:
			var row = []
			for i in range(0,3):
				if child.get_child(i).is_visible(): row.append(child.get_child(i).is_pressed())
				else: row.append(null)
			ret.append(row)
		c += 1
	return ret

func buy_all() -> Array:
	var ret = []
	var c = 0
	for child in %Rows.get_children():
		if c % 2 == 0:
			var row = []
			for i in range(0,3):
				if child.get_child(i).is_visible():
					row.append(true)
					child.get_child(i).set_pressed(true)
				else: row.append(null)
			ret.append(row)
		c += 1
	return ret

func _on_back_pressed():
	treeBack.emit()

func _on_clear_pressed():
	$Confirm.show()

func _on_confirm_confirmed():
	treeClear.emit()
