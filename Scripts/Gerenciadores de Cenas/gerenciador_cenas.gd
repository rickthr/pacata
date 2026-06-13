extends Node2D
class_name GerenciadorCenas

enum Cenas{
	MenuInicial,
	PlanetaGaragem,
	Tutorial,
	PlanetaCurupolar,
	Opcoes
}

var sons: Dictionary ={
	"selecionar": "res://Assets/Sons/Efeitos interface/Selecionar_ilovemp4.mp3",
	"confirmar": "res://Assets/Sons/Efeitos interface/Confirmar_ilovemp4.mp3",
	"voltar": "res://Assets/Sons/Efeitos interface/Voltar_ilovemp4.mp3",
}

signal passarCena(novaCena: Cenas)

var cenaAtual

var cnvsOpcoes
var efeitoStream 

func _ready() -> void:
	Global.GerenciadorCenas = self
	cnvsOpcoes = $Opcoes
	efeitoStream = $EfeitosStream
	desativar_no(cnvsOpcoes)

func _process(delta: float) -> void:
	gerenciarCena()

func mudarCena(novaCena: Cenas):
	cenaAtual = novaCena
	desativar_no(cnvsOpcoes)

func gerenciarCena():
	match cenaAtual:
		Cenas.MenuInicial:
			#se o jogador está nessa cena, não há nada para alterar atraves do gerenciador de cenas por enquanto
			pass
		Cenas.Opcoes:
			reativar_no(cnvsOpcoes)
			#pausar_jogo()
			if Input.is_action_just_pressed("ui_cancel"):
				mudarCena(Cenas.MenuInicial)
				tocar_som("voltar")
				#pausar_jogo()
			pass
	pass
	
func pausar_jogo():
	get_tree().paused = !get_tree().paused

func tocar_som(nome_do_som: String):
	# load() carrega o arquivo de áudio a partir do caminho na string
	efeitoStream.stream = load(sons[nome_do_som])
	efeitoStream.play()

func desativar_no(no_alvo: Node):
	no_alvo.process_mode = Node.PROCESS_MODE_DISABLED
	if no_alvo is CanvasItem or no_alvo is CanvasLayer:
		no_alvo.hide() 

func reativar_no(no_alvo: Node):
	no_alvo.process_mode = Node.PROCESS_MODE_INHERIT
	if no_alvo is CanvasItem or no_alvo is CanvasLayer:
		no_alvo.show() 

func _on_passar_cena(novaCena: GerenciadorCenas.Cenas) -> void:
	mudarCena(novaCena)
