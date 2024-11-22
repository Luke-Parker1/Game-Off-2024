extends CharacterBody2D

var target : CharacterBody2D
var not_aware_volume : int
# Array of all people who this person is in the TalkArea of
var talkers : Array

#Array of all people in the TalkArea of this person
var listeners : Array

# Whether or not this person is aware of the secret
var aware := false
var aware_volume : int

var volume : int

# True if this person is not supposed to find out the secret
var cannot_know := false

func _process(delta: float):
	if aware:
		$AwareBubble.visible = true
		volume = aware_volume
		if cannot_know:
			print("He found out!")
	else:
		$AwareBubble.visible = false
		volume = not_aware_volume
		
	if velocity != Vector2(0,0):
		if !cannot_know:
			$AnimatedSprite2D.play("walk")
		else:
			$AnimatedSprite2D.play("can't_know_walk")
	elif !$TalkArea/CollisionPolygon2D.disabled:
		if !cannot_know:
			$AnimatedSprite2D.play("talk")
		else:
			$AnimatedSprite2D.play("can't_know_talk")
	else:
		if !cannot_know:
			$AnimatedSprite2D.play("listen")
		else:
			$AnimatedSprite2D.play("can't_know_listen")

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
