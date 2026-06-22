extends Control
class_name GerenciaBotoes

@export var botoes: Node2D
@export var efeitoStream: AudioStreamPlayer2D
@export var hover: Sprite2D

var pode_mexer: bool = true

var sons: Dictionary ={
	"selecionar": "res://Assets/Sons/Efeitos interface/Selecionar_ilovemp4.mp3",
	"confirmar": "res://Assets/Sons/Efeitos interface/Confirmar_ilovemp4.mp3",
	"voltar": "res://Assets/Sons/Efeitos interface/Voltar_ilovemp4.mp3",
	"start": "res://Assets/Sons/Efeitos interface/Efeito start_ilovemp4.mp3"
}

var lista_botoes: Array = []
var index_botao: int = 0 

var gerenciadorCenas: GerenciadorCenas

func _ready() -> void:
	print_debug(Global.GerenciadorCenas)	
	gerenciadorCenas = Global.GerenciadorCenas
	print_debug(Global.GerenciadorCenas)	
	# Pega todos os botões que estão dentro do nó Botoes
	lista_botoes = botoes.get_children()
	
	# Garante que o hover comece no primeiro botão
	if lista_botoes.size() > 0:
		desenha_hover(index_botao)

func _process(_delta: float) -> void:
	# Só processa se houver botões na lista
	if lista_botoes.size() == 0: 
		return
		
	escolhe_botao()

# Função auxiliar para carregar e tocar o som de forma limpa
func tocar_som(nome_do_som: String):
	# load() carrega o arquivo de áudio a partir do caminho na string
	efeitoStream.stream = load(sons[nome_do_som])
	efeitoStream.play()

func escolhe_botao():
	if not pode_mexer:
		return
	# detecta se o jogador apertou para baixo
	if Input.is_action_just_pressed("ui_down"):
		tocar_som("selecionar")
		index_botao += 1
		# se passar do limite, volta para o primeiro (0)
		if index_botao >= lista_botoes.size():
			index_botao = 0
		desenha_hover(index_botao)
		
	# detecta se o jogador apertou para cima
	elif Input.is_action_just_pressed("ui_up"):
		tocar_som("selecionar")
		index_botao -= 1
		# se for menor que 0, vai para o último botão da lista
		if index_botao < 0:
			index_botao = lista_botoes.size() - 1
		desenha_hover(index_botao)
	
	if Input.is_action_just_pressed("ui_accept"):
		seleciona_botao(index_botao)

func desenha_hover(idx_botao_atual: int):
	var botao_alvo = lista_botoes[idx_botao_atual]
	
	var pos_botao = botao_alvo.global_position
	hover.global_position = Vector2(625, pos_botao.y + 40) 
	
func seleciona_botao(idx_botao: int): # OVERRIDE
	match idx_botao:
		0:#jogar
			tocar_som("start")
			gerenciadorCenas.passarCena.emit(gerenciadorCenas.Cenas.Historia)
			pass
		1:#opcoes
			tocar_som("confirmar")
			gerenciadorCenas.passarCena.emit(gerenciadorCenas.Cenas.Opcoes)
			pass
		2:#sair
			get_tree().quit()
			pass
	pass
