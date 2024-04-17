extends VBoxContainer

const seasonName = "Season of Nesting"
const start = {"day":15,"month":4,"year":2024,"hour":0} #1705305600
const end = {"day":30,"month":6,"year":2024,"hour":23,"minute":59} #1711954799
const needNoPass = 318
const needPass = 388
const left = " day(s) left in the season"

# Called when the node enters the scene tree for the first time.
func _ready():
	$Time/Start.text = TimeUtils.convert_time(start)
	$Time/End.text = TimeUtils.convert_time(end)
	var days = floor(TimeUtils.get_time_until(end)/86400.0)
	if days < 0:
		$Days.text = "Season ended " + str(abs(days)) + " day(s) ago. See you next season!"
		for c in get_children():
			if c.name != "Banner" and c.name != "Time" and c.name != "Days":
				c.hide()
	elif TimeUtils.get_time_until(start) > 0:
		days = floor(TimeUtils.get_time_until(start)/86400.0)
		$Days.text = "Season starts in " + str(days) + " day(s). See you soon!"
		for c in get_children():
			if c.name != "Banner" and c.name != "Time" and c.name != "Days":
				c.hide()
	else: $Days.text = str(days) + left
	update_candles()
	var candles = days*(6 if $Pass/Check.button_pressed else 5)
	$"Per Day/Val".text = str(6 if $Pass/Check.button_pressed else 5)
	$Candles/Val.text = str(candles)
	$Need/Val.text = str(max((needPass if $Pass/Check.button_pressed else needNoPass) - (int($Spent/Val.text)+$Have/Candles.value),0))
	$Total/Val.text = str(int($Spent/Val.text)+$Have/Candles.value)
	var total = candles + int($Spent/Val.text) + $Have/Candles.value
	$Complete.text = "You have missed too many candles to buy all the cosmetics (or you need to update things)."
	var over = total - (needPass if $Pass/Check.button_pressed else needNoPass)
	if over >= 0:
		var daysSpare = over / (6 if $Pass/Check.button_pressed else 5)
		$Complete.text = "Collecting "+str(6 if $Pass/Check.button_pressed else 5)+" candles per day will give you " + str(over)+" extra candles.\n"
		$Complete.text += "You'll be able to buy all the cosmetics "+str(floor(daysSpare))+" day(s) before the season ends.\n"
		if not $Pass/Check.button_pressed: $Complete.text += "(Note: This does not include season pass items.)"

func _process(_delta):
	if not $Days.text == str(floor(TimeUtils.get_time_until(end)/86400.0)) + left:
		_ready()

func _on_check_toggled(_button_pressed):
	_ready()

func update_candles():
	var bought = Global.ssnlSprtTab.bought
	if not bought: bought = {}
	var candles = 0
	for s in SeasonSpirits.data:
		if SeasonSpirits.data[s]["loc"] == seasonName && bought.has(s):
			candles += SeasonSpirits.get_spent(s,bought[s])
	$Spent/Val.text = str(candles)
