extends Control
class_name LevelSelect

@onready var game_container = get_parent()

func _ready():
	Engine.time_scale = 1
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)





func _on_level_1_pressed():
	game_container.spawn_level("first_level")
	self.queue_free()
	pass # Replace with function body.
