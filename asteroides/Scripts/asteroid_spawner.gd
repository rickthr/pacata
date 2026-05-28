# asteroid_spawner.gd
extends Node

@export var asteroid_scene: PackedScene
@export var fase_atual: int = 1

const INTERVALOS: Array = [3.5, 2.8, 2.2, 1.7, 1.3]

var _db: AsteroidDatabase = AsteroidDatabase.new()
var _min: MineralsDatabase = MineralsDatabase.new()
var _timer: float = 0.0

func _process(delta: float) -> void:
	_timer -= delta
	if _timer <= 0.0:
		_spawnar()
		_timer = INTERVALOS[clamp(fase_atual - 1, 0, 4)]

func _spawnar() -> void:
	var ast: Dictionary = _sortear()
	if ast.is_empty() or not asteroid_scene:
		return

	var min_dict: Dictionary = _resolver_minerio(ast.get("minerio", ""))

	var a: Asteroid = asteroid_scene.instantiate()
	get_parent().add_child(a)
	a.position = Vector2(randf_range(60.0, get_viewport().get_visible_rect().size.x - 60.0), -60.0)
	a.setup(ast, min_dict)

func _sortear() -> Dictionary:
	var total: int = 0
	for a in _db.asteroides:
		total += a.get("chance_spawn", 0)
	var roll: int = randi() % total
	var acc: int = 0
	for a in _db.asteroides:
		acc += a.get("chance_spawn", 0)
		if roll < acc:
			return a
	return {}

func _resolver_minerio(nome: String) -> Dictionary:
	for m in _min.minerais:
		if m.get("nome", "") == nome:
			return m
	return {}
