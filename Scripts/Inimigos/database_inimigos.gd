extends Resource
class_name DatabaseInimigos

"""
dados: vida, dano, velocidade, sprite e recompensa ao morrer.
"""
#GUARDA OS VALORES REAIS DE CADA TIPO, VINDO DIRETO DO INSPETOR
#ESSES SERÃO OS VALORES QUE IRÃO DIRETO PARA O PREFAB DE CADA TIPO DE INIMIGO

"""
enum Vida{Baixa, Media, Alta}
enum DanoColisao{Baixo, Medio, Alto}
enum Velocidade{Baixa, Media, Alta}
"""
@export var valor_vida: TipoDatabaseInimigos.Vida
@export var valor_danoColisao: TipoDatabaseInimigos.DanoColisao
@export var valor_velocidade: TipoDatabaseInimigos.Velocidade
@export var tipo_projetil: PackedScene
@export var valor_quant_spawn: int
@export var tipo: String
#essas duas variaveis não são necessarias pro inimigo, apenas para o gerenciador
