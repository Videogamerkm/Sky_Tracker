extends VBoxContainer

const timeUtils = preload("res://TimeUtils.gd")
@onready var main = $"../../../../.."
const day = "Days of Bloom"
const location = "Prairie Peaks"
const short = {"Days of Fortune":"fortune","Days of Love":"love","Days of Bloom":"bloom","Days of Nature":"nature",
	"Days of Color":"color","Days of Music":"music","Sky Anniversary":"anni","Days of Sunlight":"sun","Days of Style":"style",
	"Days of Mischief":"mischief","Days of Feast":"feast"}
const start = {"day":25,"month":3,"year":2024,"hour":0}
const end = {"day":14,"month":4,"year":2024,"hour":23,"minute":59}
const left = " day(s) left in the season"
var bought = {}
@onready var rows = JSON.parse_string(FileAccess.open("res://data/Days.json", FileAccess.READ).get_as_text())

func _ready():
	if timeUtils.get_time_until(end) < 0 or timeUtils.get_time_until(start) > 0:
		for c in get_children(): c.hide()
		$No.show()
	else:
		for c in get_children(): if not c is Window: c.show()
		$"../Past".get_node(day).hide()
		$No.hide()
		$Name.text = day
		$Time/Start.text = timeUtils.convert_time(start)
		$Time/End.text = timeUtils.convert_time(end)
		var days = floor(timeUtils.get_time_until(end)/86400.0)
		$Days.text = str(days) + left
		$Tree.set_tree(rows[day],short[day])

func _process(_delta):
	if timeUtils.get_time_until(end) >= 0 && timeUtils.get_time_until(start) <= 0 && not $Days.text == str(floor(timeUtils.get_time_until(end)/86400.0)) + left:
		_ready()

func _on_tree_bought(iconValue,press):
	bought[day] = $Tree.export_bought()
	# Pass to DB
	main.update_cos(iconValue,press)

func _on_all_pressed():
	$Tree.buy_all()

func import():
	if timeUtils.get_time_until(end) >= 0 && timeUtils.get_time_until(start) <= 0 && bought.has(day):
		$Tree.import_bought(bought[day])
	for c in $"../Past".get_children():
		if not c.is_node_ready(): await c.ready
		if c is Label or (timeUtils.get_time_until(end) >= 0 && timeUtils.get_time_until(start) <= 0 && c.name == day): continue
		if rows.has(c.name): c.get_node("Tree").set_tree(rows[c.name],short[c.name])
		if bought.has(c.name): c.get_node("Tree").import_bought(bought[c.name])

static func get_location_override() -> String:
	if timeUtils.get_time_until(end) < 0 or timeUtils.get_time_until(start) > 0: return ""
	else: return location

func _on_clear_pressed():
	$Confirm.show()

func _on_confirm_confirmed():
	bought.erase(day)
	$Tree.set_tree(rows[day],short[day])

func _on_tree_reject():
	var newBought = []
	for r in rows[day]:
		var row = []
		for i in r:
			if i != "": row.append(main.cosmetics.has(i.split(";")[0]))
			else: row.append(null)
		newBought.append(row)
	bought[day] = newBought
	$Tree.import_bought(bought[day])
