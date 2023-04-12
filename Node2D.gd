extends Node2D

@onready var label = $DamageText
var rng = RandomNumberGenerator.new()
var text = ""
var critical = false

func _ready():
	label.text = str(text)
	var tween = create_tween()
	tween.set_parallel(true)
	var direction = rng.randf_range(-10.0, 10.0) * 3
	if (critical):
		label.add_theme_color_override("font_color", Color(1,0,0,1))
		label.add_theme_color_override("font_outline_color", Color(1,1,1,1))
	tween.tween_property(self, "position", Vector2(position.x + direction, position.y - 20), 0.4)
	tween.chain().tween_property(self, "position", Vector2(position.x + direction * 2, position.y + 20), 0.4)
	tween.chain().tween_property(self, "modulate", Color(1,1,1,0), 0.2)
	
func isCritical():
	critical = true

func _on_timer_timeout():
	queue_free()
