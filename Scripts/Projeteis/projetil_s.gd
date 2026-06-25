extends ProjetilBasico

var posica_alvo : Vector2
var alvo_travado: bool = false

func _ready() -> void:
	super._ready()
	
	await get_tree().create_timer(1.8).timeout
	queue_free()
	
func movimento(delta: float):
	
	var distancia = global_position.distance_to(jogador.global_position)
	if distancia > 200 and not alvo_travado:
		posica_alvo = jogador.global_position 
	else:
		alvo_travado = true
	
	direcao = (posica_alvo - global_position).normalized() #-> direcao certa quando tiver o jogador na tela
	super.movimento(delta)
	
	
	
		
	
	
