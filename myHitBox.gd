class_name MyHitBox
extends Area2D

@export var damage : int = 10
@export var levelStats : LevelStats
@export var my_layer : int = 2

@onready var collision = $CollisionShape2D
@onready var disableTimer = $DisableTimer

signal hit_something(hurtbox: MyHurtBox)

func _init():
	collision_layer = my_layer
	collision_mask = 0

func tempdisable():
	collision.call_deferred("set", "disabled", true)
	disableTimer.start()
	
func _on_disable_timer_timeout():
	collision.call_deferred("set", "disabled", false)
	
func disable():
	collision.call_deferred("set", "disabled", true)

func my_hit(hurtbox):
	emit_signal("hit_something", hurtbox)
	
