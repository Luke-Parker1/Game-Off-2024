extends ProgressBar


func _process(delta):
	if value == max_value:
		$Label.visible = true
	else:
		$Label.visible = false
