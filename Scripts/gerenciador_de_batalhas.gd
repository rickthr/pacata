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

var quantInimigosInstanciados:int
var tiposInimigos: Array[PackedScene]

func _ready() -> void:
	boss.onda_iniciada.connect(_on_onda_iniciada)
	boss.boss_morreu.connect(_on_boss_morreu)
	quantInimigosInstanciados = 0
	tiposInimigos.assign(boss.cenas_inimigos)
	randomizaInimigos()

func _on_onda_iniciada() -> void:
	quantInimigosInstanciados = 0
	randomizaInimigos()
	pass
	
func _on_onda_encerrada() -> void:
	boss.mudar_estado(BossBasico.Estados.FaseDano)

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
	
func randomizaInimigos():
	randomize()
	var indice = randi() % boss.dadosBoss.cenasInimigos.size()
	var inimigo_selecionado = boss.dadosBoss.cenasInimigos[indice]
	selecionaInstaciamento(inimigo_selecionado, indice)
	
func selecionaInstaciamento(c_inimigo: PackedScene, ind:int) -> void:
	var tipo_selecionado = boss.dadosBoss.tiposInimigos[ind]
	for i in boss.dadosBoss.tiposInimigos:
		if tipo_selecionado.tipo == "A":
			print_debug("tipo a")
			instanciaInimigoA(c_inimigo,tipo_selecionado)
			break
		elif tipo_selecionado.tipo == "B":
			print_debug("tipo b")
		elif tipo_selecionado.tipo == "C":
			print_debug("tipo c")
			#pode adicionar mais elifs aqui
		else:
			print_debug("inimigo desconhecido")
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
	
func _on_inimigo_sai_da_tela() -> void:
	if quantInimigosInstanciados >= 6:
		_on_onda_encerrada()

func _on_inimigo_morri() -> void:
	if quantInimigosInstanciados >= 6:
		_on_onda_encerrada()
