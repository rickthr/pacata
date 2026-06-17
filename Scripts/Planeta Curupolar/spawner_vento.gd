extends Node2D

@export var cena_onda_vento: PackedScene
@export var intervalo: float = 1.0
@export var largura_tela: float 
@export var altura_minima: float = 80.0
@export var altura_maxima: float
@export var distancia_fora_da_tela: float = 80.0

var ativo: bool = false


func iniciar():
	if ativo:
		return

	ativo = true
	ciclo_vento()


func parar():
	ativo = false


func ciclo_vento():
	while ativo:
		criar_onda_vento()
		await get_tree().create_timer(intervalo).timeout


func criar_onda_vento():

	var onda = cena_onda_vento.instantiate()
	get_tree().current_scene.add_child(onda)

	var x = largura_tela + distancia_fora_da_tela
	var y = randf_range(altura_minima, altura_maxima)

	onda.global_position = Vector2(x, y)
