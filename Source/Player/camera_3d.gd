extends Camera3D
@onready var player:CharacterBody3D = $"../.."

func _ready():
	pass
	
func _process(delta):
	position = Vector3(player.position.x, player.position.y, player.position.z)
