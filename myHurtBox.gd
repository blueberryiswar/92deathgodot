class_name MyHurtBox
extends Area2D

@export var my_mask : int = 2
@export_enum("Normal", "Cooldown") var HurtBoxType = 0

@onready var collision = $CollisionShape2D
@onready var disableTimer = $DisableTimer

signal take_damage(hitbox: MyHitBox)

func _init():
	collision_layer = 0
	collision_mask = my_mask

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("area_entered", on_area_entered)
	pass # Replace with function body.

	
func on_area_entered(hitbox: MyHitBox):
	if hitbox == null or hitbox.my_layer != my_mask:
		return
	hitbox.my_hit(self)
	match HurtBoxType:
		0: # Normal
			pass
		1: # Cooldown
			collision.call_deferred("set", "disabled", true)
			disableTimer.start()

	emit_signal("take_damage", hitbox)

func _on_disable_timer_timeout():
	collision.call_deferred("set", "disabled", false)

func disable():
	collision.call_deferred("set", "disabled", true)
