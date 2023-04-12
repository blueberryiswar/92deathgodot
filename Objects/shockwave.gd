extends CanvasLayer

@onready var Shockwave = $Shockwave

func _ready():
	Shockwave.play("shockwave")
