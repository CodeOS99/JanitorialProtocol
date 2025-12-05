extends MeshInstance3D

@export var speed: float = 20.0
@export var path_points: Array[Node3D]
var current_target_index: int = 0

func _process(delta):
	if path_points.is_empty():
		return
	
	var target_node = path_points[current_target_index]
	var target_pos = target_node.global_position
	
	var target_on_plane = Vector3(target_pos.x, global_position.y, target_pos.z)
	
	if global_position.distance_to(target_on_plane) < 0.1:
		current_target_index = (current_target_index + 1) % path_points.size()
		return
	
	look_at(target_on_plane, Vector3.UP)
	rotation_degrees.x = -90
	rotation_degrees.y += 90 * (3 if path_points[0].name in ['RLoop2', 'RLoop4'] else 1)
	
	var new_pos = global_position.move_toward(target_on_plane, speed * delta)
	global_position = new_pos
