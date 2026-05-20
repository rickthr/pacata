extends CharacterBody2D

"""
Cada tipo de inimigo terá seu proprio padrão de movimento, instanciamento de projeteis, dano, velocidade, vida. 
Mas todos se basearão em um enemy_data_basic, para que eles compartilhem as mesmas variaveis, colisão e morte.
"""
@export var dadosTipoInimigo: DatabaseInimigos #PEGA DIRETAMENTE TODOS OS DADOS DE UM TIPO DE INIMIGO

#Criando variaveis tangiveis
var velocidade : int 
var vida : int 
var dano_colisao : int 
var dano_projetil : int 
var projetil : PackedScene 
var sprite : Texture2D 
var tipo : String 
	
@onready var anim = $animated
var direction = Vector2.ZERO
var player

func  _ready() -> void:
	#Transferindo todos os valores do tipo de inimigo para variaveis utilizaveis
	velocidade = dadosTipoInimigo.valor_velocidade
	vida = dadosTipoInimigo.valor_vida
	dano_colisao = dadosTipoInimigo.valor_danoColisao
	dano_projetil = dadosTipoInimigo.valor_danoProjetil
	projetil = dadosTipoInimigo.tipo_projetil
	sprite = dadosTipoInimigo.sprite
	tipo = dadosTipoInimigo.tipo
	
	#player = Global.Player -> criar GLOBAL
	
#Fazer movimentação(Override)
func _physics_process(delta: float) -> void:
	movimento()
	move_and_slide()
	
func movimento():#FUNÇÃO OVERRIDE PARA MOVIMENTO
	#movimento básico
	velocity = direction*velocidade
	
#Fazer instanciar projeteis(Override)
func instancia_projetil():
	var num_projeteis_instanciados = 1
	var atual_instanciado : Array
	
	for proj in range(num_projeteis_instanciados):
		var atual_projetil_instanciado = projetil.instantiate()
		atual_instanciado.append(atual_projetil_instanciado)
		get_tree().current_scene.add_child(atual_instanciado[proj])
		#DEFINIR DIREÇÃO EM QUE PROJETEIS SÃO INSTANCIADOS 
		#func defini_direcao(atual_instanciado[proj])
			
#Definir direção de instanciamento de projeteis
func defini_direcao_proj(projetil:PackedScene) -> Vector2:
	direction = Vector2.ZERO
	#Override para cada tipo de direction respectivo ao tipo de inimigo
	return direction
	
#Dar dano no player
func dar_dano(corpo: Node2D):
	if corpo.has_method("receber_dano"):
		corpo.receber_dano(dano_colisao)
		print("dando dano no player: ", dano_colisao)
	#Chama a função 'receber_dano(dano_colisao)' do player
	
#Receber dano dos projeteis do player
func receber_dano(dano_proj : int): #Chamar essa função no projetil
	vida -= dano_proj
	morte()

#Fazer colisão
func _on_area_2d_body_entered(corpo: Node2D) -> void:
	if corpo.is_in_group("jogador"):
		hit()
		dar_dano(corpo)
		
#Fazer HIT
func hit():
	print('toquei no player')
	#fazer animação de hit
	
#Fazer morte
func morte():
	if vida <= 0:
		#faz animação de morte
		print("morri")
		#depois da animação de explosão da nave
		queue_free()
