extends State
class_name PersonIdle

@export var person : CharacterBody2D
@export var move_speed := 10.0

var move_direction : Vector2
var wander_time : float

# Value used to determine whether or not to stay in idle
var continue_num : int

func randomize_wander():
	move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	wander_time = randf_range(1, 5)
	continue_num = randi_range(1, 2)

func Enter():
	randomize_wander()

func State_Update(delta: float):
	if person:
		if !person.talkers.is_empty() and !person.aware:
			Transitioned.emit(self, "Listen")
	if wander_time > 0:
		wander_time -= delta
	else:
		if continue_num == 2:
			Transitioned.emit(self, "Follow")
		randomize_wander()

func State_Physics_Update(delta: float):
	if person:
		person.velocity = move_direction * move_speed
