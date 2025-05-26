# Main Menu Class

# This gets initiated as a child of the game container

extends Control
class_name MainMenu

@onready var game_container = get_parent()

func ready():
	# Set the mouse mode to visible in case we transition to it from a 
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)





func _on_play_pressed():
	game_container.spawn_level_select_menu()
	queue_free()
