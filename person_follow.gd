extends State
class_name PersonFollow

@export var person : CharacterBody2D
@export var move_speed := 30.0

var target : CharacterBody2D
var person_group : Array

func Enter():
	# Set the target equal to a random person that is not self
	if person:
		person_group = get_tree().get_nodes_in_group("Person").duplicate()
		person_group.erase(person)
		target = person_group.pick_random()
		person.target = target

func State_Update(delta: float):
	if person:
		if !person.talkers.is_empty():
			Transitioned.emit(self, "Listen")

func State_Physics_Update(delta: float):
	#Go to person
	if person and target:
		var direction = target.global_position - person.global_position
		person.velocity = direction.normalized() * move_speed
		
		if direction.length() < 100:
			Transitioned.emit(self, "Talk")
