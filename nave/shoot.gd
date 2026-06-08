extends Area2D

var nave
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print_debug(collision_layer, collision_mask)
	nave = Global.Jogador
	await get_tree().create_timer(6.5).timeout
	queue_free()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.y-= 2

func _on_body_entered(body: Node2D) -> void:
	print_debug("acertei algo", body)
	
	if body.is_in_group("Inimigos"):
		Global.score+=10
		queue_free()
	
	if body.is_in_group("asteroid"):
		print_debug("acertei asteroid")
		Global.score+=15
		body.receber_dano(nave.dano_bala)
		queue_free()
