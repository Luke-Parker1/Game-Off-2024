extends Node2D

var volume = 0

#volume of all people aware of the secret
var aware_volume : int

func _ready():
	aware_volume = get_tree().get_nodes_in_group("Person").size() + 1
	for i in get_tree().get_nodes_in_group("Person"):
		volume += 1
		i.not_aware_volume = volume
		i.aware_volume = aware_volume
	
	get_tree().get_nodes_in_group("Person").pick_random().aware = true
