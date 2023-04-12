extends Area2D

var aimed = false
@export var punchtrough : int = 1
@export var speed : int = 10
@export var cooldown : float = 1
@onready var fireSound : AudioStreamPlayer2D = $fireSound
@onready var myHitBox : MyHitBox = $MyHitBox

func shoot():
	aimed = true
	$AnimationPlayer.play("bullet")
	$Sprite2D/GPUParticles2D.restart()
	
func _physics_process(_delta):
	if(aimed):
		var velocity = Vector2(speed, 0)
		global_position += velocity.rotated(rotation)

func get_stats(level : LevelStats):
	myHitBox.levelStats = level
	punchtrough = level.punchTrough
	cooldown = level.cooldown
	

func _on_my_hit_box_hit_something(hurtbox):
	punchtrough -= 1
	fireSound.play()
	if(punchtrough <= 0):
		myHitBox.call_deferred("disable")
		aimed=false
		$Sprite2D.visible = false


func _on_fire_sound_finished():
	if(punchtrough <= 0):
		queue_free()

func _on_timer_timeout():
	queue_free()
