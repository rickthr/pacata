extends Area2D
class_name AsteroidBase

signal coletado(dados: Dictionary)
signal destruido(dados: Dictionary)
@onready var sprite:    Sprite2D         = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D

# Dados preenchidos pelo AsteroidSpawner
var dados_asteroide: Dictionary = {}
var dados_minerio:   Dictionary = {}
var hp_atual: int = 0
# Movimento
var velocidade: Vector2 = Vector2.ZERO
var rot_speed:  float   = 0.0

func _ready() -> void:
	add_to_group("asteroid")
	area_entered.connect(_on_area_entered)

# setup() — chamado pelo Spawner logo após add_child()
func setup(asteroide_dict: Dictionary, minerio_dict: Dictionary) -> void:
	dados_asteroide = asteroide_dict
	dados_minerio   = minerio_dict
	hp_atual        = dados_asteroide.get("hp", 10)
	_configurar_movimento()

# Movimento simples: cai com a velocidade do dicionário + leve deriva lateral
func _configurar_movimento() -> void:
	var spd: float = float(dados_asteroide.get("velocidade", 150))
	velocidade = Vector2(
		randf_range(-20.0, 20.0),
		spd
	)
	rot_speed = randf_range(-0.8, 0.8)

func _physics_process(delta: float) -> void:
	position += velocidade * delta
	rotation += rot_speed  * delta
	_checar_despawn()

# Despawn
func _checar_despawn() -> void:
	if position.y > get_viewport_rect().size.y + 80.0:
		queue_free()

# DANO E DESTRUIÇÃO
func receber_dano(quantidade: int) -> void:
	hp_atual -= quantidade
	if hp_atual <= 0:
		hp_atual = 0
		_ao_destruir()

func _ao_destruir() -> void:
	destruido.emit(_montar_dados())
	queue_free()	
	
	
# Coleta
func coletar() -> void:
	coletado.emit(_montar_dados())
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		coletar()

# Monta o dicionário que vai nos sinais
func _montar_dados() -> Dictionary:
	return {
		"nome":         dados_asteroide.get("nome",    "—"),
		"tamanho":      dados_asteroide.get("tamanho", "—"),
		"hp":           hp_atual,
		"max_hp":       dados_asteroide.get("hp",      0),
		"minerio_nome": dados_minerio.get("nome",      "—"),
		"minerio_cor":  dados_minerio.get("cor",       "—"),
		"raridade":     dados_minerio.get("raridade",  "—"),
		"valor":        dados_minerio.get("valor",     0),
		"origem":       dados_minerio.get("origem",    "—"),
	}
