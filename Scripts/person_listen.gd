extends State
class_name PersonListen

@export var person : CharacterBody2D
var talkers : Array

func Enter():
	if person:
		person.velocity = Vector2(0, 0)

func State_Update(delta: float):
	if person:
		talkers = person.talkers
	
	if talkers.is_empty():
		Transitioned.emit(self, "Idle")
