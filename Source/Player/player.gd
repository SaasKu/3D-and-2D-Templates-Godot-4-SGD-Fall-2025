extends CharacterBody3D

class_name Player

@onready var move_state:String = "still"
@onready var is_shield_active:bool = false
@onready var shield_anim_player = %ShieldAnimationPlayer
@onready var attack_anim_player = %AttackAnimPlayer

@export var camera_fov: int = 90
@export var gun_cam_fov: int = 75

@export var shield_regen_amount: float = 10
@export var health_regen_amount: float = 5
@export var look_sens: float = 0.006
@export var jump_velocity := 9.0
@export var bhop_on := true
@export var walk_speed := 9.0

@export var HEADBOB_SWAY_AMOUNT = 0.05
@export var HEADBOB_FREQ = 1
var headbob_time = 0.0

@export var air_cap := 5
@export var air_accel := 20.0
@export var air_move_speed := 300.0

@export var dash_speed := 7000.0


@export var shield_regen_timer_length: int = 5
@export var health_regen_timer_length: int = 8


var wish_dir := Vector3.ZERO

var can_dash : bool = true
var is_dashing : bool = false
var dash_tween: Tween
var dash_velocity := Vector3.ZERO
var can_regen_health : bool = false
var can_regen_shield : bool = false

var mouse_movement:Vector2

var has_shield_swayed:bool = false

@onready var shield:Node3D = %Shield

func get_move_speed() -> float:
	return walk_speed

func _ready():

	%Camera3D.fov = camera_fov
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	



func _unhandled_input(event):
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			rotate_y(-event.relative.x * look_sens)
			%Camera3D.rotate_x(-event.relative.y * look_sens)
			%Camera3D.rotation.x = clamp(%Camera3D.rotation.x, deg_to_rad(-90), deg_to_rad(90))
			mouse_movement = event.relative
			
	
			
	
	

func _process(delta):
	pass

func _handle_air_physics(delta) -> void:
	# Apply gravity
	self.velocity.y -= PhysicsServer3D.area_get_param(get_viewport().find_world_3d().space, PhysicsServer3D.AREA_PARAM_GRAVITY) * delta


	wish_dir = wish_dir.normalized()

	var cur_speed_in_wish_dir = self.velocity.dot(wish_dir)

	var max_speed = min(air_move_speed, air_cap)

	var add_speed_till_max = max_speed - cur_speed_in_wish_dir
	if add_speed_till_max > 0:
		var accel_speed = air_accel * air_move_speed * delta
		accel_speed = min(accel_speed, add_speed_till_max)
		self.velocity += accel_speed * wish_dir
	
func _handle_ground_physics(delta) -> void:
	self.velocity.x = wish_dir.x * get_move_speed()
	self.velocity.z = wish_dir.z * get_move_speed()
	
func _physics_process(delta):
	var input_dir = Input.get_vector("left", "right", "up", "down").normalized()
	if input_dir.length() > 0:
		move_state = "moving"
	else:
		move_state = "still"
	wish_dir = self.global_transform.basis * Vector3(input_dir.x, 0., input_dir.y)

	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			self.velocity.y = jump_velocity
		_handle_ground_physics(delta)
	else:
		_handle_air_physics(delta)

	
	if Input.is_action_just_pressed("shield") and not is_shielding:
		start_shielding()
	elif Input.is_action_just_released("shield") and is_shield_active:
		stop_shielding()
	elif Input.is_action_just_pressed("attack") and not is_attacking and not is_shielding and not is_shield_active:
		attack()
		
	move_and_slide()
	


			
var is_shielding := false  

var is_attacking:bool = false


	
func start_shielding():
	is_shielding = true
	is_shield_active = true
	shield_anim_player.play("hold_shield")
	await shield_anim_player.animation_finished
	if is_shield_active: 
		pass
	is_shielding = false

func stop_shielding():
	is_shield_active = false

	shield_anim_player.play_backwards("hold_shield")

func attack():
	is_attacking = true
	# Raycast method is called on the exact frame of attack, check the attack animation player!
	attack_anim_player.play("s_attack_1")
	await attack_anim_player.animation_finished
	is_attacking = false


var ray_range:int = 5
var dmg:int = 1
func raycast():
	var centre = %Camera3D.get_viewport().get_size()/2
	var ray_origin = %Camera3D.project_ray_origin(centre)
	var ray_end = ray_origin + %Camera3D.project_ray_normal(centre) * ray_range
	
	
	var new_intersection = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	var intersection = get_world_3d().direct_space_state.intersect_ray(new_intersection)
	
	if not intersection.is_empty() and intersection.collider.is_in_group("enemy"):
		var enemy_name:String = intersection.collider.name
		print(enemy_name)
		print("hahaha!")
		SignalBus.emit_signal("enemy_hit", dmg, enemy_name)
	else:
		print("Nothing")



	
