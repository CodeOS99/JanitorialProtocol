extends CharacterBody3D

const SPEED := 5.0
var first = true

@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D

func _physics_process(delta: float) -> void:
	if first:
		await get_tree().process_frame
		first = false

	# Always update target
	navigation_agent_3d.target_position = Globals.player.global_position

	# Wait until the agent has a valid path
	if navigation_agent_3d.is_navigation_finished():
		velocity = Vector3.ZERO
		move_and_slide()
		return

	var dest = navigation_agent_3d.get_next_path_position()
	var dir = (dest - global_position).normalized()

	velocity.x = dir.x * SPEED
	velocity.z = dir.z * SPEED

	# Gravity
	#if not is_on_floor():
		#velocity.y -= 9.8 * delta
	look_at(Globals.player.global_position)
	rotation_degrees.y -= 180

	move_and_slide()
