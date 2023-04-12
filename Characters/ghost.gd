extends CharacterBody2D

@export var speed : float = 25
@export var hp : int = 10
@export var experience : int = 2

#@onready var animation_tree = $AnimationTree
#@onready var state_machine = animation_tree.get("parameters/playback")
@onready var player = get_tree().get_first_node_in_group("player")
@onready var collision = $CollisionShape2D
@onready var sprite = $Sprite2D

const move_up : Array= [12,13,14,15]
const move_down : Array = [0, 1, 2, 3]
const move_left : Array = [8,9,10,11]
const move_right : Array = [4,5,6,7]
const death_anim : Array = [16,17,18,19]
var play_anim = move_down
var animCount : float = 0
var animReset : float = 3.9
var movement : Vector2 = Vector2.ZERO

var damageText = preload("res://Objects/damageText.tscn")
var experienceOrb = preload("res://Objects/experience_orb.tscn")

signal enemy_died(type)

func _physics_process(_delta):
	if(hp <= 0):
		return
	movement = global_position.direction_to(player.global_position).normalized()
	velocity = movement * speed
	
	move_and_slide()
	#animation_tree.set("parameters/walk/blend_position", movement)
	
func _process(delta):
	updateState()
	anim(delta)

func take_damage(damage, critical):
	flash()
	hp -= damage
	var text = damageText.instantiate()
	if(critical):
		text.isCritical()
	text.text = damage
	text.global_position = global_position
	get_parent().add_child(text)
	if (hp <= 0):
		death()
		
func flash():
	if($FlashTimer.is_stopped()):
		sprite.material.set_shader_parameter("modifier", 1)
		$FlashTimer.start()
		
func anim(delta):
	animCount += delta * 5
	if(animCount >= animReset):
		animCount = 0
	sprite.frame = play_anim[int(animCount)]
	

func updateState():
	if(hp <= 0):
		return
	if(movement.x > 0):
		play_anim = move_right
	elif(movement.y > 0):
		play_anim = move_down
	elif(movement.y < 0):
		play_anim = move_up
	else:
		play_anim = move_left
		
		
func death():
	#state_machine.travel("death")
	play_anim = death_anim
	animCount = 0
	$MyHitBox.call_deferred("disable")
	$MyHurtBox.call_deferred("disable")
	collision.set_deferred("disabled", true)
	emit_signal("enemy_died", "ghost")
	$DeathTimer.start()
	#queue_free()

func _on_flash_timer_timeout():
	sprite.material.set_shader_parameter("modifier", 0)


func _on_my_hurt_box_take_damage(hitbox):
	var damage = hitbox.levelStats.damage
	var critical = false
	if (hitbox.levelStats.canCrit):
		var rng = RandomNumberGenerator.new()
		var randomNr = rng.randi_range(0, 100)
		if (randomNr < hitbox.levelStats.critChance):
			damage = damage * 2
			critical = true
	take_damage(damage, critical)


func _on_death_timer_timeout():
	var orb = experienceOrb.instantiate()
	orb.experience = experience
	orb.global_position = global_position
	get_parent().add_child(orb)
	queue_free()
