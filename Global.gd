extends Node

var spoilers = false
var useTwelve = false

# Tabs
var main
var homeTab
var statsTab
var regSprtTab
var currSsnTab
var ssnlSprtTab
var wlTab
var shrdTab
var yrlyTab
var setsTab

func load_tabs():
	main = get_tree().root.get_node("Main")
	homeTab = get_tree().root.get_node("Main/Tabs/Home/Margin/VBox")
	statsTab = get_tree().root.get_node("Main/Tabs/Stats/Margin/VBox")
	regSprtTab = get_tree().root.get_node("Main/Tabs/Regular Spirits/Margin/VBox")
	currSsnTab = get_tree().root.get_node("Main/Tabs/Current Season/Margin/VBox")
	ssnlSprtTab = get_tree().root.get_node("Main/Tabs/Seasonal Spirits/Margin/VBox")
	wlTab = get_tree().root.get_node("Main/Tabs/Winged Light Tracker/Margin/VBox")
	shrdTab = get_tree().root.get_node("Main/Tabs/Shard Eruptions/Margin/VBox")
	yrlyTab = get_tree().root.get_node("Main/Tabs/Yearly Events/Margin/VBox")
	setsTab = get_tree().root.get_node("Main/Tabs/Settings/Margin/VBox")
