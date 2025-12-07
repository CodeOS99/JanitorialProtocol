extends Node3D

var things = [preload("res://scenes/trash_can.tscn"), preload("res://scenes/paper.tscn")]
@export var spawn_radius = 15.0
@onready var plastic_bottles: Node3D = $"../PlasticBottles"

func _ready() -> void:
	spawn_things()

func spawn_things():
	for thing in things:
		for child in plastic_bottles.get_children():
			spawn_random_new(child, thing)

func spawn_random_new(child:Node3D, thing: PackedScene):
	var obj = thing.instantiate()
	add_child(obj)
	obj.global_position = child.global_position + random_offset()

func random_offset():
	var angle = randf() * TAU
	var dist = randf_range(.25, 1) * spawn_radius
	
	var offset_x = cos(angle) * dist
	var offset_z = cos(angle) * dist
	
	return Vector3(offset_x, 0, offset_z)
