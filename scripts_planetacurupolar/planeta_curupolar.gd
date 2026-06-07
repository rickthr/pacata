extends Node2D

enum FacePlaneta {
	QUENTE,
	FRIA
}

@onready var sprite_planeta: Sprite2D = $Curupolar
@onready var nave:= $Nave
@onready var spawner_magma: Node2D = $SpawnerMagma
@onready var focos_vento: Node2D = $FocosVento
@onready var spawner_vento: Node2D = $SpawnerVento

@export var posicao_planeta: Vector2 = Vector2(1080, 324)
@export var tempo_para_trocar_face: float = 0
@export var velocidade_rotacao: float = 0.2
@export var meia_volta: float = PI

var face_atual: FacePlaneta = FacePlaneta.QUENTE
var tempo_atual: float = 0.0
var rotacionando: bool = false
var rotacao_destino: float = 0.0


func _ready():
	aplicar_face_quente()


func _process(delta):
	contar_tempo_de_rotacao(delta)
	rotacionar_planeta(delta)

func contar_tempo_de_rotacao(delta):
	tempo_atual += delta

	if tempo_atual >= tempo_para_trocar_face:
		tempo_atual = 0.0
		trocar_face()

func trocar_face():
	if rotacionando:
		return

	if face_atual == FacePlaneta.QUENTE:
		face_atual = FacePlaneta.FRIA
	else:
		face_atual = FacePlaneta.QUENTE

	rotacao_destino = sprite_planeta.rotation + meia_volta
	rotacionando = true


func rotacionar_planeta(delta):
	if not rotacionando:
		return

	sprite_planeta.rotation = move_toward(
		sprite_planeta.rotation,
		rotacao_destino,
		velocidade_rotacao * delta
	)

	if is_equal_approx(sprite_planeta.rotation, rotacao_destino):
		sprite_planeta.rotation = rotacao_destino
		rotacionando = false

		if sprite_planeta.rotation >= TAU:
			sprite_planeta.rotation -= TAU
			rotacao_destino -= TAU

		aplicar_face_atual()


func aplicar_face_atual():
	if face_atual == FacePlaneta.QUENTE:
		aplicar_face_quente()
	else:
		aplicar_face_fria()


func aplicar_face_quente():
	ativar_magma(true)
	ativar_vento(false)

func aplicar_face_fria():

	ativar_magma(false)
	ativar_vento(true)

func ativar_magma(ativo: bool):
	if spawner_magma == null:
		return

	if ativo:
		if spawner_magma.has_method("iniciar"):
			spawner_magma.iniciar()
	else:
		if spawner_magma.has_method("parar"):
			spawner_magma.parar()


func ativar_vento(ativo: bool):
	if spawner_vento == null:
		return

	if ativo:
		if spawner_vento.has_method("iniciar"):
			spawner_vento.iniciar()
	else:
		if spawner_vento.has_method("parar"):
			spawner_vento.parar()
