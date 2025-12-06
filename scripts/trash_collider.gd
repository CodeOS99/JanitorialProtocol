extends Area3D

func hovered_over():
	$PickupLabel.visible = true
	$"../mesh".hovered_over()

func hovered_exit():
	$PickupLabel.visible = false
	$"../mesh".hovered_exit()
