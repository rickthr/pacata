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
	TelaMorte,
	Opcoes
}

var caminhos_cena: Dictionary={
	Cenas.MenuInicial: "res://Cenas/Jogo/Menu_Inicial.tscn",
	Cenas.Historia: "res://Cenas/Jogo/F_HISTORIA.tscn",
	Cenas.PlanetaGaragem: "res://Cenas/Jogo/Planeta_Garagem.tscn",
	Cenas.Tutorial: "res://Cenas/Jogo/F_Tutorial.tscn",
	Cenas.Inimigos: "res://Cenas/Jogo/F_Inimigos.tscn",
	Cenas.PlanetaCurupolar: "res://Cenas/Jogo/F_PlanetaCurupolar.tscn",
	Cenas.Voltando: "res://Cenas/Jogo/Voltando.tscn"
}

var sons: Dictionary ={
	"selecionar": "res://Assets/Sons/Efeitos interface/Selecionar_ilovemp4.mp3",
	"confirmar": "res://Assets/Sons/Efeitos interface/Confirmar_ilovemp4.mp3",
	"voltar": "res://Assets/Sons/Efeitos interface/Voltar_ilovemp4.mp3",
	"trilha_menu": "res://Assets/Sons/Músicas/Musiquinha menu_ilovemp4.mp3",
	"trilha_espaco": "res://Assets/Sons/Músicas/Som do espaço (white noise).mp3",
	"trilha_inimigos": "res://Assets/Sons/Músicas/trilhasonoraInimigos.mp3"
}

@warning_ignore("unused_signal")
signal passarCena(novaCena: Cenas)

var cenaAtual

var cnvsOpcoes
var cenaTelaMorte
@export var efeitoStream : AudioStreamPlayer2D
@export var trilhaStream : AudioStreamPlayer2D

var cena_anterior_aPausa

var anim: AnimationPlayer

@export var nave: Nave

func _ready() -> void:
	if Global.CenaAtual == null:
		Global.CenaAtual = Cenas.MenuInicial #pra testes
		
	Global.GerenciadorCenas = self
	cnvsOpcoes = $Opcoes
	cenaTelaMorte = $TelaMorte
	anim = $Transicao/animacao
	cenaAtual = Global.CenaAtual
	desativar_no(cnvsOpcoes)
	desativar_no(cenaTelaMorte)
	await get_tree().process_frame
	if nave != null:
		nave.morri.connect(_on_tela_morte)
	
func _exit_tree() -> void:
	if Global.GerenciadorCenas == self:
		Global.GerenciadorCenas = null	
	
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
			tocar_trilha("trilha_menu")
			#se o jogador está nessa cena, não há nada para alterar atraves do gerenciador de cenas por enquanto
			pass
		Cenas.Opcoes:
			opcoes()
			pass
		Cenas.Historia:
			tocar_trilha("trilha_espaco")
			pass
		Cenas.PlanetaGaragem:
			tocar_trilha("trilha_menu")
			if Input.is_action_just_pressed("ui_cancel"):
				mudarCena(Cenas.Opcoes)
			pass
		Cenas.Voltando:
			tocar_trilha("trilha_espaco")
			if Input.is_action_just_pressed("ui_cancel"):
				mudarCena(Cenas.Opcoes)
			pass
		Cenas.Tutorial:
			tocar_trilha("trilha_espaco")
			if Input.is_action_just_pressed("ui_cancel"):
				mudarCena(Cenas.Opcoes)
		Cenas.Inimigos:
			tocar_trilha("trilha_inimigos")
			if Input.is_action_just_pressed("ui_cancel"):
				mudarCena(Cenas.Opcoes)
			#espera um pouco pra tocar_trilha("trilha_inimigos")
		Cenas.PlanetaCurupolar:
			tocar_trilha("trilha_espaco")
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

func tocar_trilha(nome_do_som: String):
	trilhaStream.stream.loop = true
	var novo_stream = load(sons[nome_do_som])
	if trilhaStream.stream == novo_stream and trilhaStream.playing:
		return  # já está tocando essa trilha, não reinicia
	trilhaStream.stream = novo_stream
	trilhaStream.play()

func desativar_no(no_alvo: Node):
	no_alvo.process_mode = Node.PROCESS_MODE_DISABLED
	if no_alvo is CanvasItem or no_alvo is CanvasLayer:
		no_alvo.hide() 

func reativar_no(no_alvo: Node):
	no_alvo.process_mode = Node.PROCESS_MODE_INHERIT
	if no_alvo is CanvasItem or no_alvo is CanvasLayer:
		no_alvo.show() 
		
func _on_tela_morte() -> void:
	reativar_no(cenaTelaMorte)
	pass

func _on_passar_cena(novaCena: GerenciadorCenas.Cenas) -> void:
	mudarCena(novaCena)
