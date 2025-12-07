extends MeshInstance3D

@export var speed: float = 20.0
@export var path_points: Array[Node3D]
var current_target_index: int = 0

func _ready():
	_setup_damage_area()

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

func _setup_damage_area():
	if not mesh:
		push_warning("No mesh assigned to MeshInstance3D. Cannot generate collision shape.")
		return

	var area = Area3D.new()
	area.name = "DamageArea"
	add_child(area)

	var col_shape_node = CollisionShape3D.new()
	col_shape_node.name = "CollisionShape"
	area.add_child(col_shape_node)

	var shape = mesh.create_convex_shape(true, true)
	col_shape_node.shape = shape

	area.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D):
	if body.is_in_group("player"):
		if Globals and Globals.player:
			Globals.player.take_damage(50, true, global_position)
