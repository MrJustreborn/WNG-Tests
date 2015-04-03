
extends Control

# member variables here, example:
# var a=2
# var b="textvar"
var v = Vector2Array()
var v2 = Vector2Array()
var cur=0
var last=0
var tex
var tex_front
var tex_back

func _process(delta):
	get_node("ProgressBar").set_val(get_node("ProgressBar").get_val()+0.1)
	var cur = floor(get_node("ProgressBar").get_val())
	if(cur != last):
		last=cur
		var len = get_size().height/2-50
		var oval = 1
		var alpha = (((-PI*2)/100*cur)+PI)
		if(cur > 0 && cur < 25):
			len = len - oval*(cur/100)
		if(cur > 49 && cur < 75):
			len = len - oval*((cur-50)/100)
		if(cur >24 && cur < 50):
			len = len - oval/4 + oval*((cur-25)/100)
		if(cur > 74 && cur < 100):
			len = len - oval/4 + oval*((cur-75)/100)
		var x = (sin(alpha) * len) + get_size().width/2
		var y = (cos(alpha) * len) + get_size().height/2
		var uvx = (sin(alpha) * 0.5) + 0.5
		var uvy = (cos(alpha) * 0.5) + 0.5
		v.push_back(Vector2(x,y))
		v2.push_back(Vector2(uvx,uvy))
		print(uvx,"|",uvy)
	update()

func _draw():
	#draw_circle(Vector2(get_size().width/2,get_size().height/2),get_node("ProgressBar").get_val()/100*get_size().width/2,Color(0, 1, 0, 0.5))
	#draw_rect(Rect2(-get_global_pos().x,-get_global_pos().y,800,600),Color(1,0,0.5))
	#draw_texture_rect(tex,Rect2(-get_global_pos().x,-get_global_pos().y,800,600),false)
	draw_rect(Rect2(-get_global_pos().x,-get_global_pos().y,get_window().get_size().width,get_window().get_size().height),Color(0,0,0))
	draw_texture(tex_back,Vector2(0,0))
	draw_colored_polygon(v,Color(1, 1, 1, 0.99),v2,tex)
	draw_texture(tex_front,Vector2(get_size().width/2-256,get_size().height/2-256))

func _ready():
	# Initialization here
	set_process(true)
	v.push_back(Vector2(get_size().width/2,get_size().height/2-20))
	v.push_back(Vector2(get_size().width/2,51))
	
	v2.push_back(Vector2(0.5,0.5))
	v2.push_back(Vector2(0.5,0))
	
	
	tex = ImageTexture.new()
	tex.load("loading.png")
	tex_front = ImageTexture.new()
	tex_front.load("loading_front.png")
	tex_back = ImageTexture.new()
	tex_back.load("loading_back.png")
	pass


