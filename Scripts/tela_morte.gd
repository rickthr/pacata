extends CanvasLayer

@export var selecionaveis: Array[Sprite2D]
@export var hover: Sprite2D
@export var efeitoStream: AudioStreamPlayer2D
var index = 0
var gerenciadorCenas: GerenciadorCenas

var sons: Dictionary = {
	"selecionar": "res://Assets/Sons/Efeitos interface/Selecionar_ilovemp4.mp3",
	"confirmar": "res://Assets/Sons/Efeitos interface/Confirmar_ilovemp4.mp3"
}

func _process(delta: float) -> void:
	escolhe_botao()
	
func _ready() -> void:
	gerenciadorCenas = $".."
	if selecionaveis.size() > 0:	
		desenha_hover(index)

func desenha_hover(idx: int) -> void:
	hover.global_position = Vector2(635, selecionaveis[idx].global_position.y - 12)

func tocar_som(nome_do_som: String) -> void:
	efeitoStream.stream = load(sons[nome_do_som])
	efeitoStream.play()

func escolhe_botao() -> void:
	var moveu: bool = false
	
	if Input.is_action_just_pressed("ui_up"):
		tocar_som("selecionar")	
		index -= 1
		moveu = true
		
	elif Input.is_action_just_pressed("ui_down"):
		tocar_som("selecionar")
		index += 1
		moveu = true

	# Sistema de wrap 
	if index < 0:
		index = selecionaveis.size() - 1
	elif index >= selecionaveis.size():    
		index = 0

	if moveu:
		desenha_hover(index)

	if Input.is_action_just_pressed("ui_accept"):
		tocar_som("confirmar")
		seleciona_botao(index)
		
func seleciona_botao(idx:int):
	match idx:
		0:
			get_tree().reload_current_scene()
		1:
			if gerenciadorCenas and gerenciadorCenas.has_method("mudarCena"):
				gerenciadorCenas.mudarCena(gerenciadorCenas.Cenas.MenuInicial)
			else:
				print_debug("Erro: Gerenciador de Cenas não encontrado ou não possui o método mudarCena")
