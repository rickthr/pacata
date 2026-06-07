# asteroid.gd
class_name Asteroid
extends AsteroidBase
@onready var particles: GPUParticles2D = $DeathParticles
@export var fragment_scene: PackedScene
@export var fragment_textures: Array[Texture2D]


var _pulse_time: float = 0.0
var _base_scale: Vector2 = Vector2.ONE
var _is_epico: bool = false

func setup(asteroide_dict: Dictionary, minerio_dict: Dictionary) -> void:
	super.setup(asteroide_dict, minerio_dict)
	_aplicar_vfx()
	
#Função destruir com particular sendo emitidas
func _ao_destruir() -> void:
	particles.emitting = true
	particles.reparent(get_parent())
	destruido.emit(_montar_dados()) 
	queue_free()                       
	await get_tree().create_timer(particles.lifetime).timeout
	particles.queue_free() 

#função cores do minerio por raridade(não está funcionando tão bem)
func _aplicar_vfx() -> void:
	var raridade: String = dados_minerio.get("raridade", "Comum")
	match raridade:
		"Comum":
			sprite.modulate = Color(1.0, 1.0, 1.0)
			particles.modulate = Color(1.0, 1.0, 1.0)

		"Raro":
			sprite.modulate = Color(0.55, 0.20, 0.80)
			particles.modulate = Color(1.0, 1.0, 1.0)
			rot_speed *= 1.4

		"Epico":
			sprite.modulate = Color(0.898, 0.02, 0.2, 1.0)
			particles.modulate = Color(0.898, 0.02, 0.2, 1.0)
			rot_speed *= 2.0
			_is_epico   = true
			_base_scale = sprite.scale if sprite else Vector2.ONE
			_pulse_time = randf() * TAU

func _physics_process(delta: float) -> void:
	super(delta)
	if _is_epico and sprite:
		_pulse_time += delta * 2.5
		sprite.scale = _base_scale * (1.0 + sin(_pulse_time) * 0.07)
		
		
		
func _lancar_fragmentos() -> void:
	if not fragment_scene or fragment_textures.is_empty():
		return
	for textura in fragment_textures:
		var frag = fragment_scene.instantiate()
		get_parent().add_child(frag)
		frag.position = position
		frag.setup(textura, sprite.modulate)
		var direcao := Vector2(
			randf_range(-1.0, 1.0),
			randf_range(-1.0, 1.0)
		).normalized()
		frag.apply_impulse(direcao * randf_range(80.0, 200.0))
