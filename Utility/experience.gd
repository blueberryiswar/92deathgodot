extends Node

class_name ExperienceLevel

var level : int = 1
var experience : int = 0
var nextLevel : int = 6

signal level_up(level : ExperienceLevel)
signal gained_exp(experience)

func calc_experience(expGem):
	experience += expGem
	while (experience >= nextLevel):
		experience -= nextLevel
		levelup()
		
func levelup():
	level += 1
	nextLevel = calc_experience_cap()
	emit_signal("level_up", self)
	
func calc_experience_cap():
	var experience_cap = level
	if(level < 10):
		experience_cap += level * 5
	elif(level < 20):
		experience_cap += + 10 + level * 10
	elif(level < 40):
		experience_cap += 200 + level * 15
	return experience_cap
	
func newPlayer(player):
	player.exp_gained.connect(_on_exp_gain)
	
func _on_exp_gain(exp_gained):
	emit_signal("gained_exp", experience + exp_gained)
	calc_experience(exp_gained)
