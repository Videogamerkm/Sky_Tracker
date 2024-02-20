extends VBoxContainer

var spirits = preload("res://SeasonSpirits.gd")
@onready var spiritRow = $Stats/Spirit.duplicate()
var bought = {}

func _ready():
	for c in $Stats.get_children():
		if c == $Stats/Titles: continue
		$Stats.remove_child(c)
	$SpiritSelect.clear()
	$SpiritSelect.add_item("Stats")
	if not bought: bought = {}
	for s in spirits.data:
		$SpiritSelect.add_item(s)
		var row = spiritRow.duplicate()
		var costs
		if bought.has(s): costs = spirits.get_unspent(s,bought[s])
		else: costs = spirits.get_cost(s)
		row.get_node("Name").text = s
		row.get_node("Seasonal").text = str(costs["sp"])
		row.get_node("Candles").text = str(costs["c"])
		row.get_node("Hearts").text = str(costs["h"])
		row.get_node("Ascended").text = str(costs["a"])
		$Stats.add_child(row)
	for s in spirits.seasons:
		$SeasonSelect.add_item(s)

func _on_spirit_select_item_selected(index):
	if index == 0:
		for c in $Stats.get_children():
			if c == $Stats/Titles: continue
			$Stats.remove_child(c)
		for s in spirits.data:
			if $SeasonSelect.get_selected_id() == 0 || spirits.data[s]["loc"] == $SeasonSelect.get_item_text($SeasonSelect.get_selected_id()):
				var row = spiritRow.duplicate()
				var costs
				if bought.has(s): costs = spirits.get_unspent(s,bought[s])
				else: costs = spirits.get_cost(s)
				row.get_node("Name").text = s
				row.get_node("Seasonal").text = str(costs["sp"])
				row.get_node("Candles").text = str(costs["c"])
				row.get_node("Hearts").text = str(costs["h"])
				row.get_node("Ascended").text = str(costs["a"])
				$Stats.add_child(row)
				if spirits.data[s].has("t2"):
					var row2 = spiritRow.duplicate()
					row2.get_node("Name").text = s+" T2"
					row2.get_node("Candles").text = str(costs["c2"])
					row2.get_node("Hearts").text = str(costs["h2"])
					row2.get_node("Ascended").text = str(costs["a2"])
					row2.set_modulate(Color(1,.5,.5))
					$Stats.add_child(row2)
		$Tree.hide()
		$Stats.show()
	else:
		var spirit = $SpiritSelect.get_item_text(index)
		$Tree.set_tree(spirits.data[spirit]["tree"])
		if bought.has(spirit): $Tree.import_bought(bought[spirit])
		$Tree.show()
		$Stats.hide()

func _on_area_select_item_selected(index):
	var area = $SeasonSelect.get_item_text(index)
	$SpiritSelect.clear()
	$SpiritSelect.add_item("Stats")
	if index == 0: for s in spirits.data: $SpiritSelect.add_item(s)
	else:
		for s in spirits.data:
			if spirits.data[s]["loc"] == area:
				$SpiritSelect.add_item(s)
	$SpiritSelect.select(0)
	_on_spirit_select_item_selected(0)

func _on_tree_bought():
	var spirit = $SpiritSelect.get_item_text($SpiritSelect.get_selected_id())
	bought[spirit] = $Tree.export_bought()
	if spirits.data[spirit]["loc"] == $"../../../Current Season/Margin/VBox".seasonName:
		$"../../../Current Season/Margin/VBox".update_candles()

func _on_clear_pressed():
	$Confirm.show()

func _on_confirm_confirmed():
	if $SpiritSelect.get_selected_id() == 0:
		for s in spirits.data:
			if spirits.data[s]["loc"] == $SeasonSelect.get_item_text($SeasonSelect.get_selected_id()) && bought.has(s):
				bought.erase(s)
		_on_spirit_select_item_selected(0)
	else:
		var spirit = $SpiritSelect.get_item_text($SpiritSelect.get_selected_id())
		bought.erase(spirit)
		$Tree.set_tree(spirits.data[spirit]["tree"])
