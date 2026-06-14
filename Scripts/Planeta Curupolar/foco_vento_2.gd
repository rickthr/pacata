extends Area2D

@export var direcao_vento: Vector2 = Vector2.RIGHT
@export var forca_vento: float = 450.0

var corpos_dentro: Array = []


func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _physics_process(_delta):
	for body in corpos_dentro:
		if body.has_method("aplicar_empurrao"):
			body.aplicar_empurrao(direcao_vento.normalized() * forca_vento)


func _on_body_entered(body):
	if not corpos_dentro.has(body):
		corpos_dentro.append(body)


func _on_body_exited(body):
	corpos_dentro.erase(body)
