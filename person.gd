extends CharacterBody2D

var target : CharacterBody2D
var volume : int
# Array of all people who this person is in the TalkArea of
var talkers : Array

#Array of all people in the TalkArea of this person
var listeners : Array

func _physics_process(delta: float):
	if $TalkArea/CollisionPolygon2D.disabled:
		$TalkArea/CollisionPolygon2D.visible = false
	else:
		$TalkArea/CollisionPolygon2D.visible = true
	if !$TalkArea.get_overlapping_bodies().is_empty():
		for i in $TalkArea.get_overlapping_bodies():
			if i not in listeners:
				listeners.append(i)
				i.talkers.append(self)
	
	if $TalkArea/CollisionPolygon2D.disabled:
		if !listeners.is_empty():
			for i in listeners:
				i.talkers.erase(self)
			listeners.clear()
	move_and_slide()

#func _on_talk_area_body_entered(body):
	#if body.is_in_group("Person") and body != self:
		#body.talkers.append(self)
		#print(body.talkers)
#
#
#func _on_talk_area_body_exited(body):
	#if body.is_in_group("Person") and body != self:
		#body.talkers.erase(self)
