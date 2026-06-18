extends ProjetilBasico

func _ready() -> void:
	super()
	direcao = (jogador.global_position - global_position).normalized() #-> direcao certa quando tiver o jogador na tela
