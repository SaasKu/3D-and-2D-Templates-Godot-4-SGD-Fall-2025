extends Node3D
class_name GameContainer

# This scene is the first scene that is run when the game is booted up!
# To set a scene as the main scene, right click it in the FileSystem in
# the bottom left and select "Set as Main Scene"

# All the menu scenes and levels are preloaded
@onready var main_menu_scene = preload("res://Source/Menus/main_menu/main_menu.tscn")
@onready var level_select_menu = preload("res://Source/Menus/level_select_menu/level_select_menu.tscn")

@onready var levels = {
	"first_level": preload("res://Source/Levels/first_level/first_level.tscn")
	
}

func _ready():
	spawn_main_menu()
	pass
	
func spawn_main_menu():
	var main_menu_inst: Control = main_menu_scene.instantiate()
	add_child(main_menu_inst)
	pass

func spawn_level_select_menu():
	var level_select_inst: Control = level_select_menu.instantiate()
	add_child(level_select_inst)
	
func spawn_level(name : String):
	var level_inst = levels.get(name).instantiate()
	add_child(level_inst)
