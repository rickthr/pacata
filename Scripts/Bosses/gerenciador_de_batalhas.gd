extends Node2D
class_name GerenciadorBatalhas

"""
O gerenciador de batalhas deve controlar os aspectos mais relevantes de uma battle boss. No caso: iniciar a batalha, instanciar os tipos de inimigos(em ordem aleatoria) nos especficos lugares randomizados de cada tipo, verificar a vida do boss, alternar os estados do boss, encerrar a batalha.
precisa de um contador de quantos tipos já foram instanciados
		e saber quando todos os inimigos da wave morreram ou sairam da tela para avançar -> essa função deve estar no gerenciador de batalhas, não aqui
		pode começar a instanciar
"""
@export var boss: BossBasico

var nave: Nave

enum Estados{
	Inativo,      # antes da batalha começar
	Instanciando, # onda ativa, inimigos sendo spawnados
	Aguardando,   # inimigos vivos, esperando todos morrerem
	Encerrado     # boss morreu, batalha acabou
}

var estadoAtual: Estados
var posInstanciar: Marker2D
@export var quantInimigosAInstanciar:int
@export var quantInimigosAInstanciarInicial:int
@export var maxQuantHordasNaTela:int
var quantHordasNaTela:int
var saiuDaTelaOuMorreu:bool = false
var cenaHorda:Node2D
var pare_instanciar_PF:bool = true
var cenas_disponiveis:Array[PackedScene]

var vivos_por_horda: Dictionary = {}

signal pausarBoss
@export var pausar_boss:bool

@export var inimigoAnimavel: Area2D 
@export var gerenciador_cena: GerenciadorCenas

func _ready() -> void:
	boss.onda_iniciada.connect(_on_onda_iniciada)
	boss.boss_morreu.connect(_on_boss_morreu)
	boss.chamar_instanciar.connect(_on_instanciar)
	boss.fechar_instanciar.connect(_on_encerra_instanciar)
	boss.cutscene_encerrada.connect(_on_cutscene_encerrada)
	cenas_disponiveis.assign(boss.dadosBoss.cenasInimigos)
	#estadoAtual = 
	#randomizaInimigos() ->pra teste
	await boss.ready
	await nave.ready
	nave.morri.connect(_on_nave_morreu)
	#boss.mudar_estado(BossBasico.Estados.CutScene)

func _on_onda_iniciada() -> void:
	print_debug("onda chamada")
	mudaEstado(Estados.Instanciando)
	pass
	
func _on_onda_encerrada() -> void:
	if estadoAtual != Estados.Aguardando:
		mudaEstado(Estados.Aguardando)  # gerenciador para de instanciar

func _on_cutscene_encerrada() -> void:
	if estadoAtual != Estados.Encerrado:
		boss.mudar_estado(BossBasico.Estados.Batalhando)

func _on_nave_morreu() -> void:
	pausarBoss.emit()
	
func _on_boss_morreu() -> void:
	#espera um tempo 
	await get_tree().create_timer(2).timeout
	await DialogueManager.dialogue_finished
	inimigoAnimavel.podeIr = true
	await get_tree().create_timer(4).timeout
	gerenciador_cena.passarCena.emit(gerenciador_cena.Cenas.Voltando)
	#para o funcionamento de algumas coisas
	pass

"""
essa função deve verificar se pode instanciar inimigos, guardar em uma variavel os tipos de inimigos que podem ser instanciados e a quantidade de cada. Além disso,pegar o caminho de instanciamento de cada.
DEpois, ele deve instanciar os inimigos aleatoriamente uma certa quantidade de vezes e seguindo as especifciações de cada tipo de inimigo
Exemplo:
	INIMIGO A selecionado -> instancia dois dele, um em cima e outro me baixo, nos pontos em que ele deve ser intanciado
"""	
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
		pass
	
