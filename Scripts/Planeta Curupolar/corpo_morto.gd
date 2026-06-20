extends Area2D

@export var forca_puxao: float = 300.0

var corpos_dentro: Array = []


func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _physics_process(_delta):
	for body in corpos_dentro:
		if body.has_method("puxar_para"):
			body.puxar_para(global_position, forca_puxao)


func _on_body_entered(body):
	if not corpos_dentro.has(body):
		corpos_dentro.append(body)


func _on_body_exited(body):
	corpos_dentro.erase(body)
