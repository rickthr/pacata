extends Area2D

var podeIr: bool = false

var velocidade: float = 600.0
var direcao: Vector2 = Vector2.ZERO
var jogador: Nave

func _ready() -> void:
	await get_tree().process_frame
	jogador = Global.Jogador

func _process(delta: float) -> void:
	if not podeIr:
		direcao = global_position.direction_to(jogador.global_position)
		rotation = direcao.angle()
	else:
		position += direcao * velocidade * delta

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("jogador"):
		jogador.desapareci_broca = true
	pass 
