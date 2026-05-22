extends Resource
class_name TipoDatabaseInimigos

#GUARDA AS VARIAVEIS PADRÃO PARA CADA TIPO DE INIMIGO, QUALQUER NOVA VARIAVEL DEVE SER ADICIONADA AQUI

enum Vida{Baixa, Media, Alta}
enum DanoColisao{Baixo, Medio, Alto}
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

@export var valorVelocidade = {
	Velocidade.Baixa : 150,
	Velocidade.Media : 250,
	Velocidade.Alta : 300
}
