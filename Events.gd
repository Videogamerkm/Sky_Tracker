extends VBoxContainer

const day = "Sky Anniversary"
const location = "Aviary Village"
const tpd = 5
const start = {"day":12,"month":7,"year":2024,"hour":17}
const end = {"day":26,"month":7,"year":2024,"hour":23,"minute":59}
const short = {"Days of Fortune":"fortune","Days of Love":"love","Days of Bloom":"bloom","Days of Nature":"nature",
	"Days of Color":"color","Days of Music":"music","Sky Anniversary":"anni","Days of Sunlight":"sun","Days of Style":"style",
	"Days of Mischief":"mischief","Days of Feast":"feast","Tournament of Triumph":"triumph","Sky x Cinnamoroll":"cinna"}
const left = " day(s) left in the event"
var selected = ""
var bought = {}
var planned = {}
@onready var rows = JSON.parse_string(FileAccess.open("res://data/Days.json", FileAccess.READ).get_as_text())

func _ready():
	$Tree/Org1/Controls/Back.hide()
	for c in $Events/Events.get_children():
		if not c is Button: continue
		c.connect("pressed", _press_event_button.bind(c))
	set_fields()

func set_fields():
	if TimeUtils.get_time_until(end) < 0 or TimeUtils.get_time_until(start) > 0:
		$No.show()
		$Time.hide()
		$Days.hide()
		$"Per Day".hide()
	else:
		find_child(short[day]).set_pressed(true)
		_press_event_button.call_deferred(find_child(short[day]))
		find_child(short[day]).add_theme_stylebox_override("normal",$active.get_theme_stylebox("normal"))
		find_child(short[day]).add_theme_stylebox_override("hover",$active.get_theme_stylebox("hover"))
		find_child(short[day]).add_theme_stylebox_override("pressed",$active.get_theme_stylebox("pressed"))
		$No.hide()
		$Time.show()
		$Days.show()
		$"Per Day".text = "Tickets collectable per day: "+str(tpd)
		$"Per Day".show()
		$Time/Start.text = TimeUtils.convert_time(start)
		$Time/End.text = TimeUtils.convert_time(end)
		var days = floor(TimeUtils.get_time_until(end)/86400.0)
		$Days.text = str(days) + left

func _process(_delta):
	if TimeUtils.get_time_until(end) >= 0 && TimeUtils.get_time_until(start) <= 0 && not $Days.text == str(floor(TimeUtils.get_time_until(end)/86400.0)) + left:
		set_fields()

func _press_event_button(node):
	var event = node.name
	var d = short.find_key(str(event))
	selected = d
	for c in $Events/Events.get_children():
		if not c is Button: continue
		c.set_pressed_no_signal(false)
	node.set_pressed_no_signal(true)
	$Tree.set_tree(rows[d],event)
	if bought.has(d): $Tree.import_bought(bought[d])
	if planned.has(d): $Tree.set_planned(planned[d])
	if not $Tree.is_visible_in_tree(): $Tree.show()

func _on_tree_bought(iconValue,press):
	bought[selected] = $Tree.export_bought()
	# Pass to DB
	Global.main.update_cos(iconValue,press)

static func get_location_override() -> String:
	if TimeUtils.get_time_until(end) < 0 or TimeUtils.get_time_until(start) > 0: return ""
	else: return location

func _on_clear():
	bought.erase(selected)
	if planned.has(selected): planned.erase(selected)
	$Tree.set_tree(rows[selected],short[selected])

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
