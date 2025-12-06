extends Label

func _process(delta: float) -> void:
	text = "Money: " + str(Globals.money)