func mudaEstado(estadoNovo: Estados):
	if pausarBoss:
		pausarBoss.emit()
	estadoAtual = estadoNovo
	match estadoAtual:
		Estados.Inativo:
			pass  # boss inicia por conta própria
		Estados.Instanciando:
			quantInimigosAInstanciar = quantInimigosAInstanciarInicial
			quantHordasNaTela = 0
			randomizaInimigos()
		Estados.Aguardando:
			boss.mudar_estado(boss.Estados.FaseDano)
			pass  # não chama boss aqui
		Estados.Encerrado:
			pass
	
func randomizaInimigos():

	if cenas_disponiveis.is_empty():
		cenas_disponiveis.assign(boss.dadosBoss.cenasInimigos)
		
	randomize()
		
	var indice = randi() % cenas_disponiveis.size()
	var inimigo_selecionado = cenas_disponiveis[indice]
	
	var ind_original = boss.dadosBoss.cenasInimigos.find(inimigo_selecionado)
	
	selecionaInstaciamento(inimigo_selecionado, ind_original)
	cenas_disponiveis.erase(inimigo_selecionado)
	
func selecionaInstaciamento(c_inimigo: PackedScene, ind:int) -> void:
	var tipo_selecionado = boss.dadosBoss.tiposInimigos[ind]
	match tipo_selecionado.tipo:
		"A": instanciaInimigoA(c_inimigo, tipo_selecionado) 
		"B": instanciaInimigoB(c_inimigo, tipo_selecionado)
		"C": instanciaInimigoC(c_inimigo, tipo_selecionado)
		_: push_error("inimigo desconhecido: " + tipo_selecionado.tipo)
	#if t_inimigo == tipoA
	#chama função instanciar tipoA
	pass
	
# FUNÇÔES DE INSTANCIAMENTO(OVERRIDE)
@warning_ignore("unused_parameter")
func instanciaInimigoA(inimigoCena: PackedScene, inimigoDados: DatabaseInimigos):
	pass	

@warning_ignore("unused_parameter")
func instanciaInimigoB(inimigoCena: PackedScene, inimigoDados: DatabaseInimigos):
	pass

@warning_ignore("unused_parameter")
func instanciaInimigoC(inimigoCena: PackedScene, inimigoDados: DatabaseInimigos):
	pass
	
func _on_instanciar(): #instanciar somente para fases em que o boss instancia fora da fase de instanciamento
	pass
	
func _on_encerra_instanciar():# para o intanciar somente para fases em que o boss instancia fora da fase de instanciamento
	pass

func _on_inimigo_desapareceu(horda: Node2D) -> void:
	print_debug("desapareceu — horda: ", horda.name if is_instance_valid(horda) else "inválida")
	print_debug("vivos na horda: ", vivos_por_horda.get(horda, "não encontrada"))
	print_debug(estadoAtual)
	print_debug(boss.estado_atual)
	print_debug(pare_instanciar_PF)
	print_debug(boss.podeInstanciar)
		
	if not vivos_por_horda.has(horda):
		return
	
	vivos_por_horda[horda] -= 1
	
	if vivos_por_horda[horda] <= 0:
		vivos_por_horda.erase(horda)
		quantHordasNaTela -= 1
		
		if is_instance_valid(horda):
			horda.queue_free()
		
	if pare_instanciar_PF == false and quantInimigosAInstanciar > 0  and quantHordasNaTela <= 0:
		randomizaInimigos()
	elif pare_instanciar_PF == false and quantInimigosAInstanciar <= 0  and quantHordasNaTela <= 0:
		pare_instanciar_PF = true  # para de instanciar quando acabou a cota
	elif quantInimigosAInstanciar <= 0 and quantHordasNaTela <= 0 and quantHordasNaTela <= 0:
		if estadoAtual != Estados.Aguardando:
			_on_onda_encerrada()
	elif quantInimigosAInstanciar > 0 and quantHordasNaTela <= 0 and quantHordasNaTela <= 0 and boss.podeInstanciar:
		randomizaInimigos()
