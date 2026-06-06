extends Resource
class_name TipoDatabaseBosses
"""
Guarda as variaveis que cada boss deve ter, tais como:
	Tipos de inimigos(array)
	Vida total
	Quantidade de fases
	Janela de vulnerabilidade(tempo em que o inimigo pode receber dano) 
"""
enum Vida {Baixa, Media, Alta}
enum QuantidadeFases {Uma, Duas, Tres}
enum JanelaVulnerabilidade {Curta, Media, Longa}

var valorVida = {
	Vida.Baixa: 100,
	Vida.Media: 300,
	Vida.Alta: 600
}

var valorJanelaVulnerabilidade = {
	JanelaVulnerabilidade.Curta: 10.0,
	JanelaVulnerabilidade.Media: 15.0,
	JanelaVulnerabilidade.Longa: 20.0
}
