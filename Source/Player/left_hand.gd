extends Node3D

var mouse_movement:float
var sway_threshold:float = 5
var sway_lerp:float = 5
var sway_multiplier:float = 0.25

@onready var player = get_tree().get_nodes_in_group("player")[0]
@onready var original_position = transform.origin  # Store the original position

@export var sway_left:Vector3 = Vector3(0,0.1,0)
@export var sway_right:Vector3 = Vector3(0,-0.1,0)
@export var sway_normal:Vector3 = Vector3(0,0,0)

var time = 0
var speed = 8
var amplitude = 2

func _ready():
	pass
	
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		mouse_movement = -event.relative.x
		
func _process(delta):
	if mouse_movement != null:
		# Handle left/right sway based on mouse movement
		if mouse_movement > sway_threshold:
			rotation = rotation.lerp(sway_left, sway_lerp * delta)
		elif mouse_movement < -sway_threshold:
			rotation = rotation.lerp(sway_right, sway_lerp * delta)
		else:
			rotation = rotation.lerp(sway_normal, sway_lerp * delta)
		
		# Set sway multiplier based on player state
		if player.is_shield_active:
			sway_multiplier = 0.05
		elif player.move_state == "moving":
			sway_multiplier = 0.25
		else:  # still
			if sway_multiplier > 0.06:
				sway_multiplier -= 0.01		
		# Calculate vertical movement
		time += delta
		var frequency = speed
		var movement = sway_multiplier * sin(time * frequency) * amplitude
		
		# Apply movement while maintaining the original position as base
		var new_position = original_position
		new_position.y += movement * delta
		transform.origin = new_position
