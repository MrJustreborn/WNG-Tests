var map = GridMap.new()
var theme = MeshLibrary.new()

func _init(map):
	self.map = map
	print(map)

func _load():
	var mat = FixedMaterial.new()
	var tex = load("res://blender/textures/RockSmooth0116_5_thumblarge.jpg")
	mat.set_texture(0,tex)
	theme.create_item(0)
	theme.set_item_mesh(0,load("res://Map-Cubes.msh"))
	theme.set_item_name(0,"XYZ_00001")
	theme.set_item_shape(0,load("res://new_boxshape.shp"))
	#map.set_theme(load("res://Map-Cubes.gt"))
	map.set_theme(theme)
	for i in range(theme.get_item_list().size()):
		print(theme.get_item_name(theme.get_item_list().get(i)))
		
	var mat = FixedMaterial.new()
	var tex #= load("res://blender/textures/RockSmooth0116_5_thumblarge.jpg")
	tex = load("res://blender/textures/cube.png")
	mat.set_texture(0,tex)
	theme.get_item_mesh(0).surface_set_material(0,mat)