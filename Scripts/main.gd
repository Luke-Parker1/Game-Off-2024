extends Node2D

var volume = 0

#volume of all people aware of the secret
var aware_volume : int

var person_group : Array

@export var person_scene : PackedScene

func _ready():
	spawn_people()
	
	$CanvasLayer/MindEraseBar.max_value = $Player/MindWipeCooldown.wait_time
	$CanvasLayer/DashBar.max_value = $Player/DashCooldown.wait_time
	$CanvasLayer/TeleportBar.max_value = $Player/TeleportCooldown.wait_time
	
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
	$CanvasLayer/MindEraseBar.value = $Player/MindWipeCooldown.wait_time - $Player/MindWipeCooldown.time_left
	$CanvasLayer/DashBar.value = $Player/DashCooldown.wait_time - $Player/DashCooldown.time_left
	$CanvasLayer/TeleportBar.value = $Player/TeleportCooldown.wait_time - $Player/TeleportCooldown.time_left
	$CanvasLayer/Score.text = "Score: " + str(GlobalScore.score)
	
	# Check if the round is won
	var won := true
	for i in get_tree().get_nodes_in_group("Person"):
		if i.aware:
			won = false
	if won:
		GlobalScore.score += 1
		get_tree().reload_current_scene()

func spawn_people():
	for i in range(40):
		var person = person_scene.instantiate()
		person.position.x = randf_range(59, 1223)
		person.position.y = randf_range(134, 638)
		add_child(person)
