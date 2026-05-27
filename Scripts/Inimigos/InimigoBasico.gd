extends CharacterBody2D
class_name InimigoBasico

"""
Cada tipo de inimigo terá seu proprio padrão de movimento, instanciamento de projeteis, dano, velocidade, vida. 
Mas todos se basearão em um enemy_data_basic, para que eles compartilhem as mesmas variaveis, colisão e morte.
Importante: verificar qual lado o inimigo foi instanciado. Criar uma variavel direita e outra esquerda, para determinar para qual lado o inimigo deve se direcionar, além de flipar a nave ou mudar o instanciador de projeteis de lugar
"""
@export var dadosTipoInimigo: DatabaseInimigos #PEGA DIRETAMENTE TODOS OS DADOS DE UM TIPO DE INIMIGO

#Criando variaveis tangiveis
var velocidade : float 
var vida : int 
var dano_colisao : int 
var projetil : PackedScene 
var tipo : String 
var quant_spawn:int
	
@onready var anim = $anim
var direcao_projetil = Vector2.ZERO
var direcao = Vector2.ZERO
var jogador
enum LadoInstanciado {ESQUERDA, DIREITA} 
var lado: LadoInstanciado

signal sai_da_tela
signal morri

func  _ready() -> void:
	definir_lado()
	altera_direcao_lado()
	#Transferindo todos os valores do tipo de inimigo para variaveis utilizaveis
	var tiposDados = TipoDatabaseInimigos.new()
	velocidade = tiposDados.valorVelocidade.values()[dadosTipoInimigo.valor_velocidade]
	vida = tiposDados.valorVida.values()[dadosTipoInimigo.valor_vida]
	dano_colisao = tiposDados.valorDanoColisao.values()[dadosTipoInimigo.valor_danoColisao]
	projetil = dadosTipoInimigo.tipo_projetil
	quant_spawn = dadosTipoInimigo.valor_quant_spawn
	tipo = dadosTipoInimigo.tipo
	
	jogador = Global.Jogador
	
@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	movimento()
	move_and_slide()

func movimento():#FUNÇÃO OVERRIDE PARA MOVIMENTO
	#movimento básico
	rotation = direcao.angle()
	velocity = direcao*velocidade
	
func definir_lado():
	if global_position.x < get_viewport().size.x/2:
		lado = LadoInstanciado.ESQUERDA
		$Sprite2D.flip_h = false
	else:
		lado = LadoInstanciado.DIREITA
		$Sprite2D.flip_h = true
	
func altera_direcao_lado():#OVERRIDE
	if lado == LadoInstanciado.ESQUERDA:
		direcao = Vector2(1, -1).normalized()
	elif lado == LadoInstanciado.DIREITA:
		direcao = Vector2(-1, 1).normalized()
	
#Fazer instanciar projeteis(Override)
func instancia_projetil():
	#verificar se ele intancia projeteis
	var num_projeteis_instanciados = 1
	var projeteis_instanciados : Array
	
	#mudar a posição do projetil para a posição de onde sai o tiro na nave
	for proj in range(num_projeteis_instanciados):
		var atual_projetil_instanciado = projetil.instantiate()
		projeteis_instanciados.append(atual_projetil_instanciado)
		#DEFINIR DIREÇÃO EM QUE PROJETEIS SÃO INSTANCIADOS 
		atual_projetil_instanciado.direcao = defini_direcao_proj()
		atual_projetil_instanciado.global_position = global_position
		atual_projetil_instanciado.global_position.x -= 70
		atual_projetil_instanciado.global_position.y -= 70
		get_tree().current_scene.add_child(atual_projetil_instanciado)
			
#Definir direção de instanciamento de projeteis (OVERRIDE)
func defini_direcao_proj() -> Vector2:
	direcao_projetil = Vector2.ZERO
	#Override para cada tipo de direcao respectivo ao tipo de inimigo
	return direcao_projetil
	
#Dar dano no jogador -> essa função deve ser passada para o script do projetil
func dar_dano():
	print("dando dano no jogador: ", dano_colisao)
	if jogador.has_method("receber_dano"):
		jogador.receber_dano(dano_colisao)
	#Chama a função 'receber_dano(dano_colisao)' do jogador
	
#Receber dano dos projeteis do jogador
func receber_dano(dano_proj : int): #Chamar essa função no projetil
	vida -= dano_proj
	morte()

#Fazer colisão
func _on_area_2d_body_entered(corpo: Node2D) -> void:
	if corpo.is_in_group("jogador"):
		hit()
		dar_dano()
		
#Fazer HIT
func hit():
	print('toquei no jogador')
	#fazer animação de hit
	
#Fazer morte
func morte():
	if vida <= 0:
		#faz animação de morte
		print("morri")
		#depois da animação de explosão da nave
		emit_signal("morri")
		queue_free()

func _on_timer_atirar_timeout() -> void:
	instancia_projetil()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	emit_signal("sai_da_tela")
	queue_free()
