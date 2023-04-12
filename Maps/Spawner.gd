extends Node2D

@onready var player = get_node("PlayerCharacter")
var count : int = 0

#func _process(_delta):
#	if count < 100:
#		spawn()
#		count += 1
	
#func spawn():
#	var enemy = load("res://Characters/ghost.tscn").instantiate()
#	add_child(enemy)
#	enemy.position = player.position + Vector2(250, 0).rotated(randf_range(0, 2*PI))
	
