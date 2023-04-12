extends Control

var upgradeName : String = ""
var upgradeImage : Texture2D
var upgradeLevel : String = ""
@onready var myImage := $TextureRect
@onready var level := $Label

func setValues(upgrade : UpgradeType, level : UpgradeLevel):
	upgradeName = upgrade.name
	upgradeImage = upgrade.image
	upgradeLevel = str(level.level)
	
func _ready():
	myImage.texture = upgradeImage
	level.text = upgradeLevel
	
func updateLevel(upgradeLevel : int):
	level.text = str(upgradeLevel)

func compare(upgrade : UpgradeType):
	if(upgradeName == upgrade.name):
		return true
	return false
