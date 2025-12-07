extends CharacterBody3D

const SPEED := 5.0
const UPDATE_FREQUENCY := 0.2 # position update

@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var health_label: Label3D = $HealthLabel

var damage: int = 10
var _update_timer: float = 0.0
const KB_MAG = 3.0
var kb_vel = Vector3.ZERO

@onready var health = 1

# Death/Fade
var _dying: bool = false
var _fade_timer: float = 0.0
@export var fade_duration: float = 1.5 # seconds to fully fade

func _ready() -> void:
	navigation_agent_3d.path_desired_distance = 1.0
	navigation_agent_3d.target_desired_distance = 1.0
	call_deferred("actor_setup")

func actor_setup():
	await get_tree().physics_frame

func _physics_process(delta: float) -> void:
	if _dying:
		_handle_death(delta)
		return

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
	velocity += kb_vel

	move_and_slide()

func _process(delta: float) -> void:
	if health_label:
		health_label.text = "Health: " + str(health)

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
	if _dying:
		return
	if body.is_in_group("player"):
		Globals.player.take_damage(damage, true, global_position)

func take_damage(damage_amount: int, take_kb: bool = false, pos: Vector3 = Vector3.ZERO):
	if _dying:
		return

	health -= damage_amount

	if take_kb:
		var kb_direction = (global_position - pos).normalized()
		kb_direction.y = 0   # ignore vertical knockback
		kb_vel += kb_direction * KB_MAG

	if health <= 0:
		_die()

func _die():
	_dying = true
	velocity = Vector3.ZERO
	kb_vel = Vector3.ZERO
	navigation_agent_3d.target_position = global_position # stop moving

	# Disable collision / area to prevent hitting player
	if has_node("Area3D"):
		$Area3D.monitoring = false

func _handle_death(delta: float):
	_fade_timer += delta
	var alpha = clamp(1.0 - _fade_timer / fade_duration, 0.0, 1.0)

	# Fade all MeshInstance3D children recursively
	_fade_meshes(self, alpha)

	# Fade HealthLabel
	if health_label:
		var color = health_label.modulate
		color.a = alpha
		health_label.modulate = color

	if _fade_timer >= fade_duration:
		queue_free()

func _fade_meshes(node: Node, alpha: float) -> void:
	for child in node.get_children():
		if child is MeshInstance3D:
			for i in range(child.mesh.get_surface_count()):
				var mat = child.get_active_material(i)
				if mat and mat is StandardMaterial3D:
					mat.albedo_color.a = alpha
					child.set_surface_override_material(i, mat)
