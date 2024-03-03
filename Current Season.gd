extends VBoxContainer

var spirits = preload("res://SeasonSpirits.gd")
var timeUtils = preload("res://TimeUtils.gd")
const seasonName = "Season of the Nine-Colored Deer"
const start = {"day":15,"month":1,"year":2024,"hour":0} #1705305600
const end = {"day":31,"month":3,"year":2024,"hour":23,"minute":59} #1711954799
const needNoPass = 354
const needPass = 398
const left = " day(s) left in the season"

# Called when the node enters the scene tree for the first time.
func _ready():
	$Time/Start.text = timeUtils.convert_time(start)
	$Time/End.text = timeUtils.convert_time(end)
	var days = floor(timeUtils.get_time_until(end)/86400.0)
	$Days.text = str(days) + left
	update_candles()
	var candles = days*(6 if $Pass/Check.button_pressed else 5)
	$"Per Day/Val".text = str(6 if $Pass/Check.button_pressed else 5)
	$Candles/Val.text = str(candles)
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
	if not $Days.text == str(floor(timeUtils.get_time_until(end)/86400.0)) + left:
		_ready()

func _on_check_toggled(_button_pressed):
	_ready()

func update_candles():
	var bought = $"../../../Seasonal Spirits/Margin/VBox".bought
	if not bought: bought = {}
	var candles = 0
	for s in spirits.data:
		if spirits.data[s]["loc"] == seasonName && bought.has(s):
			candles += spirits.get_spent(s,bought[s])
	$Spent/Val.text = str(candles)
