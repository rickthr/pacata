extends InimigoBasico
"""
	Para esse tipo de inimigo, deve-se fazer um ajuste de angulo nom momento em que ele nascer. Pois ele deve estar em um angulo de 45° e ir reto para frente até sair da tela.
	O angulo irá depender se ele está sendo instanciado na parte de cima ou de baixo da tela.
	Teoricamente, implementar a direção (1,1) ou (1,-1) realiza essa mecanica
	Se ele foi instanciado na direita
"""

#func movimento():#FUNÇÃO OVERRIDE PARA MOVIMENTO
	#velocity = direcao*velocidade

func altera_direcao_lado():#OVERRIDE
	if lado == LadoInstanciado.ESQUERDA:
		direcao = Vector2(1, -1).normalized()
	elif lado == LadoInstanciado.DIREITA:
		direcao = Vector2(-1, 1).normalized()
		
func defini_direcao_projetil() -> Vector2:
	direcao_projetil = Vector2.UP
	#Override para cada tipo de direcao respectivo ao tipo de inimigo
	return direcao_projetil
