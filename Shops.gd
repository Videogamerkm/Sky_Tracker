extends VBoxContainer

const collapsible = preload("res://collapsible.gd")
var bought = {}
@onready var shop = $Shop
@onready var btn = $Btn
@onready var join = $Join
@onready var rows = JSON.parse_string(FileAccess.open("res://data/Shops.json", FileAccess.READ).get_as_text())

func _ready():
	for s in rows:
		var newShop = shop.duplicate()
		newShop.name = s
		newShop.get_node("Desc").text = rows[s]["desc"]
		for i in rows[s]["items"]: newShop.get_node("Purchases").add_child(shop_item(i, s))
		add_child(newShop)
	remove_child(join)
	remove_child(btn)
	remove_child(shop)
	shop.queue_free()
	$Main/Collapse.connect("pressed",accordion.bind(self,false))
	$Main/Expand.connect("pressed",accordion.bind(self,true))
	if Global.collapse: accordion(self,false)
	set_bought()
	toggle_money(Global.noMoney)

func shop_item(i,s) -> Node:
	if i is String:
		return gen_item(s, i)
	elif i is Array:
		var newJoin = join.duplicate()
		var x = 0
		for sub in i:
			var newBtn = gen_item(s, sub)
			newBtn.hideR = true
			newBtn.hideL = true
			if x == 0: newBtn.hideL = false
			elif x == i.size() - 1: newBtn.hideR = false
			x += 1
			newJoin.add_child(newBtn)
		return newJoin
	return null

func gen_item(section, item) -> Panel:
	var newBtn = btn.duplicate()
	var split = item.split(";")
	newBtn.iconValue = split[0]
	newBtn.cost = split[1]
	newBtn.type = split[2]
	newBtn.connect("pressed",item_bought.bind(section,split[0],newBtn))
	return newBtn

func item_bought(press, section, item, node):
	if bought.has(section) and press and not bought[section].has(item): bought[section].append(item)
	elif bought.has(section) and not press and bought[section].has(item): bought[section].erase(item)
	elif not bought.has(section) and press: bought[section] = [item]
	if node.get_parent() is HBoxContainer:
		for c in node.get_parent().get_children():
			if press != c.is_pressed():
				c.set_pressed(press)

func set_bought():
	for s in bought:
		if not has_node(s): continue
		for c in get_node(s+"/Purchases").get_children():
			if c is Panel:
				if bought[s].has(c.iconValue): c.set_pressed(true)
			elif c is HBoxContainer:
				for i in c.get_children():
					if bought[s].has(i.iconValue): i.set_pressed(true)

func toggle_money(toggle):
	for s in rows:
		for c in get_node(s+"/Purchases").get_children():
			if c is Panel and c.type == "$":
				c.toggle_cost(toggle)
			elif c is HBoxContainer:
				for i in c.get_children():
					if i.type == "$":
						i.toggle_cost(toggle)

func accordion(parent,expand):
	for c in parent.get_children():
		if not c is collapsible: continue
		if c.get_node("Margin/Title/Label").text == ("v" if expand else "^"):
			c.get_node("Margin/Title").set_pressed(not expand)
