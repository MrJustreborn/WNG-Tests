extends Node

export var name = ""
export var data = {
	type = "sas",
	test = 33
}

func _init():
	pass

func setName(_name):
	self.name = _name

func getName():
	return name

func printName():
	print(name)

func getData():
	return data
