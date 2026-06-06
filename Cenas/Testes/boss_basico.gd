extends CharacterBody2D
class_name BossBasico
"""
O boss deve ter estados:
	batalhando -> instancia inimigos para o jogador ter que lidar
	fase de dano -> boss fica vulneravel a ataques do jogador
	morrendo -> a vida do boss acabou
	cutScene -> o boss faz alguma animação com ou sem dialogo  
O boss basico deve ter:
	funções:
		
"""
@export var dadosBoss: DatabaseBosses

#Criando variaveis tangiveis
var nome:String
var vida:float
var quant_fases:int
var janela_vul:float
var cenas_inimigos: Array[PackedScene]
var dados_inimigos: Array[DatabaseInimigos]
var quant_spawn_inimigos: Array[int]
var projetil_menor_s: PackedScene
var projetil_menor_r: PackedScene
var projetil_medio: PackedScene
var projetil_maior: PackedScene

var vidaMaxima:float
var timer:Timer
var sliderVida:ProgressBar
var podeInstanciar:bool
var faseDanoIniciada:bool
var hitbox: Area2D
var faseAtual:int
var fases_realizadas:=0
var cutscene_final:=false
var anim:AnimatedSprite2D

#sinais para o gerenciador de batalha
signal onda_iniciada
signal boss_morreu
@warning_ignore("unused_signal")
signal chamar_instanciar
@warning_ignore("unused_signal")
signal fechar_instanciar
signal cutscene_encerrada

enum Estados{
	Batalhando,
	Morrendo,
	FaseDano,
	CutScene
}

@export var estado_atual: = Estados.CutScene

func _ready() -> void:
	var tipoDados = TipoDatabaseBosses.new()
	nome = dadosBoss.textoNome
	vida = tipoDados.valorVida.values()[dadosBoss.vidaTotal]
	vidaMaxima = vida
	janela_vul = tipoDados.valorJanelaVulnerabilidade.values()[dadosBoss.janelaVulnerabilidade]
	quant_fases = dadosBoss.quantidadeFases + 1
	projetil_maior = dadosBoss.projetilMaior
	projetil_menor_s = dadosBoss.projetilMenor1
	projetil_menor_r = dadosBoss.projetilMenor2
	projetil_medio = dadosBoss.projetilMedio
	"""
	Aderindo valores para inimigos para quando for instancia-los
	cada tipo e cena de inimigo precisa estar em ordem no inspetor para que eles possuam o mesmo indice na hora de instanciar. 
	pega os dados de cada tipo de inimigo e cada cena desse mesmo inimigo na mesma ordem, além da quantidade spawn de cada um e atribui esses valores 
	"""
	dados_inimigos.assign(dadosBoss.tiposInimigos)
	cenas_inimigos.assign(dadosBoss.cenasInimigos)
	for inimigo in dados_inimigos:
		quant_spawn_inimigos.append(inimigo.valor_quant_spawn)
		
	timer = $JanelaVulnerabilidade
	timer.wait_time = janela_vul
	sliderVida = $ProgressBar
	sliderVida.max_value = vidaMaxima
	hitbox = $area2d
	faseDanoIniciada = false 
	podeInstanciar = false 
	hitbox.monitoring = false
	faseAtual = 0
	fases_realizadas = 0
	cutscene_final = false
	mudar_estado(Estados.CutScene) #->teste?
	
func mudar_estado(novo_estado: Estados) -> void:
	estado_atual = novo_estado

	match estado_atual:
		Estados.Batalhando:
			#chama as funções que realizaa as operações de BATALHANDO
			hitbox.monitoring = false
			podeInstanciar = true
			faseDanoIniciada = false
			emit_signal("onda_iniciada")
			"""
			se instanciar cada tipo de inimigo aleatoriamente 2 vezes:
				deve receber um aviso do gerenciador de batalhas e
				passar pro estado fasedano
			"""
		Estados.Morrendo:
			#chama as funções que realizaa as operações de MORRRENDO
			hitbox.monitoring = false
			podeInstanciar = false
			faseDanoIniciada = false
			emit_signal("boss_morreu")
			"""
			Inicia a animação final
			Encerrou a animação final
			aparece a tela de resultados 
			"""
		Estados.FaseDano:
			"""
			na fase de dano o boss irá aparecer para atirar no player
			e estará vulneravel a dano
			"""
			await  get_tree().create_timer(1).timeout
			anim.play("descendo")
			podeInstanciar = false
			#chama as funções que realizaa as operações de FASEDANO
			#espera o tempo da animação acabar
			await anim.animation_finished
			faseAtual +=1
			fases_realizadas +=1
			timer.start() #dá play no timer janelaVulnerabilidade
			hitbox.monitoring = true #ativa a hitbox
			faseDanoIniciada = true #ativa pode_tomar_dano
			faseDano()
			#quando acaba o timer, ele já chama a propria função e passa pra cutscene
			
			"""
			Inicia animação
			Encerrou a animação
			enquanto o timer de janela de vulnerabilidade não acabar:
				hitbox aparece
				boss pode tomar dano
			quando acabar
			passa pro estado cutscene
			"""
		Estados.CutScene:
			hitbox.monitoring = false
			podeInstanciar = false
			faseDanoIniciada = false
			
			await  get_tree().create_timer(2).timeout
			
			if cutscene_final:
				mudar_estado(Estados.Morrendo)
			elif vida > 0:
				emit_signal("cutscene_encerrada")
			else:
				mudar_estado(Estados.Morrendo)
			"""
			Inicia o dialogo e animação
			Encerrou o dialogo e animação
			se a vida do boss for diferente de zero:
				vai pro estado batalhando
			se não:
				vai pro estado morrendo
			"""
			
func faseDano():	#OVERRIDE
	pass

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	sliderVida.value = vida

func receber_dano(dano: float) -> void:
	if faseDanoIniciada:
		vida -= dano
		
func _on_janela_vulnerabilidade_timeout() -> void:
	hitbox.monitoring = false
	faseDanoIniciada = false
	timer.stop()
	
	if fases_realizadas >= quant_fases:
		cutscene_final = true
		mudar_estado(Estados.CutScene)
		
	elif vida > 0:
		mudar_estado(Estados.CutScene)
		anim.play("subindo")
	else:
		mudar_estado(Estados.Morrendo)
