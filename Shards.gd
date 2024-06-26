extends VBoxContainer

var days = preload("res://Events.gd")
var cycle = [2,1,3,0,4,1,2,0,3,1,4,0]
const excl = [[6,0],[0,1],[1,2],[2,3],[3,4]]
const times = [[7_080,35_880,64_680],[8_280,37_080,65_880],[28_080,49_680,71_280],[8_880,30_480,52_080],[13_080,34_680,56_280]]
const locs = [["Butterfly Fields","Forest Brook","Ice Rink","Broken Temple","Starlight Desert"],
	["Village Islands","Boneyard","Ice Rink","Battlefield","Starlight Desert"],
	["Prairie Caves","Forest End","Village of Dreams","Graveyard","Jellyfish Cove"],
	["Bird Nest","Treehouse","Village of Dreams","Crab Fields","Jellyfish Cove"],
	["Sanctuary Islands","Elevated Clearing","Hermit Valley","Forgotten Ark","Jellyfish Cove"]]
const vals = [[],[],[2.0,2.5,2.5,2.0,3.5],[2.5,3.5,2.5,2.5,3.5],[3.5,3.5,3.5,3.5,3.5]]
var server_reset

func _ready():
	set_fields()

func _process(_d):
	if Time.get_unix_time_from_system() - server_reset > 86_400:
		set_fields()

func set_fields():
	#year, month, day, weekday, hour, minute, second, and dst
	var datetime = Time.get_unix_time_from_system() + TimeUtils.get_game_offset()
	datetime = Time.get_datetime_dict_from_unix_time(datetime)
	datetime.merge({"hour":0,"minute":0,"second":0},true)
	## server_reset + shard time + local offset = local shard drop time
	## server_reset + times[g][s] + local_offset_secs
	server_reset = Time.get_unix_time_from_datetime_dict(datetime) - TimeUtils.get_game_offset()
	var c = cycle[(datetime["day"] - 1) % cycle.size()]
	var type = "None" if datetime["weekday"] == excl[c][0] || datetime["weekday"] == excl[c][1] else "Strong" if c > 1 else "Regular"
	var loc = locs[c][(datetime["day"] - 1) % 5]
	type = "None" if loc == days.get_location_override() else type
	var val = 0 if type == "None" else 200 if type == "Regular" else vals[c][(datetime["day"] - 1) % 5]
	$Date.text = "It is %s, %s %s%s, %d (Server Time)"%[TimeUtils.days[datetime["weekday"]],TimeUtils.months[datetime["month"]],datetime["day"],TimeUtils.get_post(str(datetime["day"])),datetime["year"]]
	if type != "None":
		$Current.show()
		for i in range(1,4):
			get_node("Time"+str(i)).show()
			var start = get_time_string(times[c][i-1])
			var end = get_time_string(times[c][i-1] + 14_400)
			get_node("Time"+str(i)).text = start+" - "+end
		$place2.show()
		$Reward.text = "There will be "+type+" shards falling in "+loc+", awarding "+str(val)+" "+("wax." if val == 200 else "ascended candles.")
	else:
		$Current.hide()
		for i in range(1,4): get_node("Time"+str(i)).hide()
		$place2.hide()
		$Reward.text = "There are no shards falling today."
		if loc == days.get_location_override(): $Reward.text += " Normally there would be, but something is overriding it."

func get_time_string(time) -> String:
	time = time - TimeUtils.get_game_offset() + TimeUtils.local_offset_secs
	var aft = " AM" if time < 43_200 else (" PM" if time < 86_400 else " AM")
	if Global.useTwelve: time = time % 43_200
	time = time + TimeUtils.get_game_offset()
	var ret = Time.get_time_string_from_unix_time(server_reset + time).replace(":00","")
	if Global.useTwelve: ret = ret.replace("00:","12:")
	return ret + (aft if Global.useTwelve else "")
