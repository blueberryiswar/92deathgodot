extends Node2D

@export var spawns: Array[SpawnInfo] = []
@export var enemyNo : Label

@onready var player = get_tree().get_first_node_in_group("player")

var time : int = 0
var top_left : Vector2
var top_right : Vector2
var bottom_left : Vector2
var bottom_right : Vector2
var monsters : int = 0


func _on_timer_timeout():
	time += 1
	for spawn in spawns:
		if time >= spawn.time_start and time <= spawn.time_end:
			if spawn.spawn_delay_counter < spawn.enemy_spawm_delay:
				spawn.spawn_delay_counter += 1
			else:
				set_random_positions()
				spawn.spawn_delay_counter = 0
				var counter = 0
				while counter < spawn.enemy_num and monsters < 200:
					var enemy_spawn = spawn.enemy.instantiate()
					enemy_spawn.global_position = get_random_position() + Vector2(counter * 5, counter)
					enemy_spawn.enemy_died.connect(_on_enemy_died)
					add_child(enemy_spawn)
					monsters += 1
					enemyNo.text =str(monsters)
					counter += 1

func _on_enemy_died(type):
	print(type)
	monsters -= 1
	enemyNo.text =str(monsters)
				
func set_random_positions() -> void:
	var vpr = get_viewport_rect().size * 0.25 * randf_range(1.1,1.2)
	top_left = Vector2(player.global_position.x - vpr.x/2, player.global_position.y - vpr.y/2)
	top_right = Vector2(player.global_position.x + vpr.x/2, player.global_position.y - vpr.y/2)
	bottom_left = Vector2(player.global_position.x - vpr.x/2, player.global_position.y + vpr.y/2)
	bottom_right = Vector2(player.global_position.x + vpr.x/2, player.global_position.y + vpr.y/2)					
					
func get_random_position() -> Vector2:
	var pos_side = ["tl","tr","bl","br"].pick_random()
	
	match pos_side:
		"tl":
			return top_right
		"tr":
			return top_left
		"bl":
			return bottom_left
		"br":
			return bottom_right
	return Vector2.ZERO
	
	
