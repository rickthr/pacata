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
@export var projetilMaior: PackedScene
@export var projetilMedio: PackedScene
@export var projetilMenor1: PackedScene
@export var projetilMenor2: PackedScene
