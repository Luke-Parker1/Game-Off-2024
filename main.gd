extends Node2D

var volume = 0
func _ready():
	for i in get_tree().get_nodes_in_group("Person"):
		volume += 1
		i.volume = volume
