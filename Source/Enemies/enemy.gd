extends CharacterBody3D

@export var health:int = 3
@onready var anim_player = %AnimationPlayer
func _ready():
	SignalBus.connect("enemy_hit", enemy_take_dmg)
	pass
	
func enemy_take_dmg(dmg_taken:int, name:String):
	if name == self.name:
		health -= dmg_taken
		anim_player.play("hit")
		print("ow!!!")
	if health <= 0:
		self.queue_free()
