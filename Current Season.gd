extends VBoxContainer

var seasonName = "Season of the Nine-Colored Deer"
var start = 1705305600
var end = 1711958399
var needNoPass = 354
var needPass = 398
const months = ["","January","February","March","April","May","June","July","August","September","October","November","December"]
const left = " day(s) left in the season"

# Called when the node enters the scene tree for the first time.
func _ready():
	$Name.text = seasonName
	$Time/Start.text = convert_time(start)
	$Time/End.text = convert_time(end)
	var curr = Time.get_unix_time_from_system()
	var days = floor((end-curr)/86400)
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
	var curr = Time.get_unix_time_from_system()
	if not $Days.text == str(floor((end-curr)/86400)) + left:
		_ready()

func convert_time(timestamp) -> String:
	var dict = Time.get_datetime_dict_from_unix_time(timestamp)
	var day = str(dict["day"])
	var ret = months[dict["month"]]+" "+day
	var post = "th"
	if day.ends_with("1") && not day == "11":
		post = "st"
	elif day.ends_with("2") && not day == "12":
		post = "nd"
	elif day.ends_with("3") && not day == "13":
		post = "rd"
	return ret+post+", "+str(dict["year"])

func _on_check_toggled(_button_pressed):
	_ready()

func update_candles():
	var spirits = preload("res://SeasonSpirits.gd")
	var bought = $"../../../Seasonal Spirits/Margin/VBox".bought
	if not bought: bought = {}
	var candles = 0
	for s in spirits.data:
		if spirits.data[s]["loc"] == seasonName && bought.has(s):
			candles += spirits.get_spent(s,bought[s])
	$Spent/Val.text = str(candles)

