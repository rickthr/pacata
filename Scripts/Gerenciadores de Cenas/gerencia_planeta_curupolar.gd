extends Node2D

var lista_dialogos := ["DPC1"]
var lista_pp := [""] #nenhum por enquanto
var popup_duration_per_message := 5.0
var nave: Nave
var gerenciador_cenas: GerenciadorCenas
var planeta_curupolar

func _ready() -> void:
	await get_tree().process_frame
	
	nave = Global.Jogador
	nave.pode_mexer = false
	planeta_curupolar = $PlanetaCurupolar
	await get_tree().create_timer(2).timeout
	
	DialogueManager.start_dialogue_id("DPC1")
	await DialogueManager.dialogue_finished
	planeta_curupolar.pode_atirar = true
	if planeta_curupolar.has_method("atualizar_estado_spawner"):
		planeta_curupolar.atualizar_estado_spawner()
	nave.pode_mexer = true
	
	await get_tree().create_timer(120).timeout
	#gerenciador_cenas.passarCena.emit(gerenciador_cenas.Cenas.)
	
	
