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
var og_color = self.modulate

func _process(delta: float):
	if aware:
		self.modulate = Color("Green")
		volume = aware_volume
	else:
		volume = not_aware_volume
		self.modulate = og_color

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
