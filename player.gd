extends CharacterBody2D

@export var speed := 60.0

@export var dash_speed := 400.0
var dashing := false
var dash_direction : Vector2
var dash_cooldown_active := false

var flash_cooldown_active := false

func _physics_process(delta):
	var direction = Input.get_vector("left", "right", "up", "down")
	if Input.is_action_just_pressed("left_click") && !dash_cooldown_active:
		dash_direction = self.position.direction_to(get_global_mouse_position()).normalized()
		dashing = true
		$DashTimer.start()
	
	if dashing:
		velocity = dash_direction * dash_speed
	else:
		velocity = direction * speed
	
	if $FlashAnimation.is_playing():
		$Area2D/CollisionShape2D.disabled = false
	else:
		$Area2D/CollisionShape2D.disabled = true
	
	if !$Area2D.get_overlapping_bodies().is_empty():
		for i in $Area2D.get_overlapping_bodies():
			if i in get_tree().get_nodes_in_group("Person"):
				i.aware = false
	
	move_and_slide()

func _process(delta):
	if velocity == Vector2(0,0):
		$AnimatedSprite2D.play("default")
	else:
		$AnimatedSprite2D.play("walk")
	
	# Handle mind wipe cooldown
	if Input.is_action_just_pressed("space") && !flash_cooldown_active:
		$MindWipeCooldown.start()
		$FlashAnimation.visible = true
		$FlashAnimation.play("flash")
		flash_cooldown_active = true


func _on_flash_animation_animation_finished():
	$FlashAnimation.visible = false


func _on_mind_wipe_cooldown_timeout():
	flash_cooldown_active = false
	$MindWipeCooldown.stop()


func _on_dash_timer_timeout():
	dashing = false
	$DashTimer.stop()
	$DashCooldown.start()
	dash_cooldown_active = true


func _on_dash_cooldown_timeout():
	dash_cooldown_active = false
	$DashCooldown.stop()
