extends ProgressBar


func _process(_delta):
	if value == max_value:
		$Label.visible = true
	else:
		$Label.visible = false
