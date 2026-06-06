extends Area2D
class_name ProjetilBasico

"""
Cada tipo de projetil terá seu proprio padrão de movimento, dano e velocidade.
Mas todos se basearão em um ProjetilBasico, para que eles compartilhem as mesmas variaveis, colisão e 'destruição'.
"""
@export var dadosTipoProjetil: DatabaseProjeteis #PEGA DIRETAMENTE TODOS OS DADOS DE UM TIPO DE PROJETIL

"""
@export var valorDano: TipoDatabaseProjeteis.DanoProjetil
@export var valorVelocidade: TipoDatabaseProjeteis.Velocidade
@export var tipo: String
@export var descricao: String #ou efeitos, a decidir
"""

var dano: int
var velocidade: float
var tipo: String
var descricao: String

var jogador
var direcao:= Vector2.DOWN
var sprite: Sprite2D

func _ready() -> void:
	var tiposDados = TipoDatabaseProjeteis.new()
	dano = tiposDados.valorDanoProjetil.values()[dadosTipoProjetil.valorDano]
	velocidade = tiposDados.valorVelocidade.values()[dadosTipoProjetil.valorVelocidade]
	tipo = dadosTipoProjetil.tipo
	descricao = dadosTipoProjetil.descricao
	
	jogador = Global.Jogador
	sprite = $sprite

func _process(delta: float) -> void:
	movimento(delta)
	flip()

#FAZER MOVIMENTO
func movimento(delta: float):
	#recebe uma direção do instanciador que deve seguir
	#a direcao é definida no script do inimigo que instanciou o projetil
	position += direcao * velocidade * delta
	
func flip():
	sprite.flip_v = direcao.y < 0

#FAZER DAR DANO
func dar_dano():
	print("dando dano no jogador: ", dano)
	if jogador.has_method("receber_dano"):
		jogador.receber_dano(dano)
	#Chama a função 'receber_dano(dano)' do jogador

#FAZER SER DESTRUIDA
func autoDestruicao():
	#animação de destruição(se tiver)
	queue_free()

#FAZER COLISAO
func _on_body_entered(corpo: Node2D) -> void:
	if corpo.is_in_group("jogador"):
		dar_dano()#dar dano no jogador
	autoDestruicao()
		

#ao sair da tela
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	autoDestruicao()
