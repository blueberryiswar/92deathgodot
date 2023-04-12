extends ColorRect

var mouse_over : bool = false
var upgrade : UpgradeType
@onready var myBox = get_node(".")

@onready var player = get_tree().get_first_node_in_group("player")

signal selected_upgrade(upgrade : UpgradeType, level : UpgradeLevel)

func _ready():
	connect("selected_upgrade", Callable(player,"upgrade_character"))
	
func _input(event):
	if event.is_action_pressed("click"):
		if mouse_over:
			print(self.upgrade.levels.size())
			var level = self.upgrade.levels.pop_front()
			emit_signal("selected_upgrade", upgrade, level)

func _on_mouse_entered():
	mouse_over = true
	myBox.color = Color(0.49, 0.49, 0.64, 1)
		
func _on_mouse_exited():
	mouse_over = false
	myBox.color = Color(0.38, 0.38, 0.51, 1)
	
func set_item(upgrade : UpgradeType):
	self.upgrade = upgrade
	$LabelName.text = upgrade.name
	var nextLevel = upgrade.levels[0]
	$LabelDesc.text = nextLevel.description
	$LabelLevel.text = "lvl" + str(nextLevel.level)
	$ColorRect/TextureRect.texture = upgrade.image

func remove():
	queue_free()
