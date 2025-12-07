extends Button

func _on_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_game.tscn")
	Globals.curr_value = 0
	Globals.curr_volume = 0
	Globals.max_volume = 10
	Globals.money = 0
