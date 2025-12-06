extends Node3D

signal finished

func start():
	$Red.emitting = true
	$Green.emitting = true
	$Blue.emitting = true

func _on_blue_finished() -> void:
	finished.emit()
