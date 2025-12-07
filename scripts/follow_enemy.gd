extends CharacterBody3D

const SPEED := 5.0
const UPDATE_FREQUENCY := 0.2 # position update

@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D

var damage: int = 10
var _update_timer: float = 0.0

func _ready() -> void:
	navigation_agent_3d.path_desired_distance = 1.0
	navigation_agent_3d.target_desired_distance = 1.0
	call_deferred("actor_setup")

func actor_setup():
	await get_tree().physics_frame

func _physics_process(delta: float) -> void:
	_update_timer += delta
	if _update_timer >= UPDATE_FREQUENCY:
		_update_target_position()
		_update_timer = 0.0

	if navigation_agent_3d.is_navigation_finished():
		velocity = Vector3.ZERO
		move_and_slide()
		return

	var current_agent_position = global_position
	var next_path_position = navigation_agent_3d.get_next_path_position()
	
	var new_velocity = (next_path_position - current_agent_position).normalized() * SPEED
	
	velocity.x = new_velocity.x
	velocity.z = new_velocity.z

	look_at_y(Globals.player.global_position)
	rotation_degrees.y -= 180

	move_and_slide()

func _update_target_position():
	if Globals.player:
		var flat_target = Vector3(
			Globals.player.global_position.x,
			global_position.y, 
			Globals.player.global_position.z
		)
		navigation_agent_3d.target_position = flat_target

func look_at_y(target: Vector3):
	var to_target = target - global_position
	to_target.y = 0
	if to_target.length_squared() > 0.001:
		look_at(global_position + to_target)

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		Globals.player.take_damage(damage, true, global_position)
