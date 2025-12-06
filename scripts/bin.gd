extends Node3D

@export var outline_color: Color = Color(0, 1, 0, 1)
var mesh_instances: Array[MeshInstance3D] = [$Cylinder_596, $Cube_1543]

var is_hovered: bool = false

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
		for mesh_instance in mesh_instances:
			mesh_instance.material_overlay = shader_material
	else:
		for mesh_instance in mesh_instances:
			mesh_instance.material_overlay = null
