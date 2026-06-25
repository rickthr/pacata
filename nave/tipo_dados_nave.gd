extends Resource
class_name TipoDatabaseNave

enum AtaqueNave{Baixo, Medio, Alto}
enum SpeedNave{Baixa, Media, Alta}
enum ResistenciaNave{Baixa, Media, Alta}

@export var valorAtaqueNave= {
	AtaqueNave.Baixo : 1,
	AtaqueNave.Medio : 2,
	AtaqueNave.Alto : 3
}

@export var valorVelocidadeNave = {
	SpeedNave.Baixa : 300,
	SpeedNave.Media : 500,
	SpeedNave.Alta : 800
}

@export var valorResistenciaNave = {
	ResistenciaNave.Baixa : 5,
	ResistenciaNave.Media : 10,
	ResistenciaNave.Alta : 15
}
