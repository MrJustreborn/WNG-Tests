
extends Camera

func _ready():
	# Initalization here
	set_process(true)
	set_process_input(true)


func _process(delta):
	var speed = 4
	delta = speed * delta
	var pos = get_translation()
	if (Input.is_key_pressed(KEY_RIGHT)):
		pos = pos + Vector3(1,0,0) * delta;
		set_translation(pos)
	elif (Input.is_key_pressed(KEY_LEFT)):
		pos = pos + Vector3(-1,0,0) * delta;
		set_translation(pos)
	
	if (Input.is_key_pressed(KEY_UP)):
		pos = pos + Vector3(0,1,0) * delta;
		set_translation(pos)
	elif (Input.is_key_pressed(KEY_DOWN)):
		pos = pos + Vector3(0,-1,0) * delta;
		set_translation(pos)

func _input(event):
	var pos = get_translation()
	#print(get_parent().get_name()," -> ",get_viewport().get_mouse_pos())
	if (Input.is_mouse_button_pressed(BUTTON_WHEEL_DOWN)):
		pos = pos + Vector3(0,0,9) * 0.02;
		set_translation(pos)
	elif (Input.is_mouse_button_pressed(BUTTON_WHEEL_UP)):
		pos = pos + Vector3(0,0,-9) * 0.02;
		set_translation(pos)

