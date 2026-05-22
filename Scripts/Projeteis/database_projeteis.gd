extends Resource
class_name DatabaseProjeteis

"""
ESSA CLASSE DEVE ATRIBUIR OS VALORES PARA UM DETERMINADO TIPO DE PROJETIL BASEADO NOS PARAMETROS DE tipos_dados_projeteis
"""

@export var valorDano: TipoDatabaseProjeteis.DanoProjetil
@export var valorVelocidade: TipoDatabaseProjeteis.Velocidade
@export var tipo: String
@export var descricao: String #ou efeitos, a decidir
