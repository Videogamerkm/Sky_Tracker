extends Object

static func get_cost(data,name) -> Dictionary:
	var c = 0
	var h = 0
	var a = 0
	var sp = 0
	var sh = 0
	var c2 = 0
	var h2 = 0
	var a2 = 0
	for row in data[name]["tree"]:
		for item in row:
			if item == "": continue
			var amnt = int(item.split(";")[1])
			var type = item.split(";")[2]
			if item.ends_with(";t"):
				if type == "c": c2 += amnt
				if type == "h": h2 += amnt
				if type == "a": a2 += amnt
			else:
				if type == "sp": sp += amnt
				if type == "sh": sh += amnt
				if type == "c": c += amnt
				if type == "h": h += amnt
				if type == "a": a += amnt
	return {"c":c,"h":h,"a":a,"c2":c2,"h2":h2,"a2":a2,"sp":sp,"sh":sh}

static func get_unspent(data,name,bought) -> Dictionary:
	var c = 0
	var h = 0
	var a = 0
	var sp = 0
	var sh = 0
	var c2 = 0
	var h2 = 0
	var a2 = 0
	var x = 0
	for row in data[name]["tree"]:
		var y = 0
		for item in row:
			if not(item == "" || bought[x][y]):
				var amnt = int(item.split(";")[1])
				var type = item.split(";")[2]
				if item.ends_with(";t"):
					if type == "c": c2 += amnt
					if type == "h": h2 += amnt
					if type == "a": a2 += amnt
				else:
					if type == "sp": sp += amnt
					if type == "sh": sh += amnt
					if type == "c": c += amnt
					if type == "h": h += amnt
					if type == "a": a += amnt
			y += 1
		x += 1
	return {"c":c,"h":h,"a":a,"c2":c2,"h2":h2,"a2":a2,"sp":sp,"sh":sh}

static func get_completion(data,name,bought) -> int:
	var b = 0
	var t = 0
	var x = 0
	for row in data[name]["tree"]:
		var y = 0
		for item in row:
			if item != "" && not item.ends_with(";t") && bought[x][y]: b += 1
			if item != "" && not item.ends_with(";t"): t += 1
			y += 1
		x += 1
	return floor(b*100.0/t)

static func get_all_wings(data) -> int:
	var w = 0
	for s in data:
		for row in data[s]["tree"]:
			for item in row:
				if item != "" && item.split(";")[0] == "base/wing": w += 1
	return w

static func get_wings(data,bought) -> int:
	var w = 0
	for s in data:
		var x = 0
		for row in data[s]["tree"]:
			var y = 0
			for item in row:
				if item != "" && bought.has(s) && item.split(";")[0] == "base/wing" && bought[s][x][y]: w += 1
				y += 1
			x += 1
	return w
