
extends HBoxContainer

# member variables here, example:
# var a=2
# var b="textvar"
var titel
var desc
var icon
var progress
var button
var checkButton

func _ready():
	# Initialization here
	titel = get_node("HBoxContainer/VBoxContainer/HBoxContainer/HBoxContainer/VBoxContainer/Titel")
	desc = get_node("HBoxContainer/VBoxContainer/HBoxContainer/HBoxContainer/VBoxContainer/Desc")
	icon = get_node("HBoxContainer/VBoxContainer/HBoxContainer/Icon")
	progress = get_node("HBoxContainer/VBoxContainer/ProgressBar")
	button = get_node("HBoxContainer/VBoxContainer/HBoxContainer/HBoxContainer/VBoxContainer2/Button")
	checkButton = get_node("HBoxContainer/VBoxContainer/HBoxContainer/HBoxContainer/VBoxContainer2/CheckButton")
	
	desc.set_text("Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.")
	titel.set_text("Titel")
	
	checkButton.set_disabled(true)
	button.set_text("Install")
	button.connect("pressed",self,"_button")
	
	progress.set_val(0)
	progress.hide()

func setIcon(path):
	icon.set_texture(load(path))
	icon.get_texture().set_size_override(Vector2(64,64))

func _button():
	button.set_text("Läd ...")
	button.set_disabled(true)
	set_process(true)

func _process(delta):
	progress.show()
	progress.set_val(progress.get_val()+0.1)
	if(progress.get_val() == 100):
		set_process(false)
		checkButton.set_disabled(false)
		checkButton.set_pressed(true)
	if(1==0):
		if(button.get_text().match("Läd ...")):
			button.set_text("Läd *..")
		elif(button.get_text().match("Läd *..")):
			button.set_text("Läd .*.")
		elif(button.get_text().match("Läd .*.")):
			button.set_text("Läd ..*")

