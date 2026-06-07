extends RigidBody2D

@onready var sprite: Sprite2D = $Sprite2D

var lifetime: float = 0.8

func setup(textura: Texture2D, cor: Color) -> void:
	sprite.texture  = textura
	sprite.modulate = cor

func _ready() -> void:
	gravity_scale   = 0.15   
	linear_damp     = 1.5  
	angular_velocity = randf_range(-5.0, 5.0) 
	await get_tree().create_timer(lifetime).timeout
	queue_free()
