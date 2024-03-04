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
const rows = {"Days of Fortune":[["days/fortune/2;56;c","days/fortune/1;66;c",""],["days/fortune/4;62;c","base/5C;5;c","days/fortune/3;58;c"],
	["days/fortune/5;14;k","base/5C;5;c","days/fortune/6;34;k"],["","base/teleport;0;0",""]],
	"Days of Love":[["days/love/4;15;h","days/love/5;100;c",""],["base/sheet?E3;7;k","base/5C;5;c","days/love/3;15;h"],
	["days/love/1;14;k","base/5C;5;c","days/love/2;27;k"],["","base/teleport;0;0",""]],
	"Days of Bloom":[["days/bloom/2;20;h","days/bloom/1;70;c","days/bloom/3;105;c"],["days/bloom/4;80;c","base/5C;5;c","days/bloom/5;110;c"],
	["","base/5C;5;c",""],["","base/teleport;0;0",""]],
	"Days of Nature":[["days/nature/1;20;h","days/nature/2;180;c",""],["","base/5C;5;c",""],["","base/teleport;0;0",""]],
	"Days of Color":[["days/color/1;175;c","days/color/4;104;k","days/color/3;95;c"],["days/color/2;20;h","base/5C;5;c",""],
	["","base/5C;5;c",""],["","base/teleport;0;0",""]],
	"Days of Music":[["days/music/2;43;k","base/sheet?HH5;5;c",""],["days/music/1;50;c","base/5C;5;c","days/music/3;102;k"],
	["base/sheet?HH3;5;c","base/5C;5;c","base/sheet?HH4;5;c"],["base/sheet?HH1;5;c","base/5C;5;c","base/sheet?HH2;5;c"],["","base/5C;5;c",""]],
	"Sky Anniversary":[["days/anni/3;30;c","days/anni/2;20;h",""],["days/anni/4;20;c","base/5C;5;c","days/anni/5;46;k"],
	["days/anni/1;20;c","base/5C;5;c","days/anni/6;46;k"],["base/sheet?E2;10;h","base/5C;5;c","days/anni/7;8;k"],
	["","base/teleport;0;0",""]],
	"Days of Sunlight":[["days/sun/5;18;k","days/sun/4;23;k",""],["days/sun/3;16;k","base/5C;5;c",""],
	["days/sun/2;90;c","base/5C;5;c","days/sun/1;44;c"],["","base/teleport;0;0",""]],
	"Days of Style":[["days/style/3;14;k","days/style/4;18;k",""],["days/style/2;10;k","base/5C;5;c","days/style/1;8;k"],
	["","base/5C;5;c",""]],
	"Days of Mischief":[["days/mischief/2;66;c","days/mischief/1;33;h","days/mischief/3;99;c"],
	["days/mischief/5;16;k","base/5C;5;c","days/mischief/7;41;k"],["days/mischief/4;44;c","base/5C;5;c","days/mischief/6;24;k"],["","base/5C;5;c",""]],
	"Days of Feast":[["days/feast/2;65;c","days/feast/3;150;c","days/feast/1;15;h"],["days/feast/4;20;h","base/5C;5;c","days/feast/5;50;c"],
	["base/sheet?E1;10;c","base/5C;5;c","days/feast/6;10;c"],["days/feast/8;120;c","base/5C;5;c","days/feast/7;60;c"],
	["days/feast/9;150;c","base/5C;5;c",""],["days/feast/10;44;k","base/5C;5;c","days/feast/11;19;k"],["","base/teleport;0;0",""]]}

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
		if c is Label or (timeUtils.get_time_until(end) >= 0 && c.name == day): continue
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
