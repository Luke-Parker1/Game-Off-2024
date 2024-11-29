extends CanvasLayer

func _process(_delta):
	$HighScore.text = "High Score: " + str(GlobalScore.high_score)

func _on_play_button_pressed():
	GlobalScore.score = 0
	get_tree().change_scene_to_file("res://Scenes/level.tscn")


func _on_how_to_play_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/how_to_play.tscn")
