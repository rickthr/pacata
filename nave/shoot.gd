extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(6.5).timeout
	queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.y-=2



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Inimigos"):
		Global.score+=10
	queue_free()
