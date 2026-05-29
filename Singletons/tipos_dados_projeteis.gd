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
	Velocidade.Baixa : 250,
	Velocidade.Media : 350,
	Velocidade.Alta : 400
}
