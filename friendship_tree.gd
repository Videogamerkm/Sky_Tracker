extends VBoxContainer

@onready var iconRow = %Rows/"Icon Row".duplicate()
@onready var lineRow =  %Rows/"Line Row".duplicate()

signal planned
signal bought(iconValue,press)
signal reject
signal treeBack
signal treeClear
signal planClear

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
				if rowSplit[0].begins_with("|"):
					rowSplit[0] = rowSplit[0].substr(1)
					lines.get_child(i).hide()
					lines.get_child(3+i).show()
				icons.get_child(i).iconValue = rowSplit[0]
				icons.get_child(i).cost = rowSplit[1]
				icons.get_child(i).type = rowSplit[2]
				if days != "": icons.get_child(i).days = days
				if rowSplit[0].contains("?"): rowSplit[0] = rowSplit[0].split("?")[0]
				icons.get_child(i).set_button_icon(load("res://icons/"+rowSplit[0]+(".png" if rowSplit[0] == "base/season_heart" else ".bmp")))
				icons.get_child(i).set_pressed(false)
				icons.get_child(i).connect("toggled",icon_pressed.bind(icons.get_child(i),x))
				icons.get_child(i).connect("planAdded",icon_planned)
				if rowSplit.size() > 3 && rowSplit[3] == "sp": icons.get_child(i).isSP = true
			else:
				icons.get_child(i).cost = "0"
				icons.get_child(i).type = "0"
				icons.get_child(i).hide()
				lines.get_child(i).hide()
		%Rows.add_child(icons)
		%Rows.add_child(lines)
		x += 1
	if days != "": custom_minimum_size = Vector2(0,x*100-25)
	%Rows.remove_child(%Rows.get_child(-1))
	%Rows.get_child(-1).get_child(1).set_locked(false)

func icon_pressed(button_pressed,node,row):
	row = (row - 1) * 2
	if row >= 0:
		if node.name == "Mid":
			if %Rows.get_child(row + 1).get_child(0).is_visible():
				%Rows.get_child(row).get_child(0).set_locked(not button_pressed)
			%Rows.get_child(row).get_child(1).set_locked(not button_pressed)
			if %Rows.get_child(row + 1).get_child(2).is_visible():
				%Rows.get_child(row).get_child(2).set_locked(not button_pressed)
		if node.name == "Left" and not %Rows.get_child(row + 1).get_child(0).is_visible():
			%Rows.get_child(row).get_child(0).set_locked(not button_pressed)
		if node.name == "Right" and not %Rows.get_child(row + 1).get_child(2).is_visible():
			%Rows.get_child(row).get_child(2).set_locked(not button_pressed)
	row += 4
	if button_pressed and row < %Rows.get_children().size():
		var check = 1
		if node.name == "Left": check = 0
		elif node.name == "Right": check = 2
		if %Rows.get_child(row - 1).get_child(check).is_visible():
			%Rows.get_child(row).get_child(1).set_locked(false)
			%Rows.get_child(row).get_child(1).set_pressed(true)
		else:
			%Rows.get_child(row).get_child(check).set_locked(false)
			%Rows.get_child(row).get_child(check).set_pressed(true)
	bought.emit(node.iconValue,button_pressed)

func icon_planned():
	planned.emit()

func get_planned() -> Array:
	var ret = []
	var c = 0
	for child in %Rows.get_children():
		if c % 2 == 0:
			var row = []
			for i in range(0,3):
				if child.get_child(i).is_visible(): row.append(child.get_child(i).planned)
				else: row.append(null)
			ret.append(row)
		c += 1
	return ret

func set_planned(vals: Array):
	var c = 0
	for row in vals:
		var r = 0
		for b in row:
			if b != null: %Rows.get_child(c).get_child(r).planned = b
			r += 1
		c += 2

func import_bought(vals: Array):
	if 2 * vals.size() - 1 != %Rows.get_child_count():
		reject.emit()
		return
	var c = %Rows.get_child_count() - 1
	vals.reverse()
	for row in vals:
		var r = 0
		for b in row:
			if (b and not %Rows.get_child(c).get_child(r).is_visible()) or (b == null and %Rows.get_child(c).get_child(r).is_visible()):
				reject.emit()
				return
			if b != null: %Rows.get_child(c).get_child(r).set_pressed(b)
			r += 1
		c -= 2

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

func _on_clear_plan_pressed():
	var c = 0
	for child in %Rows.get_children():
		if c % 2 == 0:
			for i in range(0,3):
				child.get_child(i).planned = false
		c += 1
	planClear.emit()
