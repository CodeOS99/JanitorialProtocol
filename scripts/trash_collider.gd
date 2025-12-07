extends Area3D

@export var value: int = 1
@export var volume: int = 1

var can_queue_free := false

func hovered_over() -> bool:
	if Globals.curr_volume + volume > Globals.max_volume:
		$"SpaceFullLabel".visible = true
		$"PickupLabel".visible = false
		return false
	if can_queue_free:
		return false
	$"SpaceFullLabel".visible = false
	$"PickupLabel".visible = true
	$"../mesh".hovered_over()
	return true

func hovered_exit():
	if can_queue_free:
		return
	$PickupLabel.visible = false
	$SpaceFullLabel.visible = false
	$"../mesh".hovered_exit()

func interact():
	if Globals.curr_volume + volume > Globals.max_volume or can_queue_free:
		return
	Globals.player.add_trash(value, volume)
	$"../mesh".queue_free()
	can_queue_free = true
	$TrashCollectedParticle.emitting = true
	$PickupLabel.visible = false
	$SpaceFullLabel.visible = false

func _process(delta: float) -> void:
	if can_queue_free and not $TrashCollectedParticle.emitting:
		$"..".queue_free()
