extends Node
class_name GerenciadorCenas

enum Cenas{
	MenuInicial,
	Historia,
	PlanetaGaragem,
	Tutorial,
	PlanetaCurupolar,
	Inimigos,
	Voltando,
	Opcoes
}

var caminhos_cena: Dictionary={
	Cenas.MenuInicial: "res://Cenas/Jogo/Menu_Inicial.tscn",
	Cenas.Historia: "res://Cenas/Jogo/F_HISTORIA.tscn",
	Cenas.PlanetaGaragem: "res://Cenas/Jogo/Planeta_Garagem.tscn",
	Cenas.Tutorial: "res://Cenas/Jogo/F_Tutorial.tscn",
	Cenas.PlanetaCurupolar: "res://Cenas/Jogo/F_PlanetaCurupolar.tscn"
}

var sons: Dictionary ={
	"selecionar": "res://Assets/Sons/Efeitos interface/Selecionar_ilovemp4.mp3",
	"confirmar": "res://Assets/Sons/Efeitos interface/Confirmar_ilovemp4.mp3",
	"voltar": "res://Assets/Sons/Efeitos interface/Voltar_ilovemp4.mp3",
}

@warning_ignore("unused_signal")
signal passarCena(novaCena: Cenas)

var cenaAtual

var cnvsOpcoes
var efeitoStream 

var cena_anterior_aPausa

var anim: AnimationPlayer

func _ready() -> void:
	if Global.CenaAtual == null:
		Global.CenaAtual = Cenas.MenuInicial #pra testes
		
	Global.GerenciadorCenas = self
	cnvsOpcoes = $Opcoes
	efeitoStream = $EfeitosStream
	anim = $Transicao/animacao
	desativar_no(cnvsOpcoes)
	cenaAtual = Global.CenaAtual
	
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	gerenciarCena()

func mudarCena(novaCena: Cenas):
	cena_anterior_aPausa = cenaAtual# ->passa a cena anterior antes que ela mude 
	cenaAtual = novaCena
	Global.CenaAtual = cenaAtual
	print_debug(cenaAtual)
	
	if cenaAtual != Cenas.Opcoes:
		anim.play("fade_out")
		await anim.animation_finished
		get_tree().change_scene_to_file(caminhos_cena[cenaAtual])
	else:
		get_tree().paused = true
	
func gerenciarCena():
	match cenaAtual:
		Cenas.MenuInicial:
			#se o jogador está nessa cena, não há nada para alterar atraves do gerenciador de cenas por enquanto
			pass
		Cenas.Opcoes:
			opcoes()
			pass
		Cenas.PlanetaGaragem:
			if Input.is_action_just_pressed("ui_cancel"):
				mudarCena(Cenas.Opcoes)
			pass
		Cenas.Tutorial:
			if Input.is_action_just_pressed("ui_cancel"):
				mudarCena(Cenas.Opcoes)
	pass
	
func opcoes():
	reativar_no(cnvsOpcoes)
			#pausar_jogo()
	if Input.is_action_just_pressed("ui_cancel"):
		desativar_no(cnvsOpcoes)
		Global.CenaAtual = cena_anterior_aPausa
		cenaAtual = cena_anterior_aPausa
		get_tree().paused = false
		tocar_som("voltar")
		
		#pausar_jogo()

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
