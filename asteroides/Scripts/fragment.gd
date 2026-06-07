extends Node2D
@onready var sprite: Sprite2D = $Sprite2D

var lifetime: float = 0.8

func setup(textura: Texture2D, cor: Color) -> void:
	sprite.texture  = textura
	sprite.modulate = cor

func _ready() -> void:
	await get_tree().create_timer(lifetime).timeout
	queue_free()
