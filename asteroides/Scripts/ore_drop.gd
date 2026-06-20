extends Area2D

@onready var sprite: Sprite2D = $Sprite2D

var valor: int = 0
var velocidade_queda: float = 60.0
var _float_time: float = 0.0
var _float_offset: float = 0.0

func setup(textura: Texture2D, valor_minerio: int) -> void:
	sprite.texture = textura
	sprite.scale   = Vector2(0.1, 0.1) 
	valor = valor_minerio
	_float_offset = randf() * TAU

#func _ready() -> void:
	#area_entered.connect(_on_area_entered)

func _physics_process(delta: float) -> void:
	_float_time += delta

	# queda constante para baixo
	position.y += velocidade_queda * delta

	# deriva lateral leve
	position.x += sin(_float_time * 1.5 + _float_offset) * 12.0 * delta

	_checar_despawn()

func _checar_despawn() -> void:
	if position.y > get_viewport_rect().size.y + 80.0:
		queue_free()

#func _on_area_entered(area: Area2D) -> void:
	#if area.is_in_group("player"):
		#queue_free()
