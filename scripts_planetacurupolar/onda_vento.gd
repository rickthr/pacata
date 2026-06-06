extends Area2D

@export var velocidade: float = 350.0
@export var forca_empurrao: float = 500.0
@export var limite_esquerdo: float = -100.0

var direcao: Vector2 = Vector2.LEFT
var corpos_dentro: Array = []


func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _physics_process(delta):
	global_position += direcao * velocidade * delta

	for body in corpos_dentro:
		if body.has_method("aplicar_empurrao"):
			body.aplicar_empurrao(direcao * forca_empurrao)

	if global_position.x <= limite_esquerdo:
		queue_free()


func _on_body_entered(body):
	if not corpos_dentro.has(body):
		corpos_dentro.append(body)


func _on_body_exited(body):
	corpos_dentro.erase(body)
