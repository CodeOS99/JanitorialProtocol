extends Area3D

@export var value: int = 1
@export var volume: int = 1

func hovered_over() -> bool:
	if Globals.curr_volume + volume > Globals.max_volume:
		$"SpaceFullLabel".visible = true
		$"PickupLabel".visible = false
		return false
	$"SpaceFullLabel".visible = false
	$"PickupLabel".visible = true
	$"../mesh".hovered_over()
	return true

func hovered_exit():
	$PickupLabel.visible = false
	$SpaceFullLabel.visible = false
	$"../mesh".hovered_exit()

func interact():
	if Globals.curr_volume + volume > Globals.max_volume:
		return
	Globals.player.add_trash(value, volume)
	$"..".queue_free()
