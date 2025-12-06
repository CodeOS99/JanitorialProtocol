extends ProgressBar

func _process(delta: float) -> void:
	max_value = Globals.max_volume
	value = Globals.curr_volume
