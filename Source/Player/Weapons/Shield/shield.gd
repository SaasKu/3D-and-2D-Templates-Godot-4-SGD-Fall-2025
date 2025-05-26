extends Node3D

func _ready():
	for ch in $".".get_children():
		if ch is MeshInstance3D:
			ch.layers = 2
