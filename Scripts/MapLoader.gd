var material = null

func test():
	print("SUCCESS!")

func setMaterial(mat):
	self.material = mat

func generate_map(map):
	var grid = map.get_cell_size()
	var file = File.new()
	file.open("res://Maps/test.map", File.READ)
	print("FILE-len: ",file.get_len())
	print("FILE-pos: ",file.get_pos())
	var x_size = file.get_line().to_int()
	var y_size = file.get_line().to_int()
	print("MAP-x_size: ",x_size)
	print("MAP-y_size: ",y_size)
	print("FILE-pos: ",file.get_pos())
	
	for y in range(0,y_size):
		for x in range(0,x_size):
			var item = file.get_line().to_int()
			map.set_cell_item(x*grid,y*grid,0,item)
			print("MAP: ",x*grid,"|",y*grid,"|",item)
			pass
	return self._generate_navi(map,x_size,y_size)

func generate_map_xml(map):
	var grid = map.get_cell_size()
	var x_size = 0
	var y_size = 0
	
	var file = XMLParser.new()
	file.open("res://Maps/test_xml.map")
	while !file.read():
		if(file.get_node_name().match("map") && file.has_attribute("world")):
			print("-> ",file.get_named_attribute_value("world"))
		elif(file.get_node_name().match("size") && file.get_node_type() == file.NODE_ELEMENT):
			file.read()
			file.read()
			file.read()
			x_size=file.get_node_data().to_int()
			file.read()
			file.read()
			file.read()
			file.read()
			y_size=file.get_node_data().to_int()
			file.read()
			file.read()
			file.read()
			file.read()
			var item=file.get_node_data().to_int()
			for y in range(0,y_size):
				for x in range(0,x_size):
					for z in range(0,2):
						map.set_cell_item(x*grid,y*grid,z,item)
		elif(file.get_node_name().match("data") && file.get_node_type() == file.NODE_ELEMENT):
			while !(file.get_node_name().match("data") && file.get_node_type() == file.NODE_ELEMENT_END):
				while !(file.get_node_name().match("block")):
					file.read()
				print(file.get_node_name())
				if(file.get_node_type() == file.NODE_ELEMENT):
					while !(file.get_node_name().match("ext")):
						file.read()
					var x = file.get_named_attribute_value("x").to_int()
					var y = file.get_named_attribute_value("y").to_int()
					file.read()
					var ext = "res://Maps/" + file.get_node_data()
					print(ext,"|",x,"|",y)
					_parse_cave(ext,x,y,grid,map)
				file.read()
	
	print("MAP-x_size: ",x_size)
	print("MAP-y_size: ",y_size)
	return self._generate_navi_3D(map,x_size,y_size,0)

func _parse_cave(ext,x,y,grid,map):
	var file = XMLParser.new()
	var x_size = 1
	var y_size = 1
	var z_size = 1
	var x_offset = x
	var y_offset = y
	file.open(ext)
	while !file.read():
		if(file.get_node_name().match("cave") && file.has_attribute("name")):
				print("-> ",file.get_named_attribute_value("name"))
		elif(file.get_node_name().match("size") && file.get_node_type() == file.NODE_ELEMENT):
			file.read()
			file.read()
			file.read()
			x_size=file.get_node_data().to_int()
			file.read()
			file.read()
			file.read()
			file.read()
			y_size=file.get_node_data().to_int()
			file.read()
			file.read()
			file.read()
			file.read()
			z_size=file.get_node_data().to_int()
		elif(file.get_node_name().match("block") && file.get_node_type() == file.NODE_ELEMENT):
			var x
			var y
			var z
			var item
			file.read()
			file.read()
			file.read()
			x=file.get_node_data().to_int()
			file.read()
			file.read()
			file.read()
			file.read()
			y=file.get_node_data().to_int()
			file.read()
			file.read()
			file.read()
			file.read()
			z=file.get_node_data().to_int()
			file.read()
			file.read()
			file.read()
			file.read()
			item=file.get_node_data().to_int()
			map.set_cell_item(x_offset+x*grid,y_offset+y*grid,z*grid,item)
			print("MAP: ",x*grid,"|",y*grid,"|",item)

func generate_navi_mesh(Vector3arr):
	var up = Vector3(0, 1, 0)
	
	# PRIMITIVE_POINTS = 0 - Render array as points (one vertex equals one point).
	# PRIMITIVE_LINES = 1 - Render array as lines (every two vertices a line is created).
	# PRIMITIVE_LINE_STRIP = 2 - Render array as line strip.
	# PRIMITIVE_LINE_LOOP = 3 - Render array as line loop (like line strip, but closed).
	# PRIMITIVE_TRIANGLES = 4 - Render array as triangles (every three vertices a triangle is created).
	# PRIMITIVE_TRIANGLE_STRIP = 5 - Render array as triangle strips.
	# PRIMITIVE_TRIANGLE_FAN = 6 - Render array as triangle fans.
	
	var surface = SurfaceTool.new()
	surface.begin(4)
	
	if(material):
		surface.set_material(material)
	
	for i in range(0,Vector3arr.size(),3):
		surface.add_uv(Vector2(0, 1))
		surface.add_normal(up)
		surface.add_vertex(Vector3arr.get(i))
		surface.add_uv(Vector2(1, 0))
		surface.add_normal(up)
		surface.add_vertex(Vector3arr.get(i+1))
		surface.add_uv(Vector2(1, 1))
		surface.add_normal(up)
		surface.add_vertex(Vector3arr.get(i+2))
	
	return surface.commit()

