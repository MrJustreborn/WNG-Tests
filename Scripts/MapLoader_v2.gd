#****************************************
# MapLoader_v2.gd
#
#
#
#
#
#****************************************

const ERR_MAP_NOT_SET = -1
const ERR_PATH_NOT_VALID = -2

var material = null		#FixedMaterial
var map = null			#GridMap
var navi = null			#Vector3Array
var naviMesh = null		#SurfaceTool -> Mesh

var x_size = 0
var y_size = 0

var navMeshInst = null	#NavigationMeshInstance
var meshInst = null		#MeshInstance

#****************************************
#	Init
#****************************************
func setMaterial(mat):
	self.material = mat

func setMap(gridMap):
	self.map = gridMap

#****************************************
#	Parser
#****************************************
func loadMap(path):
	if(map == null):
		return ERR_MAP_NOT_SET
	if!(File.new().file_exists(path)):
		return ERR_PATH_NOT_VALID
	var file = XMLParser.new()
	file.open(path)
	while !file.read():
		if(file.get_node_name().match("map") && file.get_node_type() == file.NODE_ELEMENT):
			self._parseMap(file)

#	Hilfsfunktionen
func _parseMap(file):
	print("parseMap")
	while !(file.get_node_name().match("map") && file.get_node_type() == file.NODE_ELEMENT_END):
		if(file.get_node_name().match("size") && file.get_node_type() == file.NODE_ELEMENT):
			self._parseMapSize(file)
		if(file.get_node_name().match("data") && file.get_node_type() == file.NODE_ELEMENT):
			self._parseMapData(file)
		if(file.read()):
			return #ERR_PARSE

func _parseMapSize(file):
	print("parseMapSize")
	while !(file.get_node_name().match("size") && file.get_node_type() == file.NODE_ELEMENT_END):
		if(file.get_node_name().match("int") && file.get_node_type() == file.NODE_ELEMENT):
			if(file.get_named_attribute_value("name").match("x_size")):
				while !file.get_node_data():
					if(file.read()):
						return #ERR_PARSE
				x_size = file.get_node_data().to_int()
			if(file.get_named_attribute_value("name").match("y_size")):
				while !file.get_node_data():
					if(file.read()):
						return #ERR_PARSE
				y_size = file.get_node_data().to_int() *-1
			if(file.get_named_attribute_value("name").match("default")):
				while !file.get_node_data():
					if(file.read()):
						return #ERR_PARSE
				self._initMap(0,0,x_size,y_size,file.get_node_data().to_int())
		if(file.read()):
			return #ERR_PARSE

func _parseMapData(file):
	print("parseMapData")
	while !(file.get_node_name().match("data") && file.get_node_type() == file.NODE_ELEMENT_END):
		while !(file.get_node_name().match("block") && file.get_node_type() == file.NODE_ELEMENT_END):
			if(file.get_node_name().match("ext") && file.get_node_type() == file.NODE_ELEMENT):
				self._parseMapDataExt(file)
			if(file.read()):
				return #ERR_PARSE
		if(file.read()):
			return #ERR_PARSE

func _parseMapDataExt(file):
	print("parseMapDataExt")
	while !(file.get_node_name().match("ext") && file.get_node_type() == file.NODE_ELEMENT_END):
		if(file.get_node_name().match("ext") && file.get_node_type() == file.NODE_ELEMENT):
			var x = file.get_named_attribute_value("x").to_int()
			var y = file.get_named_attribute_value("y").to_int()
			while !file.get_node_data():
				if(file.read()):
					return #ERR_PARSE
			self._parseCave(x,y,file.get_node_data())
		if(file.read()):
			return #ERR_PARSE

func _parseCave(x_off,y_off,path):
	var data = {}
	var len = 8
	print("parseCave","|",x_off,"|",y_off,"|",path)
	data["offset"]=[x_off,y_off,len]
	data[0]=[0,0,0,-1]
	data[1]=[1,0,0,-1]
	data[2]=[0,-1,0,-1]
	data[3]=[1,-1,0,-1]
	data[4]=[0,0,1,-1]
	data[5]=[1,0,1,-1]
	data[6]=[0,-1,1,-1]
	data[7]=[1,-1,1,-1]
	print(data)
	self._addToMap(x_off,y_off,data)
	
	"""
	map.set_cell_item(1,-1,0,-1)
	map.set_cell_item(1,-2,0,-1)
	map.set_cell_item(2,-1,0,-1)
	map.set_cell_item(2,-2,0,-1)
	
	map.set_cell_item(1,-1,1,-1)
	map.set_cell_item(1,-2,1,-1)
	map.set_cell_item(2,-1,1,-1)
	map.set_cell_item(2,-2,1,-1)
	"""

#	Zuweisung der Map
func _initMap(x,y,w,h,type):
	print("initMap: ",x,"|",y,"|",w,"|",h,"|",type)
	for i in range(x,w):
		for j in range(h,y):
			for z in range(-1,2):
				map.set_cell_item(i,j,z,type)

func _addToMap(x,y,data):
	for i in range(data["offset"][2]):
			map.set_cell_item(x+data[i][0],y+data[i][1],data[i][2],data[i][3])

#****************************************
#	getTest	1
#****************************************
func getNaviMesh():
	if(naviMesh == null):
		self._generateNaviMesh()
	return naviMesh

func getNaviVertices():
	if(navi == null):
		self._generateNaviVertices()
	return navi

#****************************************
#	getTest	2
#****************************************
func getNavigationMeshInstance():
	return navMeshInst

func getMeshInstance():
	return meshInst

#****************************************
#	update (is bei getTest 2 sinnvoll)
#****************************************
func update():
	pass

#****************************************
#	Berechnung vom NavigationMesh
#****************************************
func _generateNaviMesh():
	if(navi == null):
		self._generateNaviVertices()
	var up = Vector3(0, 1, 0)
	# PRIMITIVE_POINTS = 0 - Render array as points (one vertex equals one point).
	# PRIMITIVE_LINES = 1 - Render array as lines (every two vertices a line is created).
	# PRIMITIVE_LINE_STRIP = 2 - Render array as line strip.
	# PRIMITIVE_LINE_LOOP = 3 - Render array as line loop (like line strip, but closed).
	# PRIMITIVE_TRIANGLES = 4 - Render array as triangles (every three vertices a triangle is created).
	# PRIMITIVE_TRIANGLE_STRIP = 5 - Render array as triangle strips.
	# PRIMITIVE_TRIANGLE_FAN = 6 - Render array as triangle fans.
	naviMesh = SurfaceTool.new()
	naviMesh.begin(naviMesh.PRIMITIVE_TRIANGLES)
	if(material):
		naviMesh.set_material(material)
	for i in range(0,navi.size(),3):
		naviMesh.add_uv(Vector2(0, 1))
		naviMesh.add_normal(up)
		naviMesh.add_vertex(navi.get(i))
		naviMesh.add_uv(Vector2(1, 0))
		naviMesh.add_normal(up)
		naviMesh.add_vertex(navi.get(i+1))
		naviMesh.add_uv(Vector2(1, 1))
		naviMesh.add_normal(up)
		naviMesh.add_vertex(navi.get(i+2))
	naviMesh = naviMesh.commit()

func _generateNaviVertices():
	navi = Vector3Array()
	pass
