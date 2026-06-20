extends InimigoBasico
"""
Esse inimigo faz um movimento senoidal que começa avançando na diagonal, seguindo a direção contraria ao lado que ele foi instanciado.
Por exemplo: se ele for instanciado do lado direito, a direção dele será para a esquerda e ele vai atirar para cima. Vice-versa
"""
var tempo: float = 0.0 #-> faz a função de delta
@export var amplitude: float  # largura da onda
@export var frequencia: float  # velocidade da oscilação

func movimento():		
	tempo += get_process_delta_time()
	
	velocity = direcao * velocidade 
	# oscilação perpendicular à direção de avanço
	var perpendicular = Vector2(-direcao.y, direcao.x) # cria a oscilação entre (-1, 0, 1)
	"""
	NOTA: tirar esse desenho daqui
	velocity  +=  perpendicular  *  cos(tempo * frequencia)  *  amplitude
   │                │                      │                     │
   │                │                      │                     │
   ▼                ▼                      ▼                     ▼
velocidade       direção da           quanto vale          quão largo
principal     oscilação (90°          a oscilação          é o balanço
 da nave       da direção)          agora (-1 a 1)         de lado a lado
                                          │
                                    ┌─────┴─────┐
                                    │           │
                              tempo * frequencia
                                    │           │
                                    ▼           ▼
                               quanto        quão
                               tempo         rápido
                               passou        oscila	
	"""
	velocity += perpendicular * cos(tempo * frequencia) * amplitude
	# rotaciona a nave para onde está indo
	rotation = velocity.normalized().angle()
	
func altera_direcao_lado():#OVERRIDE
	if lado == LadoInstanciado.ESQUERDA:
		direcao = Vector2(1, 0).normalized()
	elif lado == LadoInstanciado.DIREITA:
		direcao = Vector2(-1, 0).normalized()

func defini_direcao_proj() -> Vector2:
	if lado == LadoInstanciado.ESQUERDA:
		direcao_projetil = Vector2(-direcao.y, direcao.x).normalized()
	elif lado == LadoInstanciado.DIREITA:
		direcao_projetil = Vector2(direcao.y, direcao.x).normalized()
	#Override para cada tipo de direcao respectivo ao tipo de inimigo
	return direcao_projetil
