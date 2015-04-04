
extends WindowDialog

# member variables here, example:
# var a=2
# var b="textvar"
var community
var entry = load("GUI-Tests/plugin-manager_entry.xscn")
var controller_class = load("GUI-Tests/scripts/plugin_controller.gd")
var controller


func _ready():
	# Initialization here
	community = get_node("MainCanvas/TabContainer/Community/VBoxContainer/ScrollContainer/VBoxContainer")
	controller = controller_class.new()
	for i in range(11):
		var e1 = entry.instance()
		community.add_child(e1)
		e1.call("setIcon","loading.png")
	pass


