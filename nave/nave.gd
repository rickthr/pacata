extends CharacterBody2D

const JUMP_VELOCITY = -400.0

@onready var shoot_l: Marker2D = $shoot_l
@onready var shoot_r: Marker2D = $shoot_r
@onready var animCorpo = $animCorpo
@onready var animAsas = $animAsas

@export var dadosNave : DatabaseNave
@export var label_vida : Label
@export var label_score : Label

var contador_flip :=0
var shoot = preload("res://nave/shoot.tscn")

var sinal_ativo: bool = false 
var forca_externa: Vector2 = Vector2.ZERO
var velocidade:int 
var vida :int
var dano_bala :int
var SPEED:int 
var pode_atirar := true
var direcao_atual := 0.0
var fazendo_curva := false

func flip():
	if contador_flip %2 == 0:
		$flip1/canhao.visible = true
		$flip2/card.visible = true
		
		$flip2/canhao.visible = false
		$flip1/card.visible = false
		
		
	else:
		$flip1/canhao.visible = false
		$flip2/card.visible = false
		
		$flip2/canhao.visible = true
		$flip1/card.visible = true
		
func receber_dano():
	vida -= 1
	label_vida.text = "Vida: " + str(vida)
	$naveHit.play()
	var tween = get_tree().create_tween()
	tween.tween_property(self,"modulate", Color.RED,0.5)
	tween.tween_property(self,"modulate", Color.WHITE,0.5)
	await get_tree().create_timer(2.0).timeout
	if vida == 0:
		$naveDead.play()
		await $naveDead.finished
		queue_free()

func _ready() -> void:
	add_to_group("jogador")
	print_debug(self)
	Global.Jogador = self
	print_debug(Global.Jogador)
	flip()
	var tipoDados = TipoDatabaseNave.new()
	dano_bala = tipoDados.valorAtaqueNave[dadosNave.valor_dano_nave]
	vida = tipoDados.valorResistenciaNave[dadosNave.vida_nave]
	SPEED = tipoDados.valorVelocidadeNave[dadosNave.speed_nave]
	print("SPEED: ", SPEED)
	print("vida: ", vida)
	print("dano: ", dano_bala)
	label_vida.text = "Vida: " + str(vida)
	label_score.text = "Score:" + str(Global.score)
	
	
func _physics_process(delta: float) -> void:
	
	position.x = clamp(position.x, 0, 1280)
	position.y = clamp(position.y, 0, 720)
	var direction_x := Input.get_axis("ui_left", "ui_right")
	var direction_y := Input.get_axis("ui_up", "ui_down")
	
	
	var direcao := Vector2(direction_x, direction_y)
	velocity = direcao * velocidade
	
	animacaoCurva(direcao.x, delta)
	
	if sinal_ativo:
		velocity += forca_externa
	else:
		velocity += forca_externa * 1.5
	forca_externa = forca_externa.move_toward(Vector2.ZERO, 300.0 * delta)

	if direction_y != 0:
		
		velocity.y = direction_y * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
		
	if direction_x !=0:
	
		velocity.x = direction_x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if Input.is_action_just_pressed("flip"):
		contador_flip+=1
		flip()
	
	if Input.is_action_pressed("atack") and pode_atirar:
		var new_shoot =  shoot.instantiate()
		$tiro.play()
		pode_atirar = false
		if contador_flip % 2 == 0:
			new_shoot.global_position = shoot_l.global_position
		else:
			new_shoot.global_position = shoot_r.global_position
		get_tree().root.add_child(new_shoot)
		await get_tree().create_timer(0.3).timeout
		pode_atirar = true
		
		
	move_and_slide()

#ANIMAÇÂO CURVA
func animacaoCurva(direcao_x: float, delta: float):
	var direcao_alvo =direcao_x
	direcao_atual = lerp(direcao_atual, direcao_alvo, 5.0 * delta)
	$Nave.flip_h = direcao_atual < 0
	
	if direcao_x != 0:
		if fazendo_curva == false:
			animAsas.play("curva")
			animCorpo.play("curva")
			fazendo_curva = true
		await animCorpo.animation_finished
		animCorpo.play("curva_loop")
		animAsas.play("curva_loop")
	else:
		fazendo_curva = false 
		animCorpo.play("RESET")
		animAsas.play("RESET")

#ANIMAÇÂO TIRO E COLETA
func animacaoTiro():
	
	pass
	
func animacaoColeta():
	pass

func aplicar_empurrao(forca: Vector2) -> void:
	forca_externa += forca
	
func _on_broca_body_entered(body: Node2D) -> void:
	#sinal emite morte do objeto q entrou na area
	if not body.is_in_group("inimigos"):
		body.queue_free()

func _on_flip_2_body_entered(body: Node2D) -> void:
	if contador_flip %2 == 0 and body.is_in_group("Minerios"):
		#coletou_minerio()
		pass
	else:
		receber_dano()

func _on_flip_1_body_entered(body: Node2D) -> void:
	if contador_flip %2 != 0 and body.is_in_group("Minerios"):
		#coletou_minerio()
		pass
	else:
		receber_dano()
