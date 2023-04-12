extends Resource

class_name PlayerStats

@export var upgrades : Array[UpgradeType]
@export var hpMax : int = 100
@export var hp : int = 100
@export var canCrit : bool = false
@export var critChance : int = 0
@export var coolDownModifier : float = 1.0
@export var healPerSecond : int = 0
@export var movementSpeed : int = 100

func addUpgrade(newUpgrade : UpgradeType, level : UpgradeLevel):
	for upgrade in upgrades:
		if upgrade.name == newUpgrade.name:
			upgrade.levels.push_back(level)
			return
	var upgrade = UpgradeType.new()
	upgrade.name = newUpgrade.name
	upgrade.image = newUpgrade.image
	upgrade.levels.push_back(level)
	upgrades.append(upgrade)
	match upgrade.name:
		"Cooldown":
			coolDownModifier = level.stats.cooldown
		"Critical":
			canCrit = true
			critChance = level.stats.critChance
		"Heal":
			healPerSecond = level.level
	
func getUpgrade(name : String):
	for upgrade in upgrades:
		if upgrade.name == name:
			upgrade.levels[-1].stats.canCrit = canCrit
			upgrade.levels[-1].stats.critChance = critChance
			upgrade.levels[-1].stats.cooldown = upgrade.levels[-1].stats.cooldown * coolDownModifier
			return upgrade
