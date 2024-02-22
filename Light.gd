extends VBoxContainer

func _ready():
	for c in get_children():
		if c == $Main: continue
		c.get_node("Check All/Check All").connect("pressed",check_section.bind(c))
		c.get_node("Check All/Uncheck All").connect("pressed",uncheck_section.bind(c))

func check_section(section):
	for c in section.get_children():
		if c.name == "Check All": continue
		if c.name == "Margin": continue
		for cb in c.get_children():
			if cb is Label: continue
			cb.set_pressed(true)

func uncheck_section(section):
	for c in section.get_children():
		if c.name == "Check All": continue
		if c.name == "Margin": continue
		for cb in c.get_children():
			if cb is Label: continue
			if cb == $"Eye of Eden/Orbit/CheckBox": continue
			cb.set_pressed(false)

func _on_expand_pressed():
	for c in get_children():
		if c == $Main: continue
		if c.get_node("Margin/Title/Label").text == "v": c.get_node("Margin/Title").set_pressed(false)

func _on_collapse_pressed():
	for c in get_children():
		if c == $Main: continue
		if c.get_node("Margin/Title/Label").text == "^": c.get_node("Margin/Title").set_pressed(true)

func _on_check_pressed():
	for c in get_children():
		if c == $Main: continue
		for a in c.get_children():
			if a.name == "Margin": continue
			for cb in a.get_children():
				if cb is Label: continue
				cb.set_pressed(true)

func _on_uncheck_pressed():
	for c in get_children():
		if c == $Main: continue
		for a in c.get_children():
			if a.name == "Margin": continue
			for cb in a.get_children():
				if cb is Label: continue
				if cb == $"Eye of Eden/Orbit/CheckBox": continue
				cb.set_pressed(false)

func get_checked(area) -> int:
	var i = 0
	for c in get_node(area).get_children():
		if c.name == "Check All": continue
		if c.name == "Margin": continue
		for cb in c.get_children():
			if cb is Label: continue
			if cb.is_pressed(): i += 1
	return i

func get_unchecked(area) -> int:
	var i = 0
	for c in get_node(area).get_children():
		if c.name == "Check All": continue
		if c.name == "Margin": continue
		for cb in c.get_children():
			if cb is Label: continue
			if not cb.is_pressed(): i += 1
	return i

func export_checked() -> Dictionary:
	var dict = {}
	for c in get_children():
		if c == $Main: continue
		for a in c.get_children():
			if a.name == "Check All": continue
			if a.name == "Margin" || a.name == "Title": continue
			var checks = []
			for cb in a.get_children():
				if cb is Label: continue
				checks.append(cb.is_pressed())
			dict[c.name+"/"+a.name] = checks
	return dict

func import_checked(map):
	for entry in map:
		if entry.ends_with("/Title"): continue
		var checks = map[entry]
		for cb in get_node(entry).get_children():
			if cb is Label: continue
			cb.set_pressed(checks.pop_front())
