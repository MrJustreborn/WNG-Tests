
extends WindowDialog

# member variables here, example:
# var a=2
# var b="textvar"
var community
var entry = load("GUI-Tests/plugin-manager_entry.xscn")


func _ready():
	# Initialization here
	community = get_node("MainCanvas/TabContainer/Community/VBoxContainer/ScrollContainer/VBoxContainer")
	#entry = load("GUI-Tests/plugin-manager_entry.xscn")
	for i in range(11):
		var e1 = entry.instance()
		community.add_child(e1)
		e1.call("setIcon","loading.png")
	pass


