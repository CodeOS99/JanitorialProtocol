extends Node3D

@export var bob_height: float = 0.75
@export var bob_speed: float = 3.0
@export var rotate_speed: float = 90.0

@export var outline_color: Color = Color(1, 1, 0, 1)
@export var mesh_instance: MeshInstance3D

var start_position: Vector3
var time_passed: float = 0.0
var is_hovered: bool = false

func _ready() -> void:
	start_position = self.global_position

func _process(delta: float) -> void:
	time_passed += delta
	
	var bob_offset = sin(time_passed * bob_speed) * bob_height
	position.y = start_position.y + bob_offset
	rotate_y(deg_to_rad(rotate_speed*delta))

func hovered_over():
	if not is_hovered:
		is_hovered = true
		_set_outline(true)

func hovered_exit():
	if is_hovered:
		is_hovered = false
		_set_outline(false)

func _set_outline(enabled: bool):
	if enabled:
		var shader_material = ShaderMaterial.new()
		shader_material.shader = preload('res://scripts/shaders/outline_shader.gdshader')
		shader_material.set_shader_parameter("outline_color", outline_color)
		shader_material.set_shader_parameter("outline_width", 1)
		mesh_instance.material_overlay = shader_material
	else:
		mesh_instance.material_overlay = null
