extends MeshInstance3D

@export var speed: float = 10.0
@export var path_points: Array[Node3D]

var current_target_index: int = 0

#func _ready():
	#if path_points.size() > 0:
		## Optional: Snap car to start at the first point immediately
		#global_position = path_points[0].global_position

func _process(delta):
	if path_points.is_empty():
		return

	var target_node = path_points[current_target_index]
	var target_pos = target_node.global_position
	
	var target_on_plane = Vector3(target_pos.x, global_position.y, target_pos.z)
	
	var new_pos = global_position.move_toward(target_on_plane, speed * delta)
	global_position = new_pos
	
	if global_position.distance_to(target_on_plane) > 0.1:
		look_at(target_on_plane, Vector3.BACK)
		rotation_degrees.x = -90
		rotation_degrees.y -= 180

	if global_position.distance_to(target_on_plane) < 0.1:
		current_target_index = (current_target_index + 1) % path_points.size()
