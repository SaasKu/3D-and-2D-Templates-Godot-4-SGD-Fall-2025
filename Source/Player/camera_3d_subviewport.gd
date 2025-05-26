extends Camera3D
@onready var camera:Camera3D = %Camera3D

func _ready():
	pass
	
func _process(delta):
	transform = camera.transform
