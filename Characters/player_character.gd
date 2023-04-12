extends CharacterBody2D

@export var starting_direction : Vector2 = Vector2(1,0)
@export var shootFire : AudioStream
@export var playerStats : PlayerStats

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
@onready var player = get_node(".")
@onready var crosshair = $Crosshair
@onready var attack_cooldown = $AttackCooldown
@onready var sprite = $Sprite2D
@onready var soundEffect = $SoundEffect
@onready var HealthBar = $HealthBar

var useController = false
var vulnerable = true


signal exp_gained(exp : int)

func _ready():
	update_animation_parameters(starting_direction)
	var levelManager = get_tree().get_first_node_in_group("levelmanager")
	levelManager.newPlayer(self)
	levelManager.level_up.connect(_on_level_up)
	print("Player Ready")
	
func _on_level_up(level : ExperienceLevel):
	print("New Player Level:", level.level)

func _physics_process(_delta):
	var move_input = Input.get_vector("left", "right", "up", "down", 0.05)
	var look_direction = Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down", 0.05)
	if(look_direction != Vector2.ZERO && !useController):
		useController = true
		
	if(useController):
		crosshair.look_at(global_position + look_direction)
	else:
		look_direction = get_global_mouse_position()	 
		crosshair.look_at(look_direction)
	
	update_animation_parameters(look_direction)
	velocity = move_input * playerStats.movementSpeed
	move_and_slide()
	pick_new_state()
	#position = (Vector2(int(round(position.x)), int(round(position.y))))
	if(Input.is_action_pressed("shoot")):
		shoot()
	
func _unhandled_input(event):
	if event.is_action_released("dodge"):
		dodge()
		

func update_animation_parameters(look_direction : Vector2):
	if(look_direction == Vector2.ZERO):
		return
	if(!useController):
		look_direction -= global_position
	look_direction = look_direction * 10
	animation_tree.set("parameters/Idle/blend_position", look_direction)
	animation_tree.set("parameters/walk/blend_position", look_direction)

func pick_new_state():
	if(velocity != Vector2.ZERO):
		state_machine.travel("walk")
	else:
		state_machine.travel("Idle")
		
func shoot():
	if !attack_cooldown.is_stopped():
		return
	var target = Vector2.ZERO
	if (useController):
		target = Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down", 0.05) * 10 + global_position
	else:
		target = get_global_mouse_position()
	var bullet = load("res://Objects/bullet.tscn").instantiate()
	get_parent().add_child(bullet)
	bullet.position = position
	var bulletStats = playerStats.getUpgrade("Flameshot")
	var level = bulletStats.levels.back()
	bullet.get_stats(level.stats)
	bullet.look_at(target)
	soundEffect.stream = shootFire
	soundEffect.play()
	bullet.shoot()
	attack_cooldown.wait_time = bullet.cooldown - (1 * level.stats.cooldown)
	attack_cooldown.start()
	
func take_damage(damage):
	playerStats.hp -= damage
	HealthBar.value = playerStats.hp
	flash()

func flash():
	sprite.material.set_shader_parameter("modifier", 1)
	$FlashTimer.start()

func _on_flash_timer_timeout():
	sprite.material.set_shader_parameter("modifier", 0)

func dodge():
	$MyHurtBox.call_deferred("disable")
	


func _on_my_hurt_box_take_damage(hitbox):
	if(!vulnerable):
		return
	take_damage(hitbox.damage)


func _on_vacuum_area_entered(area):
	if(!area.is_in_group("loot")):
		return
	area.target = player



func _on_pickup_area_entered(area):
	if(!area.is_in_group("loot")):
		return
	var expi = area.collect()
	emit_signal("exp_gained", expi)

func upgrade_character(upgrade : UpgradeType, level: UpgradeLevel):
	playerStats.addUpgrade(upgrade, level)
