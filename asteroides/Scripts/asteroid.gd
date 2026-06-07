# asteroid.gd
class_name Asteroid
extends AsteroidBase

var _pulse_time: float = 0.0
var _base_scale: Vector2 = Vector2.ONE
var _is_epico: bool = false

func setup(asteroide_dict: Dictionary, minerio_dict: Dictionary) -> void:
	super.setup(asteroide_dict, minerio_dict)
	_aplicar_vfx()

func _aplicar_vfx() -> void:
	var raridade: String = dados_minerio.get("raridade", "Comum")
	match raridade:
		"Comum":
			sprite.modulate = Color(1.0, 1.0, 1.0)

		"Raro":
			sprite.modulate = Color(0.55, 0.20, 0.80)
			rot_speed *= 1.4

		"Epico":
			sprite.modulate = Color(0.90, 0.70, 0.10)
			rot_speed *= 2.0
			_is_epico   = true
			_base_scale = sprite.scale if sprite else Vector2.ONE
			_pulse_time = randf() * TAU

func _physics_process(delta: float) -> void:
	super(delta)
	if _is_epico and sprite:
		_pulse_time += delta * 2.5
		sprite.scale = _base_scale * (1.0 + sin(_pulse_time) * 0.07)
