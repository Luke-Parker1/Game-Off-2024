extends State
class_name PersonTalk

@export var person : CharacterBody2D
var target : CharacterBody2D
var talk_time : float
var talk_area : Area2D

func Enter():
	if person:
		talk_area = person.find_child("TalkArea")
		target = person.target
		person.velocity = Vector2(0, 0)
		if target:
			talk_area.rotation = global_position.direction_to(target.position).angle() + 90
		talk_area.get_child(0).disabled = false
	talk_time = randf_range(5, 10)

func State_Update(delta: float):
	if person:
		if !person.talkers.is_empty():
			for i in person.talkers:
				if i.volume > person.volume:
					Transitioned.emit(self, "Listen")
	if talk_time > 0:
		talk_time -= delta
	else:
		Transitioned.emit(self, "Idle")

func Exit():
	if person:
		if !person.listeners.is_empty() and person.aware:
			for i in person.listeners:
				if !i.aware:
					i.aware = true
		
	if talk_area:
		talk_area.get_child(0).disabled = true
