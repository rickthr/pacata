extends ParallaxBackground

@export var start_speed: int
var acceleration :int = 5
var speed : float

func _ready() -> void:
	speed = start_speed

func _process(delta: float) -> void:
	speed += acceleration * delta # a velocidade aumenta continuamente
	scroll_base_offset.y -= speed * delta #move o fundo independente da camera
	scroll_base_offset.x -= speed * delta #move o fundo independente da camera
# variavel interna do nodeparallax, define a velocidade com q o pb move os filhos
# incrementando para descer
