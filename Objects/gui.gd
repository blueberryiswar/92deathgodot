extends CanvasLayer

var displayedUpgrades : Array = []

@onready var levelLabel : Label = $MarginContainer/VBoxContainer/HBoxContainer/MarginContainer2/Level
@onready var expBar : ProgressBar = $MarginContainer/VBoxContainer/HBoxContainer/MarginContainer3/ProgressBar
@onready var levelUp : Panel = $MarginContainer/VBoxContainer/HBoxContainer2/MarginContainer/LevelUp
@onready var optionList : = $MarginContainer/VBoxContainer/HBoxContainer2/MarginContainer/LevelUp/UpgradeOptions
@onready var itemOption : = preload("res://Utility/item_option.tscn")
@onready var upgradeDisplay : = preload("res://Objects/upgrade_display.tscn")
@onready var soundPlayer := $MarginContainer/VBoxContainer/HBoxContainer2/MarginContainer/LevelUp/LevelUpSound
@onready var upgradeDB := $UpgradeDB
@onready var upgradeList := $MarginContainer/VBoxContainer/HBoxContainer3/MarginContainer/Upgrades

func _on_experience_gained_exp(experience):
	expBar.value = experience

func _on_experience_level_up(level : ExperienceLevel):
	if(!level):
		return
	
	soundPlayer.play()
	expBar.max_value = level.nextLevel
	expBar.value = level.experience
	levelLabel.text = "Level {int}".format({"int": level.level})
	levelUp.visible = true
	get_tree().paused = true
	var options = 0
	upgradeDB.upgrades.shuffle()
	while options < 3 and upgradeDB.upgrades.size() > 0:
		var option_choice = itemOption.instantiate()
		option_choice.selected_upgrade.connect(_on_upgrade_select)
		var upgrade = upgradeDB.upgrades.pop_back()
		option_choice.set_item(upgrade)
		optionList.add_child(option_choice)
		options+= 1

func _on_upgrade_select(upgrade : UpgradeType, level : UpgradeLevel):
	levelUp.visible = false
	_add_upgrade(upgrade, level)
	for child in optionList.get_children():
		if(child.upgrade.levels.size() > 0):
			upgradeDB.upgrades.append(child.upgrade)
		optionList.remove_child(child)
		child.remove()
	get_tree().paused = false
	
func _add_upgrade(upgrade : UpgradeType, level : UpgradeLevel):
	#itemList.add_icon_item(upgrade.image, false)
	for upgradeO in displayedUpgrades:
		if upgradeO.compare(upgrade):
			upgradeO.updateLevel(level.level)
			return
	
	var upgradeDis = upgradeDisplay.instantiate()
	upgradeDis.setValues(upgrade, level)
	upgradeList.add_child(upgradeDis)
	displayedUpgrades.append(upgradeDis)
	
	
	
