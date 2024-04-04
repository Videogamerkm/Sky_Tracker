extends VBoxContainer

var delSpirit = ""

func _ready():
	var w = 0
	for c in $Plans.get_children():
		if w == 8: c.show()
		if w >= 9:
			$Plans.remove_child(c)
			c.queue_free()
		w += 1
	var costTotals = {"c":0,"h":0,"a":0,"k":0,"sp":0,"sh":0,"n":0}
	for s in Global.regSprtTab.planned.keys():
		var vals = add_plans(RegSpirits.data,s,Global.regSprtTab.planned[s])
		for k in costTotals.keys(): costTotals[k] += vals[k]
	for s in Global.ssnlSprtTab.planned.keys():
		var vals = add_plans(SeasonSpirits.data,s,Global.ssnlSprtTab.planned[s])
		for k in costTotals.keys(): costTotals[k] += vals[k]
	for s in Global.yrlyTab.planned.keys():
		var vals = add_plans(Global.yrlyTab.rows,s,Global.yrlyTab.planned[s])
		for k in costTotals.keys(): costTotals[k] += vals[k]
	for i in range(0,9): $Plans.add_child(HSeparator.new())
	for i in range(0,9):
		var row = $Plans.get_child(i).duplicate()
		row.name += " Total"
		$Plans.add_child(row)
	$Plans.get_node("Spirit Total").text = "Total"
	for c in costTotals.keys():
		if c == "n": continue
		$Plans.get_node(c+" Total").text = str(costTotals[c])
	$Plans.get_node("items Total").text = str(costTotals["n"])
	$Plans.get_child(8).hide()
	$Plans.get_child(8).add_sibling(Label.new())
	$Plans.get_child(-1).hide()

func add_plans(data,spirit,plan):
	for i in range(0,9):
		var row = $Plans.get_child(i).duplicate()
		row.name += " "+spirit
		$Plans.add_child(row)
	var ret = {"c":0,"h":0,"a":0,"sp":0,"sh":0,"k":0}
	$Plans.get_node("Spirit "+spirit).text = spirit
	$Plans.get_node("X "+spirit).connect("pressed",clear_row.bind(spirit))
	var cost = SpiritUtils.get_cost(data,spirit)
	var unspent = SpiritUtils.get_unspent(data,spirit,plan)
	for c in cost.keys():
		if c.contains("2"): continue
		ret[c] = cost[c] - unspent[c]
		$Plans.get_node(c+" "+spirit).text = str(ret[c])
	var amnt = 0
	for r in plan: for b in r: if b: amnt += 1
	$Plans.get_node("items "+spirit).text = str(amnt)
	ret["n"] = amnt
	return ret

func clear_row(spirit):
	delSpirit = spirit
	$Confirm.show()

func _on_confirm_confirmed():
	if Global.regSprtTab.planned.has(delSpirit):
		Global.regSprtTab.planned.erase(delSpirit)
	if Global.ssnlSprtTab.planned.has(delSpirit):
		Global.ssnlSprtTab.planned.erase(delSpirit)
	if Global.yrlyTab.planned.has(delSpirit):
		Global.yrlyTab.planned.erase(delSpirit)
	delSpirit = ""
	_ready()
