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
		# If aware, remove aware targets
		if person.aware:
			for i in person_group:
				if i.aware:
					person_group.erase(i)
		
		if !person_group.is_empty():
			# Make it more likely to target person closer to self
			person_group.sort_custom(sort_distance)
			for i in person_group:
				if randi_range(1, 3) != 3:
					target = i
					break
			
			if target == null:
				target = person_group.pick_random()
			person.target = target

func State_Update(delta: float):
	if person:
		if !person.talkers.is_empty():
			Transitioned.emit(self, "Listen")

func State_Physics_Update(delta: float):
	#Go to person
	if person and target:
		if person_group.is_empty():
			Transitioned.emit(self, "Idle")
		
		var direction = target.global_position - person.global_position
		person.velocity = direction.normalized() * move_speed
		
		if direction.length() < 130:
			Transitioned.emit(self, "Talk")

func sort_distance(a : CharacterBody2D, b : CharacterBody2D):
	if person.global_position.distance_squared_to(a.global_position) < person.global_position.distance_squared_to(b.global_position):
		return true
	return false
