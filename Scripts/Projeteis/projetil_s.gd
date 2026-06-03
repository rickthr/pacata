extends ProjetilBasico

func movimento(delta:float):
	direcao = Vector2(1,1)
	#direcao = (jogador.global_position - global_position).normalized() -> direcao certa quando tiver o jogador na tela
	position += direcao * velocidade * delta
	pass
