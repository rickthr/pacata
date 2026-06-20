extends ProjetilBasico

func _ready() -> void:
	super._ready()
	direcao = Vector2.DOWN

func movimento(delta: float):
	position += velocidade * direcao * delta
