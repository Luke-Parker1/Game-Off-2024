extends Control

var visible_options := false
var exit := false
var lost := false

func _ready():
	# Be active even when the game is paused
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	$"Return to game".disabled = true
	$"Return to game".hide()
	$"Next Round".disabled = true
	$"Next Round".hide()
	$"Exit to Menu".disabled = true
	$"Exit to Menu".hide()

func _process(_delta):
	if Input.is_action_just_pressed("escape") && !exit:
		visible_options = !visible_options
	if visible_options:
		# Options when player presses escape
		get_tree().paused = true
		$"Return to game".disabled = false
		$"Return to game".show()
		$"Exit to Menu".disabled = false
		$"Exit to Menu".show()
	elif exit:
		# Options when player beats level
		get_tree().paused = true
		$"Exit to Menu".disabled = false
		$"Exit to Menu".show()
		$"Next Round".disabled = false
		$"Next Round".show()
		$WinLabel.visible = true
	elif lost:
		#Options when player loses
		get_tree().paused = true
		$"Exit to Menu".disabled = false
		$"Exit to Menu".position.x = 384
		$"Exit to Menu".show()
		$LoseLabel.visible = true
	else:
		get_tree().paused = false
		$"Return to game".disabled = true
		$"Return to game".hide()
		$"Next Round".disabled = true
		$"Next Round".hide()
		$"Exit to Menu".disabled = true
		$"Exit to Menu".hide()
		$WinLabel.visible = false
		$LoseLabel.visible = false


func _on_return_to_game_pressed():
	visible_options = false


func _on_exit_to_menu_pressed():
	get_tree().paused = false
	if GlobalScore.score > GlobalScore.high_score:
		GlobalScore.high_score = GlobalScore.score
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")


func _on_next_round_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
