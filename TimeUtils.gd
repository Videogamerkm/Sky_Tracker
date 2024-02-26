extends Object

static var game_offset_secs = -28_800
static var game_offset_dst = -25_200
static var local_offset_secs = Time.get_time_zone_from_system()["bias"]*60
static var months = ["","January","February","March","April","May","June","July","August","September","October","November","December"]
static var days = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]

static func convert_time(timestamp) -> String:
	var dict = Time.get_datetime_dict_from_unix_time(Time.get_unix_time_from_datetime_dict(timestamp) - get_game_offset() + local_offset_secs)
	var day = str(dict["day"])
	var ret = months[dict["month"]]+" "+day
	var post = "th"
	if day.ends_with("1") && not day == "11":
		post = "st"
	elif day.ends_with("2") && not day == "12":
		post = "nd"
	elif day.ends_with("3") && not day == "13":
		post = "rd"
	return ("%02d:%02d"%[dict["hour"],dict["minute"]])+" "+ret+post+", "+str(dict["year"])

static func get_time_since(timestamp) -> int:
	return Time.get_unix_time_from_datetime_dict(timestamp) - get_game_offset() - Time.get_unix_time_from_system()

static func get_post(day:String) -> String:
	var post = "th"
	if day.ends_with("1") && not day == "11":
		post = "st"
	elif day.ends_with("2") && not day == "12":
		post = "nd"
	elif day.ends_with("3") && not day == "13":
		post = "rd"
	return post

static func get_game_offset(dst=Time.get_datetime_dict_from_system()["dst"]) -> int:
	return (game_offset_dst if dst else game_offset_secs)
