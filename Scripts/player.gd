extends CharacterBody2D

@export var speed := 60.0

@export var dash_speed := 400.0
var dashing := false
var dash_direction : Vector2

var mind_wipe_targets : Array

func _ready():
	$MindWipeCooldown.start()
	$DashCooldown.start()
	$TeleportCooldown.start()
	
	self.position.x = randf_range(59, 1223)
	self.position.y = randf_range(174, 638)

func _physics_process(_delta):
	var direction = Input.get_vector("left", "right", "up", "down")
	if Input.is_action_just_pressed("left_click") && $DashCooldown.is_stopped() && !dashing:
		dash_direction = self.position.direction_to(get_global_mouse_position()).normalized()
		dashing = true
		$DashTimer.start()
		$DashEffectTimer.start()
		$DashSFX.play()
	
	if Input.is_action_just_pressed("right_click") && $TeleportCooldown.is_stopped():
		self.global_position = get_global_mouse_position()
		$TeleportCooldown.start()
		$TeleportSFX.play()
	
	if dashing:
		velocity = dash_direction * dash_speed
	else:
		velocity = direction * speed
	
	if $FlashAnimation.is_playing():
		$Area2D/CollisionShape2D.disabled = false
	else:
		$Area2D/CollisionShape2D.disabled = true
		
		# Mind wipe people after animation finishes
		if !mind_wipe_targets.is_empty():
			for i in mind_wipe_targets:
				i.aware = false
	
	if !$Area2D.get_overlapping_bodies().is_empty():
		for i in $Area2D.get_overlapping_bodies():
			if i in get_tree().get_nodes_in_group("Person"):
				mind_wipe_targets.append(i)
	
	move_and_slide()

func _process(_delta):
	if velocity == Vector2(0,0):
		$AnimatedSprite2D.play("default")
	else:
		$AnimatedSprite2D.play("walk")
	
	# Handle mind wipe cooldown
	if Input.is_action_just_pressed("space") && $MindWipeCooldown.is_stopped():
		$MindWipeCooldown.start()
		$FlashAnimation.visible = true
		$FlashAnimation.play("flash")
		$MindWipeSFX.play()


func _on_flash_animation_animation_finished():
	$FlashAnimation.visible = false


func _on_mind_wipe_cooldown_timeout():
	$MindWipeCooldown.stop()


func _on_dash_timer_timeout():
	dashing = false
	$DashTimer.stop()
	$DashEffectTimer.stop()
	$DashCooldown.start()


func _on_dash_cooldown_timeout():
	$DashCooldown.stop()


func _on_teleport_cooldown_timeout():
	$TeleportCooldown.stop()

func create_dash_effect():
	var dash_silhouette = $AnimatedSprite2D.duplicate()
	get_parent().add_child(dash_silhouette)
	dash_silhouette.global_position = global_position
	
	var animation_time = $DashTimer.wait_time / 4
	
	await get_tree().create_timer(animation_time).timeout
	dash_silhouette.modulate.a = 0.4
	await get_tree().create_timer(animation_time).timeout
	dash_silhouette.modulate.a = 0.2
	dash_silhouette.queue_free()


func _on_dash_effect_timer_timeout():
	create_dash_effect()
