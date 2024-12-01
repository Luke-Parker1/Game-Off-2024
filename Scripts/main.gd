extends Node2D

var volume = 0

#volume of all people aware of the secret
var aware_volume : int

# Number of people start aware
var aware_num : int

var person_group : Array
var lost := false

@export var person_scene : PackedScene

func _ready():
	# Play sound effects when paused
	$WinSFX.process_mode = Node.PROCESS_MODE_ALWAYS
	$LoseSFX.process_mode = Node.PROCESS_MODE_ALWAYS
	
	spawn_people()
	
	aware_num = floor(GlobalScore.score/2.0) + 1
	if aware_num > 20:
		aware_num = 20
	
	$CanvasLayer/MindEraseBar.max_value = $Player/MindWipeCooldown.wait_time
	$CanvasLayer/DashBar.max_value = $Player/DashCooldown.wait_time
	$CanvasLayer/TeleportBar.max_value = $Player/TeleportCooldown.wait_time
	
	person_group = get_tree().get_nodes_in_group("Person").duplicate()
	aware_volume = person_group.size() + 1
	for i in person_group:
		volume += 1
		i.not_aware_volume = volume
		i.aware_volume = aware_volume
		if aware_num > 0:
			i.aware = true
			aware_num -= 1
		if i.aware:
			person_group.erase(i)
	
	if !person_group.is_empty():
		person_group.pick_random().cannot_know = true
	

func _process(_delta):
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
		# Make sure the exclamation marks are all hidden
		# They would have to wait a frame for them to hide themselves
		for i in get_tree().get_nodes_in_group("Person"):
			i.find_child("AwareBubble").visible = false
		GlobalScore.score += 1
		$CanvasLayer/Score.text = "Score: " + str(GlobalScore.score)
		$WinSFX.play()
		$Options/Control.exit = true
	if lost:
		$LoseSFX.play()
		$Options/Control.lost = true

func spawn_people():
	for i in range(40):
		var person = person_scene.instantiate()
		person.position.x = randf_range(59, 1223)
		person.position.y = randf_range(174, 638)
		add_child(person)
