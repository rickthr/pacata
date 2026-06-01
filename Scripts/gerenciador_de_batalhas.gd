extends Node2D
class_name GerenciadorBatalhas

"""
O gerenciador de batalhas deve controlar os aspectos mais relevantes de uma battle boss. No caso: iniciar a batalha, instanciar os tipos de inimigos(em ordem aleatoria) nos especficos lugares randomizados de cada tipo, verificar a vida do boss, alternar os estados do boss, encerrar a batalha.
precisa de um contador de quantos tipos já foram instanciados
		e saber quando todos os inimigos da wave morreram ou sairam da tela para avançar -> essa função deve estar no gerenciador de batalhas, não aqui
		pode começar a instanciar
"""
@export var boss: BossBasico

enum Estados{
	Inativo,      # antes da batalha começar
	Instanciando, # onda ativa, inimigos sendo spawnados
	Aguardando,   # inimigos vivos, esperando todos morrerem
	Encerrado     # boss morreu, batalha acabou
}

var estadoAtual: Estados
var tiposInimigos: Array[PackedScene]
var posInstanciar: Marker2D
@export var quantInimigosAInstanciar:int
@export var maxQuantHordasNaTela:int
var quantHordasNaTela:int
var saiuDaTelaOuMorreu:bool = false
var cenaHorda:Node2D
var pare_instanciar_PF:bool 

func _ready() -> void:
	boss.onda_iniciada.connect(_on_onda_iniciada)
	boss.boss_morreu.connect(_on_boss_morreu)
	boss.chamar_instanciar.connect(_on_instanciar)
	boss.fechar_instanciar.connect(_on_encerra_instanciar)
	tiposInimigos.assign(boss.cenas_inimigos)
	estadoAtual = Estados.Inativo
	randomizaInimigos()
	await  boss.ready
	boss.mudar_estado(BossBasico.Estados.CutScene)
	

func _on_onda_iniciada() -> void:
	mudaEstado(Estados.Instanciando)
	pass
	
func _on_onda_encerrada() -> void:
	mudaEstado(Estados.Aguardando)  # gerenciador para de instanciar
	boss.mudar_estado(BossBasico.Estados.FaseDano)  # depois avisa o boss

func _on_boss_morreu() -> void:
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
	estadoAtual = estadoNovo
	match estadoAtual:
		Estados.Inativo:
			boss.mudar_estado(boss.Estados.CutScene)
			pass
		Estados.Instanciando:
			boss.mudar_estado(boss.Estados.Batalhando)
			quantHordasNaTela = 0
			randomizaInimigos()
		Estados.Aguardando:
			boss.mudar_estado(boss.Estados.FaseDano)
			pass
		Estados.Encerrado:
			boss.mudar_estado(boss.Estados.Morrendo)
			pass
	
func randomizaInimigos():
	randomize()
	var tamanho_inimigos = boss.dadosBoss.cenasInimigos.size()
	if tamanho_inimigos <= 0: 
		return
		
	var indice = randi() % tamanho_inimigos
	var inimigo_selecionado = boss.dadosBoss.cenasInimigos[indice]
	selecionaInstaciamento(inimigo_selecionado, indice)
	boss.dadosBoss.cenasInimigos.erase(inimigo_selecionado)
	
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
	print_debug(estadoAtual)
	print_debug(boss.estado_atual)
	quantHordasNaTela -= 1
	
	if horda and is_instance_valid(horda):
		horda.queue_free()
	
	if pare_instanciar_PF == false:
		randomizaInimigos()
		
	elif quantInimigosAInstanciar <= 0 and quantHordasNaTela <= 0:
		if estadoAtual != Estados.Aguardando:  # evita chamar duas vezes
			_on_onda_encerrada()
	elif quantInimigosAInstanciar > 0 and quantHordasNaTela <= 0 and boss.podeInstanciar == true:
		randomizaInimigos()
