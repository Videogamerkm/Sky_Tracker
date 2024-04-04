extends VBoxContainer

var delSpirit = ""
var days = 0:
	set(val):
		days = val
		$Days/Num.value = days
var cpd = 0:
	set(val):
		cpd = val
		$Candles/Per.value = cpd
var hpd = 0:
	set(val):
		hpd = val
		$Hearts/Per.value = hpd
var currCandles = 0:
	set(val):
		currCandles = val
		$Candles/Curr.value = currCandles
var currHearts = 0:
	set(val):
		currHearts = val
		$Hearts/Curr.value = currHearts
var currTicks = 0:
	set(val):
		currTicks = val
		$Tickets/Curr.value = currTicks

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
	for n in [$Days/Num, $Candles/Curr, $Candles/Per, $Hearts/Curr, $Hearts/Per, $Tickets/Curr]:
		if not n.is_connected("value_changed",recalculate): n.connect("value_changed",recalculate)
	recalculate(0)

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

func recalculate(_val):
	$Tickets/Per.text = str(Global.yrlyTab.tpd)
	days = $Days/Num.value
	cpd = $Candles/Per.value
	hpd = $Hearts/Per.value
	var spd = int(Global.currSsnTab.get_node("Per Day/Val").text)
	var currSeason = Global.currSsnTab.get_node("Have/Candles").value
	currCandles = $Candles/Curr.value
	currHearts = $Hearts/Curr.value
	currTicks = $Tickets/Curr.value
	var targCandles = int($Plans.get_child(-8).text)
	var targHearts = int($Plans.get_child(-7).text)
	var targSeason = int($Plans.get_child(-5).text)
	var targTicks = int($Plans.get_child(-3).text)
	var text = ""
	if targCandles > 0 and targCandles <= days * cpd + currCandles:
		text += "You will be able to get enough candles (%d left over).\n"\
			% [(days * cpd + currCandles) - targCandles]
	elif targCandles > 0:
		text += "You will NOT be able to get enough candles (%d short).\n"\
			% [targCandles - (days * cpd + currCandles)]
	if targSeason > 0 and targSeason <= days * spd + currSeason:
		text += "You will be able to get enough seasonal candles (%d left over).\nCheck Current Season tab for more info.\n"\
			% [(days * spd + currSeason) - targSeason]
	elif targSeason > 0:
		text += "You will NOT be able to get enough seasonal candles (%d short).\nCheck Current Season tab for more info.\n"\
			% [targSeason - (days * spd + currSeason)]
	if targHearts > 0 and targHearts <= days * hpd + currHearts:
		text += "You will be able to get enough hearts (%d left over).\n"\
			% [(days * hpd + currHearts) - targHearts]
	elif targHearts > 0:
		text += "You will NOT be able to get enough hearts (%d short).\n"\
			% [targHearts - (days * hpd + currHearts)]
	if targTicks > 0 and targTicks <= days * Global.yrlyTab.tpd + currTicks:
		text += "You will be able to get enough tickets, if you get all %d per day (%d left over).\n"\
			% [Global.yrlyTab.tpd,(days * Global.yrlyTab.tpd + currTicks) - targTicks]
	elif targTicks > 0:
		text += "You will NOT be able to get enough tickets (%d short).\n"\
			% [targTicks - (days * Global.yrlyTab.tpd + currTicks)]
	$Comp.text = text

func _gui_input(event):
	if event is InputEventMouseButton and event.get_button_index() == MOUSE_BUTTON_LEFT:
		get_parent().get_parent().grab_focus()
