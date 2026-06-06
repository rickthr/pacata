extends Node

signal dialogo_iniciado(dialogue_id: String)
signal dialogo_finalizado(dialogue_id: String)

var dialogo_atual: String = ""


func start_dialogue(dialogue_id: String):
	dialogo_atual = dialogue_id
	dialogo_iniciado.emit(dialogue_id)

	print("Diálogo iniciado: " + dialogue_id)


func finish_dialogue():
	if dialogo_atual == "":
		return

	var dialogue_id = dialogo_atual
	dialogo_atual = ""

	dialogo_finalizado.emit(dialogue_id)

	print("Diálogo finalizado: " + dialogue_id)


func escolher_dialogo_hub_inicial() -> String:
	match GameState.missao_pai_estado:
		"nao_iniciada":
			return "hub_pai_missao_nao_iniciada"

		"iniciada":
			return "hub_pai_missao_iniciada"

		"concluida":
			return "hub_pai_missao_concluida"

		_:
			return "hub_dialogo_padrao"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
