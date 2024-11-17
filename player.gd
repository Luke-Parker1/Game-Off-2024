extends CharacterBody2D

@export var speed := 60.0

# Time in seconds that it takes for the memory wipe ability to recharge
@export var flash_cooldown := 3.0
var active_flash_cooldown := 0.0
var flash_cooldown_active := false

func _physics_process(delta):
	var direction = Input.get_vector("left", "right", "up", "down")
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
	
	if Input.is_action_just_pressed("space") && !flash_cooldown_active:
		print("pressed")
		$FlashAnimation.visible = true
		$FlashAnimation.play("flash")
		flash_cooldown_active = true
		active_flash_cooldown = flash_cooldown  
	if active_flash_cooldown > 0 && flash_cooldown_active:
		active_flash_cooldown -= delta
		print (active_flash_cooldown)
		if active_flash_cooldown <= 0:
			flash_cooldown_active = false


func _on_flash_animation_animation_finished():
	$FlashAnimation.visible = false
