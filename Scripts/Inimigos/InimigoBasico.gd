extends CharacterBody2D

"""
Cada tipo de inimigo terá seu proprio padrão de movimento, instanciamento de projeteis, dano, velocidade, vida. 
Mas todos se basearão em um enemy_data_basic, para que eles compartilhem as mesmas variaveis, colisão e morte.
"""
@export var dadosTipoInimigo: DatabaseInimigos #PEGA DIRETAMENTE TODOS OS DADOS DE UM TIPO DE INIMIGO

#Criando variaveis tangiveis
var velocidade : float 
var vida : int 
var dano_colisao : int 
var projetil : PackedScene 
var tipo : String 
	
@onready var anim = $animated
var direcao_projetil = Vector2.ZERO
var direcao = Vector2.ZERO
var jogador

func  _ready() -> void:
	
	#Transferindo todos os valores do tipo de inimigo para variaveis utilizaveis
	var tiposDados = TipoDatabaseInimigos.new()
	velocidade = tiposDados.valorVelocidade.values()[dadosTipoInimigo.valor_velocidade]
	vida = tiposDados.valorVida.values()[dadosTipoInimigo.valor_vida]
	dano_colisao = tiposDados.valorDanoColisao.values()[dadosTipoInimigo.valor_danoColisao]
	projetil = dadosTipoInimigo.tipo_projetil
	tipo = dadosTipoInimigo.tipo
	
	jogador = Global.Jogador
	
#Fazer movimentação(Override)
func _physics_process(delta: float) -> void:
	movimento()
	move_and_slide()
	
func movimento():#FUNÇÃO OVERRIDE PARA MOVIMENTO
	#movimento básico
	velocity = direcao*velocidade
	
#Fazer instanciar projeteis(Override)
func instancia_projetil():
	var num_projeteis_instanciados = 1
	var projeteis_instanciados : Array
	
	for proj in range(num_projeteis_instanciados):
		var atual_projetil_instanciado = projetil.instantiate()
		projeteis_instanciados.append(atual_projetil_instanciado)
		#DEFINIR DIREÇÃO EM QUE PROJETEIS SÃO INSTANCIADOS 
		atual_projetil_instanciado.direcao = defini_direcao_proj()
		atual_projetil_instanciado.global_position = global_position
		atual_projetil_instanciado.global_position.x -= 100
		get_tree().current_scene.add_child(atual_projetil_instanciado)
			
#Definir direção de instanciamento de projeteis
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
		queue_free()

func _on_timer_atirar_timeout() -> void:
	instancia_projetil()
