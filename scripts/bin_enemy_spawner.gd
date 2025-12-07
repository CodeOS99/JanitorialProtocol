extends Node3D

@export var enemy = preload("res://scenes/bin_enemy.tscn")
@export var spawn_radius = 10.0
@export var spawn_interval = 5.0

func _ready() -> void:
	var timer = Timer.new()
	timer.wait_time = spawn_interval
	timer.one_shot = false
	timer.autostart = true
	add_child(timer)
	timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout():
	spawn_near_player()

func spawn_near_player():
	var player_pos = Globals.player.global_position
	player_pos.y = 0
	var offset = random_offset(spawn_radius)
	var obj = enemy.instantiate()
	add_child(obj)
	obj.global_position = player_pos + offset

func random_offset(radius: float):
	var angle = randf()* TAU
	var dist = radius
	var x = cos(angle) * dist
	var z = sin(angle) * dist
	return Vector3(x, 0, z)
