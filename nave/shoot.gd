extends Area2D
@export var velocidade:int
@export var dano:int
var nave

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	nave = Global.Jogador
	await get_tree().create_timer(6.5).timeout
	queue_free()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.y-= velocidade * delta

func _on_body_entered(body: Node2D) -> void:
	print_debug("acertei algo", body)
	
	if body.is_in_group("Inimigos"):
		Global.score+=10
		
	if body.is_in_group("Boss"):
		body.receber_dano(dano)
	
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("asteroid"):
		print_debug("acertei asteroid")
		Global.score+=15
		area.receber_dano(nave.dano_bala)
		queue_free()
