extends Resource
class_name DatabaseBosses
"""
ESSA CLASSE DEVE ATRIBUIR OS VALORES PARA UM DETERMINADO BOSS BASEADO NOS PARAMETROS DE tipos_dados_bosses
"""

@export var textoNome: String
@export var vidaTotal: TipoDatabaseBosses.Vida
@export var quantidadeFases: TipoDatabaseBosses.QuantidadeFases
@export var janelaVulnerabilidade: TipoDatabaseBosses.JanelaVulnerabilidade
@export var tiposInimigos: Array[DatabaseInimigos]
@export var cenasInimigos: Array[PackedScene]
