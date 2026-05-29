extends InimigoBasico

"""
Esse inimigo irá se mover reto, seguindo a direção contraria ao lado que ele foi instanciado.
Por exemplo: se ele for instanciado do lado direito, a direção dele será para a esquerda e ele vai atirar para cima. Vice-versa
"""

#func movimento():
	#velocity = direcao*velocidade
	
func altera_direcao_lado():#OVERRIDE
	if lado == LadoInstanciado.DIREITA:
		direcao = Vector2.LEFT.normalized()
	else:
		direcao = Vector2.RIGHT.normalized()
		
#Definir direção de instanciamento de projeteis (OVERRIDE)
func defini_direcao_proj() -> Vector2:
	if lado == LadoInstanciado.DIREITA:
		direcao_projetil = Vector2.UP
	else:
		direcao_projetil = Vector2.DOWN
	
	#Override para cada tipo de direcao respectivo ao tipo de inimigo
	return direcao_projetil
