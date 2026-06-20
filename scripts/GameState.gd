extends Node

var missao_pai_estado: String = "nao_iniciada"

var vendedor_liberado: bool = true
var geologo_liberado: bool = false
var loja_pecas_liberada: bool = false


func iniciar_missao_pai():
	missao_pai_estado = "iniciada"


func concluir_missao_pai():
	missao_pai_estado = "concluida"
	geologo_liberado = false


func liberar_loja_pecas():
	loja_pecas_liberada = false


func resetar_progresso():
	missao_pai_estado = "nao_iniciada"
	vendedor_liberado = false
	geologo_liberado = false
	loja_pecas_liberada = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
