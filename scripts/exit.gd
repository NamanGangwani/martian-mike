extends Area2D

@onready var animated_sprite = $AnimatedSprite2D

func _ready() -> void:
	animate()
	
func animate() -> void:
	animated_sprite.play("default")
