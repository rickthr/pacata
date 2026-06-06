#oficial nave 100%
extends CharacterBody2D

@export var velocidade: float = 300.0

var sinal_ativo: bool = true
var forca_externa: Vector2 = Vector2.ZERO
var vida: int = 3


func _physics_process(delta):
	var direcao = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	velocity = direcao * velocidade

	if sinal_ativo:
		velocity += forca_externa
	else:
		velocity += forca_externa * 1.5

	move_and_slide()

	forca_externa = forca_externa.move_toward(Vector2.ZERO, 300.0 * delta)


func alterar_sinal(ativo: bool):
	sinal_ativo = ativo

	if sinal_ativo:
		print("Sinal restaurado")
	else:
		print("Sinal interrompido")


func aplicar_empurrao(forca: Vector2):
	forca_externa += forca


func puxar_para(posicao_alvo: Vector2, forca: float):
	var direcao = global_position.direction_to(posicao_alvo)
	forca_externa += direcao * forca


func receber_dano(valor: int):
	vida -= valor
	print("Vida da nave: ", vida)

	if vida <= 0:
		destruir_nave()


func destruir_nave():
	print("Nave destruída")
