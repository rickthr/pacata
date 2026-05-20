extends Resource
class_name TipoDatabaseInimigos

#GUARDA AS VARIAVEIS PADRÃO PARA CADA TIPO DE INIMIGO, QUALQUER NOVA VARIAVEL DEVE SER ADICIONADA AQUI

enum Vida{Baixa, Media, Alta}
enum DanoColisao{Baixo, Medio, Alto}
enum DanoProjetil{Baixo, Medio, Alto}
enum Velocidade{Baixa, Media, Alta}

@export var valorVida = {
	Vida.Baixa : 1,
	Vida.Media : 2,
	Vida.Alta : 3
}

@export var valorDanoColisao = {
	DanoColisao.Baixo : 1,
	DanoColisao.Medio : 2,
	DanoColisao.Alto : 3
}

@export var valorDanoProjetil = {
	DanoProjetil.Baixo : 1,
	DanoProjetil.Medio : 3,
	DanoProjetil.Alto : 5
}

@export var valorVelocidade = {
	Vida.Baixa : 100,
	Vida.Media : 150,
	Vida.Alta : 200
}
