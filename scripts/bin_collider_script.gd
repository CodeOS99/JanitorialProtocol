extends Area3D

func hovered_over() -> bool:
	$"../InteractLabel".visible = true
	$"../mesh".hovered_over()
	return true

func hovered_exit():
	$"../InteractLabel".visible = false
	$"../mesh".hovered_exit()

func interact():
	pass
