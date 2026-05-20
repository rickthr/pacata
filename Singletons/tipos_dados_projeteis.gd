extends Resource
class_name TipoDatabaseProjeteis

enum DanoProjetil{Baixo, Medio, Alto}
enum Velocidade{Baixa, Media, Alta}

@export var valorDanoProjetil = {
	DanoProjetil.Baixo : 1,
	DanoProjetil.Medio : 3,
	DanoProjetil.Alto : 5
}

@export var valorVelocidade = {
	Velocidade.Baixa : 50,
	Velocidade.Media : 100,
	Velocidade.Alta : 150
}
