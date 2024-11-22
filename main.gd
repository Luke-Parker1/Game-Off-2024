extends Node2D

var volume = 0

#volume of all people aware of the secret
var aware_volume : int

var person_group : Array

func _ready():
	$MindEraseBar.max_value = $Player.flash_cooldown
	
	person_group = get_tree().get_nodes_in_group("Person").duplicate()
	aware_volume = person_group.size() + 1
	person_group.pick_random().aware = true
	for i in person_group:
		volume += 1
		i.not_aware_volume = volume
		i.aware_volume = aware_volume
		if i.aware:
			person_group.erase(i)
	
	if !person_group.is_empty():
		person_group.pick_random().cannot_know = true
	

func _process(delta):
	$MindEraseBar.value = $Player.active_flash_cooldown
