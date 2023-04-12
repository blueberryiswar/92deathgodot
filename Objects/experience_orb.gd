extends Area2D

var experience : int = 1
@onready var sprite = $Sprite2D
var target = null
var speed = 2

@onready var sound : AudioStreamPlayer2D = $snd_collected

func _ready():
	if(experience > 9 and experience < 100):
		sprite.frame = 1
	elif (experience > 99):
		sprite.frame = 2

func collect():
	sound.play()
	$CollisionShape2D.set_deferred("disabled", true)
	sprite.visible = false
	return experience
	
func _physics_process(delta):
	if(target == null):
		return
	
	global_position = global_position.move_toward(target.global_position, speed)
	speed += 2*delta



func _on_snd_collected_finished():
	queue_free()
