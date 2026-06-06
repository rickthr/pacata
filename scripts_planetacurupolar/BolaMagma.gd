extends Area2D

@export var velocidade: float = 500.0
@export var dano: int = 1
@export var velocidade_rotacao: float = 8.0

var posicao_alvo: Vector2 = Vector2.ZERO
var movendo: bool = false


func _ready():
	body_entered.connect(_on_body_entered)


func _physics_process(delta):
	if not movendo:
		return

	global_position = global_position.move_toward(posicao_alvo, velocidade * delta)

	if global_position.distance_to(posicao_alvo) <= 2.0:
		queue_free()
	rotation += velocidade_rotacao * delta


func configurar(posicao_inicial: Vector2, alvo: Vector2):
	global_position = posicao_inicial
	posicao_alvo = alvo
	movendo = true

	print("Bola configurada. Inicial: ", posicao_inicial, " Alvo: ", alvo)


func _on_body_entered(body):
	if body.has_method("receber_dano"):
		body.receber_dano(dano)

	queue_free()
