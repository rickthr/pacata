extends ProjetilBasico

func movimento(delta: float):
	direcao = Vector2.DOWN
	position += velocidade * direcao * delta
