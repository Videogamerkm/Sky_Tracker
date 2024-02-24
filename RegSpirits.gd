extends Object

const util = preload("res://SpiritUtils.gd")

static var data = {"Pointing Candlemaker":{"loc":"Isle of Dawn",
	"tree":[["reg/exp/point;2;c","base/5C;5;c","reg/cos/point 2;4;h"],["","reg/exp/point;2;c",""],["base/heart;3;c","base/wing;1;a",""],
	["reg/exp/point;1;c","base/1C;1;c","reg/cos/point 1;0;0"],["","reg/exp/point;0;0",""]]},
	
	"Ushering Stargazer":{"loc":"Isle of Dawn",
	"tree":[["reg/exp/usher;2;c","base/5C;5;c","reg/cos/usher 2;4;h"],["","reg/exp/usher;2;c",""],["base/heart;3;c","base/wing;1;a",""],
	["reg/exp/usher;1;c","base/1C;1;c","reg/cos/usher 1;0;0"],["","reg/exp/usher;0;0",""]]},
	
	"Rejecting Voyager":{"loc":"Isle of Dawn",
	"tree":[["reg/exp/reject;2;c","base/5C;5;c","reg/cos/reject 2;3;h"],["","reg/exp/reject;2;c",""],["reg/cos/reject 1;1;h","base/wing;1;a","base/heart;3;c"],
	["reg/exp/reject;1;c","base/1C;1;c",""],["","reg/exp/reject;0;0",""]]},
	
	"Elder of the Isle":{"loc":"Isle of Dawn","tree":[["","reg/cos/isle 2;125;a;u",""],["","reg/cos/isle 1;4;a;u",""]]},
	
	"Butterfly Charmer":{"loc":"Daylight Prairie","t2":1,
	"tree":[["","reg/cos/charm 3;9;h;t",""],["","base/wing;3;a;t",""],["reg/exp/charm;2;c","base/5C;5;c","reg/cos/charm 2;4;h"],
	["","reg/exp/charm;2;c",""],["reg/cos/charm 1;3;h","base/wing;1;a","base/heart;3;c"],["reg/exp/charm;1;c","base/1C;1;c",""],
	["","reg/exp/charm;0;0",""]]},
	
	"Applauding Bellmaker":{"loc":"Daylight Prairie",
	"tree":[["reg/exp/clap;3;c","base/5C;5;c",""],["","reg/exp/clap;3;c",""],["reg/cos/clap;3;h","base/wing;1;a",""],
	["reg/exp/clap;1;c","base/1C;1;c","base/heart;3;c"],["","reg/exp/clap;0;0",""]]},
	
	"Waving Bellmaker":{"loc":"Daylight Prairie","t2":1,
	"tree":[["","reg/exp/wave;3;c;t",""],["","reg/exp/wave;3;c;t",""],["reg/cos/wave 2;5;h","base/wing;6;a;t",""],
	["reg/exp/wave;2;c","base/5C;5;c",""],["","reg/exp/wave;2;c",""],["reg/cos/wave 1;2;h","base/wing;2;a","base/heart;3;c"],
	["reg/exp/wave;1;c","base/1C;1;c",""],["","reg/exp/wave;0;0",""]]},
	
	"Slumbering Shipwright":{"loc":"Daylight Prairie",
	"tree":[["reg/exp/yawn;2;c","base/5C;5;c",""],["","reg/exp/yawn;2;c",""],["reg/cos/yawn;3;h","base/wing;1;a","base/heart;3;c"],
	["reg/exp/yawn;1;c","base/1C;1;c",""],["","reg/exp/yawn;0;0",""]]},
	
	"Laughing Light Catcher":{"loc":"Daylight Prairie",
	"tree":[["reg/exp/laugh;5;c","base/5C;5;c","reg/cos/laugh 2;5;h"],["","reg/exp/laugh;5;c",""],["reg/cos/laugh 1;5;h","base/wing;2;a","base/heart;3;c"],
	["reg/exp/laugh;1;c","base/1C;1;c",""],["","reg/exp/laugh;0;0",""]]},
	
	"Bird Whisperer":{"loc":"Daylight Prairie",
	"tree":[["","reg/cos/bird;5;h",""],["","base/5C;5;c",""],["base/heart;3;c","base/wing;2;a",""],
	["base/sheet;1;h","base/1C;1;c",""],["","reg/exp/bird;0;0",""]]},
	
	"Exhausted Dock Worker":{"loc":"Daylight Prairie",
	"tree":[["","reg/cos/sweat;3;h",""],["reg/exp/sweat;5;c","base/5C;5;c",""],["","reg/exp/sweat;5;c",""],
	["base/heart;3;c","base/wing;1;a",""],["reg/exp/sweat;1;c","base/1C;1;c",""],["","reg/exp/sweat;0;0",""]]},
	
	"Ceremonial Worshipper":{"loc":"Daylight Prairie",
	"tree":[["","base/5C;5;c",""],["base/heart;3;c","base/wing;1;a",""],["","base/1C;1;c",""],
	["","reg/exp/worship;0;0",""]]},
	
	"Elder of the Prairie":{"loc":"Daylight Prairie","tree":[["","reg/cos/prairie 2;75;a;u",""],["","reg/cos/prairie 1;3;a;u",""]]},
	
	"Shivering Trailblazer":{"loc":"Hidden Forest",
	"tree":[["","reg/cos/shiver 2;5;h",""],["reg/exp/shiver;3;c","base/5C;5;c",""],["","reg/exp/shiver;3;c",""],
	["reg/cos/shiver 1;2;h","base/wing;2;a","base/heart;3;c"],["reg/exp/shiver;2;c","base/1C;1;c",""],["","reg/exp/shiver;0;0",""]]},
	
	"Blushing Prospector":{"loc":"Hidden Forest",
	"tree":[["","reg/cos/blush 2;5;h",""],["reg/exp/blush;4;c","base/5C;5;c",""],["","reg/exp/blush;4;c",""],
	["reg/cos/blush 1;3;h","base/wing;1;a","base/heart;3;c"],["reg/exp/blush;3;c","base/1C;1;c",""],["","reg/exp/blush;0;0",""]]},
	
	"Hide'n'Seek Pioneer":{"loc":"Hidden Forest","t2":1,
	"tree":[["","reg/cos/hide 3;15;h;t",""],["","base/wing;6;a;t",""],["","reg/cos/hide 2;20;h",""],["","base/5C;5;c",""],
	["base/heart;3;c","base/wing;3;a",""],["reg/cos/hide 1;2;h","base/1C;1;c",""],["","reg/exp/hide;0;0",""]]},
	
	"Pouty Porter":{"loc":"Hidden Forest","t2":1,
	"tree":[["","reg/cos/pout 3;60;h;t",""],["","base/wing;6;a;t",""],["","reg/cos/pout 2;20;h",""],
	["reg/exp/pout;4;c","base/5C;5;c",""],["","reg/exp/pout;4;c",""],["reg/cos/pout 1;3;h","base/wing;2;a","base/heart;3;c"],
	["reg/exp/pout;3;c","base/1C;1;c",""],["","reg/exp/pout;0;0",""]]},
	
	"Dismayed Hunter":{"loc":"Hidden Forest","t2":1,
	"tree":[["","reg/cos/dismay 3;90;h;t",""],["","base/wing;9;a;t",""],["","reg/cos/dismay 2;30;h",""],
	["reg/exp/dismay;5;c","base/5C;5;c",""],["","reg/exp/dismay;5;c",""],["reg/cos/dismay 1;5;h","base/wing;3;a","base/heart;3;c"],
	["reg/exp/dismay;3;c","base/1C;1;c",""],["","reg/exp/dismay;0;0",""]]},
	
	"Apologetic Lumberjack":{"loc":"Hidden Forest",
	"tree":[["","reg/cos/sorry 2;5;h",""],["reg/exp/sorry;3;c","base/5C;5;c",""],["","reg/exp/sorry;3;c",""],
	["reg/cos/sorry 1;3;h","base/wing;1;a","base/heart;3;c"],["reg/exp/sorry;3;c","base/1C;1;c",""],["","reg/exp/sorry;0;0",""]]},
	
	"Tearful Light Miner":{"loc":"Hidden Forest","t2":1,
	"tree":[["","reg/exp/cry;5;c;t",""],["","reg/exp/cry;5;c;t",""],["","base/wing;3;a;t",""],
	["reg/exp/cry;4;c","base/5C;5;c",""],["","reg/exp/cry;4;c",""],["reg/cos/cry;3;h","base/wing;1;a","base/heart;3;c"],
	["reg/exp/cry;3;c","base/1C;1;c",""],["","reg/exp/cry;0;0",""]]},
	
	"Whale Whisperer":{"loc":"Hidden Forest",
	"tree":[["","base/sheet;2;h",""],["","base/5C;5;c",""],["base/heart;3;c","base/wing;1;a",""],
	["","base/1C;1;c",""],["","reg/exp/whale;0;0",""]]},
	
	"Elder of the Forest":{"loc":"Hidden Forest","tree":[["","reg/cos/forest 2;250;a;u",""],["","reg/cos/forest 1;6;a;u",""]]},
	
	"Confident Sightseer":{"loc":"Valley of Triumph",
	"tree":[["","reg/cos/confident 2;5;h",""],["","base/5C;5;c",""],["base/heart;3;c","base/wing;2;a",""],
	["reg/cos/confident 1;2;h","base/1C;1;c",""],["","reg/exp/confident;0;0",""]]},
	
	"Handstanding Thrillseeker":{"loc":"Valley of Triumph","t2":1,
	"tree":[["","reg/cos/handstand 2;120;h;t",""],["","base/wing;9;a;t",""],["","reg/cos/handstand 1;40;h",""],
	["reg/exp/handstand;4;c","base/5C;5;c",""],["","reg/exp/handstand;4;c",""],["base/heart;3;c","base/wing;3;a",""],
	["reg/exp/handstand;3;c","base/1C;1;c",""],["","reg/exp/handstand;0;0",""]]},
	
	"Manta Whisperer":{"loc":"Valley of Triumph",
	"tree":[["","base/sheet;3;h",""],["","base/5C;5;c",""],["","base/wing;1;a",""],
	["base/heart;3;c","base/1C;1;c",""],["","reg/exp/manta;0;0",""]]},
	
	"Backflipping Champion":{"loc":"Valley of Triumph",
	"tree":[["","reg/cos/backflip 2;5;h",""],["reg/exp/backflip;4;c","base/5C;5;c",""],["","reg/exp/backflip;4;c",""],
	["reg/cos/backflip 1;5;h","base/wing;2;a","base/heart;3;c"],["reg/exp/backflip;3;c","base/1C;1;c",""],["","reg/exp/backflip;0;0",""]]},
	
	"Cheerful Spectator":{"loc":"Valley of Triumph",
	"tree":[["","reg/cos/cheer 2;10;h",""],["reg/exp/cheer;4;c","base/5C;5;c",""],["","reg/exp/cheer;4;c",""],
	["reg/cos/cheer 1;5;h","base/wing;2;a","base/heart;3;c"],["reg/exp/cheer;3;c","base/1C;1;c",""],["","reg/exp/cheer;0;0",""]]},
	
	"Bowing Medalist":{"loc":"Valley of Triumph",
	"tree":[["","reg/cos/bow 2;5;h",""],["reg/exp/bow;4;c","base/5C;5;c",""],["","reg/exp/bow;4;c",""],
	["reg/cos/bow 1;5;h","base/wing;2;a","base/heart;3;c"],["reg/exp/bow;3;c","base/1C;1;c",""],["","reg/exp/bow;0;0",""]]},
	
	"Proud Victor":{"loc":"Valley of Triumph","t2":1,
	"tree":[["","reg/cos/proud 3;30;h;t",""],["","base/wing;9;a;t",""],["","reg/cos/proud 2;30;h",""],
	["","base/5C;5;c",""],["base/heart;3;c","base/wing;3;a",""],
	["reg/cos/proud 1;10;h","base/1C;1;c",""],["","reg/exp/proud;0;0",""]]},
	
	"Elder of the Valley":{"loc":"Valley of Triumph","tree":[["","reg/cos/valley 2;6;a;u",""],["","reg/cos/valley 1;5;a;u",""]]},
	
	"Frightened Refugee":{"loc":"Golden Wasteland",
	"tree":[["","reg/cos/fright 2;5;h",""],["reg/exp/fright;5;c","base/5C;5;c",""],["","reg/exp/fright;5;c",""],
	["reg/cos/fright 1;3;h","base/wing;1;a","base/heart;3;c"],["reg/exp/fright;4;c","base/1C;1;c",""],["","reg/exp/fright;0;0",""]]},
	
	"Fainting Warrior":{"loc":"Golden Wasteland",
	"tree":[["","reg/cos/faint 2;15;h",""],["reg/exp/faint;5;c","base/5C;5;c",""],["","reg/exp/faint;5;c",""],
	["reg/cos/faint 1;5;h","base/wing;2;a","base/heart;3;c"],["reg/exp/faint;4;c","base/1C;1;c",""],["","reg/exp/faint;0;0",""]]},
	
	"Courageous Soldier":{"loc":"Golden Wasteland","t2":1,
	"tree":[["","reg/cos/courage 3;45;h;t",""],["","base/wing;6;a;t",""],["","reg/cos/courage 2;15;h",""],
	["","base/5C;5;c",""],["base/heart;3;c","base/wing;2;a",""],
	["reg/cos/courage 1;4;h","base/1C;1;c",""],["","reg/exp/courage;0;0",""]]},
	
	"Stealthy Survivor":{"loc":"Golden Wasteland","t2":1,
	"tree":[["","reg/cos/stealth 3;150;h;t",""],["","base/wing;12;a;t",""],["","reg/cos/stealth 2;50;h",""],
	["","base/5C;5;c",""],["base/heart;3;c","base/wing;4;a",""],["reg/cos/stealth 1;5;h","base/1C;1;c",""],
	["","reg/exp/stealth;0;0",""]]},
	
	"Saluting Captain":{"loc":"Golden Wasteland",
	"tree":[["","reg/cos/salute 2;20;h",""],["reg/exp/salute;5;c","base/5C;5;c",""],["","reg/exp/salute;5;c",""],
	["reg/cos/salute 1;5;h","base/wing;3;a","base/heart;3;c"],["reg/exp/salute;4;c","base/1C;1;c",""],["","reg/exp/salute;0;0",""]]},
	
	"Lookout Scout":{"loc":"Golden Wasteland",
	"tree":[["","reg/cos/lookout 2;10;h",""],["reg/exp/lookout;5;c","base/5C;5;c",""],["","reg/exp/lookout;5;c",""],
	["reg/cos/lookout 1;5;h","base/wing;2;a","base/heart;3;c"],["reg/exp/lookout;5;c","base/1C;1;c",""],["","reg/exp/lookout;0;0",""]]},
	
	"Elder of the Wasteland":{"loc":"Golden Wasteland","tree":[["","reg/cos/waste;6;a;u",""]]},
	
	"Praying Acolyte":{"loc":"Vault of Knowledge","t2":1,
	"tree":[["","reg/cos/pray 3;75;h;t",""],["","base/wing;9;a;t",""],["","reg/cos/pray 2;25;h",""],
	["reg/exp/pray;7;c","base/5C;5;c",""],["","reg/exp/pray;5;c",""],["reg/cos/pray 1;5;h","base/wing;3;a","base/heart;3;c"],
	["reg/exp/pray;3;c","base/1C;1;c",""],["","reg/exp/pray;0;0",""]]},
	
	"Levitating Adept":{"loc":"Vault of Knowledge",
	"tree":[["","reg/cos/levitate 2;10;h",""],["reg/exp/levitate;7;c","base/5C;5;c",""],["","reg/exp/levitate;5;c",""],
	["reg/cos/levitate 1;5;h","base/wing;2;a","base/heart;3;c"],["reg/exp/levitate;5;c","base/1C;1;c",""],["","reg/exp/levitate;0;0",""]]},
	
	"Polite Scholar":{"loc":"Vault of Knowledge",
	"tree":[["","reg/cos/polite 2;15;h",""],["","base/5C;5;c",""],["base/heart;3;c","base/wing;2;a",""],
	["reg/cos/polite 1;2;h","base/1C;1;c",""],["","reg/exp/polite;0;0",""]]},
	
	"Memory Whisperer":{"loc":"Vault of Knowledge","t2":1,
	"tree":[["","reg/cos/cosmic 3;150;h;t",""],["","base/wing;12;a;t",""],["","reg/cos/cosmic 2;50;h",""],
	["","base/5C;5;c",""],["base/heart;3;c","base/wing;4;a",""],["reg/cos/cosmic 1;3;h","base/1C;1;c",""],
	["","reg/exp/cosmic;0;0",""]]},
	
	"Meditating Monastic":{"loc":"Vault of Knowledge",
	"tree":[["","reg/cos/meditate 2;30;h",""],["reg/exp/meditate;10;c","base/5C;5;c",""],["","reg/exp/meditate;7;c",""],
	["reg/cos/meditate 1;10;h","base/wing;2;a","base/heart;3;c"],["reg/exp/meditate;10;c","base/1C;1;c",""],["","reg/exp/meditate;0;0",""]]},
	
	"Elder of the Vault":{"loc":"Vault of Knowledge","tree":[["","reg/cos/vault;5;a;u",""]]},}

static func get_cost(name) -> Dictionary:
	var ret = util.get_cost(data,name)
	ret.erase("sp")
	ret.erase("sh")
	return ret

static func get_unspent(name,bought) -> Dictionary:
	var ret = util.get_unspent(data,name,bought)
	ret.erase("sp")
	ret.erase("sh")
	return ret

static func get_completion(name,bought) -> int: return util.get_completion(data,name,bought)

static func get_all_wings() -> int: return util.get_all_wings(data)

static func get_wings(bought) -> int: return util.get_wings(data,bought)
