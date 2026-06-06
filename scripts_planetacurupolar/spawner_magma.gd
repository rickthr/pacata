extends Node2D

@export var cena_bola_magma: PackedScene
@export var cena_indicador: PackedScene

@export var intervalo: float = 1.2
@export var tempo_aviso: float = 0.8
@export var margem_erro_mira: float = 20.0

@export var largura_tela: float = 1152.0
@export var distancia_fora_da_tela: float = 80.0

@export var nave_path: NodePath

var ativo: bool = false
var nave: Node2D
var ultimo_ponto_alvo: Vector2 = Vector2.ZERO


func _ready():
	if nave_path != NodePath(""):
		nave = get_node_or_null(nave_path)


func iniciar():
	if ativo:
		return

	ativo = true
	ciclo_magma()


func parar():
	ativo = false


func ciclo_magma():
	while ativo:
		ultimo_ponto_alvo = escolher_ponto_proximo_da_nave()

		criar_indicador(ultimo_ponto_alvo)

		await get_tree().create_timer(tempo_aviso).timeout

		if not ativo:
			return

		lancar_bola_magma(ultimo_ponto_alvo)

		await get_tree().create_timer(intervalo).timeout


func escolher_ponto_proximo_da_nave() -> Vector2:
	if nave == null:
		return Vector2(576, 324)

	var erro = Vector2(
		randf_range(-margem_erro_mira, margem_erro_mira),
		randf_range(-margem_erro_mira, margem_erro_mira)
	)

	return nave.global_position + erro


func criar_indicador(posicao_alvo: Vector2):
	if cena_indicador == null:
		print("ERRO: cena_indicador não foi definida no Inspector.")
		return

	var indicador = cena_indicador.instantiate()
	get_tree().current_scene.add_child(indicador)

	indicador.global_position = posicao_alvo

	if indicador.has_method("configurar"):
		indicador.configurar(tempo_aviso)


func lancar_bola_magma(posicao_alvo: Vector2):
	if cena_bola_magma == null:
		print("ERRO: cena_bola_magma não foi definida no Inspector.")
		return

	var bola = cena_bola_magma.instantiate()
	get_tree().current_scene.add_child(bola)

	var posicao_inicial = Vector2(
		largura_tela + distancia_fora_da_tela,
		posicao_alvo.y
	)

	if bola.has_method("configurar"):
		bola.configurar(posicao_inicial, posicao_alvo)
