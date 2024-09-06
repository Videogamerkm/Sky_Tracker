extends VBoxContainer

func _ready():
	for c in get_children():
		if c == $Main: continue
		c.get_node("Check All/Check All").connect("pressed",check_section.bind(c))
		c.get_node("Check All/Uncheck All").connect("pressed",uncheck_section.bind(c))
		for a in c.get_children():
			for b in get_all_chk_btns(a):
				b.connect("toggled",check.bind(b.get_index(),c.name+"/"+a.name))
		if Global.collapse: _on_collapse_pressed()

func check(button_pressed,num,sect):
	if button_pressed:
		for b in range(0,num):
			get_node(sect+"/CB").get_child(b).set_pressed_no_signal(true)
	else:
		for b in get_all_chk_btns(get_node(sect)):
			if b.get_index() > num:
				b.set_pressed_no_signal(false)

func check_section(section):
	for c in get_all_chk_btns(section):
		c.set_pressed(true)

func uncheck_section(section):
	for c in get_all_chk_btns(section):
		if c == $"Eye of Eden/Orbit/CB/CheckBox": continue
		c.set_pressed(false)

func _on_expand_pressed():
	for c in get_children():
		if c == $Main: continue
		if c.get_node("Margin/Title/Label").text == "v": c.get_node("Margin/Title").set_pressed(false)

func _on_collapse_pressed():
	for c in get_children():
		if c == $Main: continue
		if c.get_node("Margin/Title/Label").text == "^": c.get_node("Margin/Title").set_pressed(true)

func _on_check_pressed():
	for c in get_all_chk_btns(self):
		c.set_pressed(true)

func _on_uncheck_pressed():
	for c in get_all_chk_btns(self):
		if c == $"Eye of Eden/Orbit/CB/CheckBox": continue
		c.set_pressed(false)

func get_checked(area) -> int:
	var i = 0
	for c in get_all_chk_btns(get_node(area)):
		if c.is_pressed(): i += 1
	return i

func get_unchecked(area) -> int:
	var i = 0
	for c in get_all_chk_btns(get_node(area)):
		if not c.is_pressed(): i += 1
	return i

func export_checked() -> Dictionary:
	var dict = {}
	for c in get_all_chk_btns(self):
		var area = c.get_parent().get_parent().get_parent().name
		var sect = c.get_parent().get_parent().name
		if dict.has(area+"/"+sect): dict[area+"/"+sect].append(c.is_pressed())
		else: dict[area+"/"+sect] = [c.is_pressed()]
	return dict

func import_checked(map):
	for entry in map:
		if entry.ends_with("/Title"): continue
		var checks = map[entry]
		for cb in get_all_chk_btns(get_node(entry)):
			if checks.size() > 0: cb.set_pressed(checks.pop_front())

func get_all_chk_btns(in_node, children_acc = []):
	if in_node is CheckBox:
		children_acc.push_back(in_node)
	for child in in_node.get_children():
		children_acc = get_all_chk_btns(child, children_acc)
	return children_acc
