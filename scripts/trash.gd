extends Node3D

@export var bob_height: float = 0.75
@export var bob_speed: float = 3.0
@export var rotate_speed: float = 90.0

@export var outline_color: Color = Color(1, 1, 0, 1)

var start_position: Vector3
var time_passed: float = 0.0

func _ready() -> void:
	start_position = self.global_position

func _process(delta: float) -> void:
	time_passed += delta
	
	var bob_offset = sin(time_passed * bob_speed) * bob_height
	position.y = start_position.y + bob_offset
	rotate_y(deg_to_rad(rotate_speed*delta))

func hovered_over():
	print("overed hover")