func _generate_navi(gridMap,x_size,y_size):
	var cell_size = gridMap.get_cell_size()
	var hover = 0#0.01
	var navi = Vector3Array()
	for x in range(0,x_size):
		for y in range(0,y_size):
			#print(gridMap.get_cell_item(x,y,0))
			if(gridMap.get_cell_item(x,y,0) == -1):
				if!(gridMap.get_cell_item(x-1,y,0) == 1 && gridMap.get_cell_item(x+1,y,0) == 1 || gridMap.get_cell_item(x,y-1,0) == -1): #nur wenns kein schacht ist
					navi.push_back(Vector3(x*cell_size, y*cell_size+hover, 0))
					navi.push_back(Vector3(x*cell_size+cell_size, y*cell_size+hover, 0))
					navi.push_back(Vector3(x*cell_size+cell_size, y*cell_size+hover, cell_size))
					
					navi.push_back(Vector3(x*cell_size+cell_size, y*cell_size+hover, cell_size))
					navi.push_back(Vector3(x*cell_size, y*cell_size+hover, cell_size))
					navi.push_back(Vector3(x*cell_size, y*cell_size+hover, 0))
				else:
					navi.push_back(Vector3(x*cell_size, y*cell_size+cell_size, hover))
					navi.push_back(Vector3(x*cell_size+cell_size, y*cell_size+cell_size, hover))
					navi.push_back(Vector3(x*cell_size+cell_size, y*cell_size, hover))
					
					navi.push_back(Vector3(x*cell_size+cell_size, y*cell_size, hover))
					navi.push_back(Vector3(x*cell_size, y*cell_size, hover))
					navi.push_back(Vector3(x*cell_size, y*cell_size+cell_size, hover))
					if(gridMap.get_cell_item(x-1,y,0) == -1):
						navi.push_back(Vector3((x-1)*cell_size, y*cell_size+cell_size, hover))
						navi.push_back(Vector3((x-1)*cell_size+cell_size, y*cell_size+cell_size, hover))
						navi.push_back(Vector3((x-1)*cell_size+cell_size, y*cell_size, hover))
						
						navi.push_back(Vector3((x-1)*cell_size+cell_size, y*cell_size, hover))
						navi.push_back(Vector3((x-1)*cell_size, y*cell_size, hover))
						navi.push_back(Vector3((x-1)*cell_size, y*cell_size+cell_size, hover))
					if(gridMap.get_cell_item(x+1,y,0) == -1):
						navi.push_back(Vector3((x+1)*cell_size, y*cell_size+cell_size, hover))
						navi.push_back(Vector3((x+1)*cell_size+cell_size, y*cell_size+cell_size, hover))
						navi.push_back(Vector3((x+1)*cell_size+cell_size, y*cell_size, hover))
						
						navi.push_back(Vector3((x+1)*cell_size+cell_size, y*cell_size, hover))
						navi.push_back(Vector3((x+1)*cell_size, y*cell_size, hover))
						navi.push_back(Vector3((x+1)*cell_size, y*cell_size+cell_size, hover))
					if(gridMap.get_cell_item(x,y-1,0) == -1):
						navi.push_back(Vector3(x*cell_size, (y-1)*cell_size+cell_size, hover))
						navi.push_back(Vector3(x*cell_size+cell_size, (y-1)*cell_size+cell_size, hover))
						navi.push_back(Vector3(x*cell_size+cell_size, (y-1)*cell_size, hover))
						
						navi.push_back(Vector3(x*cell_size+cell_size, (y-1)*cell_size, hover))
						navi.push_back(Vector3(x*cell_size, (y-1)*cell_size, hover))
						navi.push_back(Vector3(x*cell_size, (y-1)*cell_size+cell_size, hover))
	return navi

func _generate_navi_3D(gridMap,x_size,y_size,z_size):
	var cell_size = gridMap.get_cell_size()
	var navi = Vector3Array()
	for x in range(0,x_size):
		for y in range(0,y_size):
			for z in range(z_size,2):
				if(gridMap.get_cell_item(x,y,z) == -1):
					if(_is_schacht(gridMap,x,y,z)):
						navi.push_back(Vector3(x*cell_size, y*cell_size+cell_size, z*cell_size))
						navi.push_back(Vector3(x*cell_size+cell_size, y*cell_size+cell_size, z*cell_size))
						navi.push_back(Vector3(x*cell_size+cell_size, y*cell_size, z*cell_size))
						
						navi.push_back(Vector3(x*cell_size+cell_size, y*cell_size, z*cell_size))
						navi.push_back(Vector3(x*cell_size, y*cell_size, z))
						navi.push_back(Vector3(x*cell_size, y*cell_size+cell_size, z*cell_size))
				pass
	return navi

func _is_schacht(gridMap,x,y,z):
	var con_1 = (gridMap.get_cell_item(x,y,z) == -1)
	var con_2 = (gridMap.get_cell_item(x-1,y,z) == -1 || gridMap.get_cell_item(x+1,y,z) == -1)
	var con_3 = (gridMap.get_cell_item(x,y-1,z) == -1 || gridMap.get_cell_item(x,y+1,z) == -1)
	var con_4 = (gridMap.get_cell_item(x-1,y-1,z) == -1 || gridMap.get_cell_item(x+1,y+1,z) == -1 || gridMap.get_cell_item(x+1,y-1,z) == -1 || gridMap.get_cell_item(x-1,y+1,z) == -1)
	return con_1 && con_2 && con_3 && con_4
	pass








