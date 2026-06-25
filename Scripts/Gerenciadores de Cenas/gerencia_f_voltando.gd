extends Node2D

var dialogo_id = "DMRC3"
var gerenciadorCena : GerenciadorCenas
func _ready() -> void:
	gerenciadorCena = $GerenciadorCena
	await get_tree().create_timer(2).timeout
	DialogueManager.start_dialogue_id(dialogo_id)
	await DialogueManager.dialogue_finished
	gerenciadorCena.passarCena.emit(gerenciadorCena.Cenas.PlanetaGaragem)
