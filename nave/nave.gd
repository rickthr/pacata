extends CharacterBody2D
class_name Nave

@onready var shoot_l: Marker2D = $NaveCorpo/shoot_l
@onready var shoot_r: Marker2D = $NaveCorpo/shoot_r
@onready var animCorpo = $animCorpo
@onready var animAsas = $animAsas
@onready var spriteBroca = $NaveCorpo/Broca/Sprite2D

@export var dadosNave : DatabaseNave
@export var bar_vida : TextureProgressBar
@export var label_quant_minerio: Label
@export var dano_recebido: int
var invencivel: bool = false

var contador_flip :=0
var shoot = preload("res://nave/shoot.tscn")

var sinal_ativo: bool = false 
var forca_externa: Vector2 = Vector2.ZERO
var velocidade:int 
var vida :int
var dano_bala :int
var SPEED:int 
var quant_minerios_coletados:=0

var pode_atirar := true
var direcao_atual := 0.0
var fazendo_curva := false
var pode_mexer:bool = true
var intensidade_shake: float = 4.0 
var velocidade_shake: float = 1 
var tremendo: bool = false

@export var desapareci_broca:bool

signal morri

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
	bar_vida.max_value = vida
	bar_vida.value = vida
	

func flip():
	if contador_flip %2 == 0:
		$NaveCorpo/flip1/canhao.visible = true
		$NaveCorpo/flip2/card.visible = true

		$NaveCorpo/flip2/canhao.visible = false
		$NaveCorpo/flip1/card.visible = false

	else:
		$NaveCorpo/flip1/canhao.visible = false
		$NaveCorpo/flip2/card.visible = false
		
		$NaveCorpo/flip2/canhao.visible = true
		$NaveCorpo/flip1/card.visible = true
		
func receber_dano():
	print_debug("cheguei")
	if invencivel or vida <= 0:
		return
		
	print_debug("cheguei")
	vida -= dano_recebido
	bar_vida.value = vida
	$naveHit.play()
	
	if vida <= 0:
		morrer()
		return
	print_debug("cheguei")
	
	invencivel = true
	
	var tween = get_tree().create_tween()
	
	tween.tween_property(self, "modulate", Color.RED, 0.1)
	tween.tween_property(self, "modulate", Color.WHITE, 0.1)
	
	for i in range(6):
		tween.tween_property(self, "modulate", Color(1, 1, 1, 0.3), 0.12) # Fica transparente
		tween.tween_property(self, "modulate", Color(1, 1, 1, 1.0), 0.12) # Volta ao normal
	
	await tween.finished
	
	invencivel = false

func morrer():
	pode_mexer = false
	velocity = Vector2.ZERO
	$naveDead.play()

	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 0.5)
	
	await $naveDead.finished
	morri.emit() #emite o sinal de morte para que o gerenciador de cenas faça o restio
	
func _physics_process(delta: float) -> void:
	if desapareci_broca:
		spriteBroca.visible = false
		
	if not pode_mexer:
		return
	
	if invencivel: 
		$NaveCorpo/flip2.monitoring = false
		$NaveCorpo/flip1.monitoring = false
		$NaveCorpo/Broca.monitoring = false
	else:
		$NaveCorpo/flip2.monitoring = true
		$NaveCorpo/flip1.monitoring = true
		$NaveCorpo/Broca.monitoring = true
		
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
		
	tremer_motor()
	move_and_slide()
	
func tremer_motor():
	if tremendo:
		return
	tremendo = true
	
	var sprite_nave = $NaveCorpo
	
	var tween = get_tree().create_tween()
	
	for i in range(4):
		var offset_aleatorio = Vector2(
			randf_range(-intensidade_shake, intensidade_shake),
			randf_range(-intensidade_shake, intensidade_shake)
		)
		
		tween.tween_property(sprite_nave, "position", offset_aleatorio, velocidade_shake)
	
	tween.tween_property(sprite_nave, "position", Vector2.ZERO, velocidade_shake)
	
	await tween.finished
	tremendo = false

#ANIMAÇÂO CURVA
func animacaoCurva(direcao_x: float, delta: float):
	var direcao_alvo =direcao_x
	direcao_atual = lerp(direcao_atual, direcao_alvo, 5.0 * delta)
	$NaveCorpo/Nave.flip_h = direcao_atual < 0
	
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
	
	
func _on_flip_2_body_entered(body: Node2D) -> void:
	print_debug("colidi")
	if contador_flip %2 == 0 and body.is_in_group("Minerios"):
		#vou fazer assim por enquanto
		body.queue_free()
		quant_minerios_coletados += 1
		label_quant_minerio.text = str(quant_minerios_coletados)
		#coletou_minerio()
		pass
	elif body.is_in_group("Vento"):
		return
	elif body.is_in_group("projetilInimigo"):
		receber_dano()
		body.queue_free()
		
func _on_flip_2_area_entered(area: Area2D) -> void:
	print_debug("colidi")
	if contador_flip %2 == 0 and area.is_in_group("Minerios"):
		#vou fazer assim por enquanto
		area.queue_free()
		quant_minerios_coletados += 1
		label_quant_minerio.text = str(quant_minerios_coletados)
		#coletou_minerio()
		pass
	elif area.is_in_group("Vento"):
		return
	elif area.is_in_group("projetilInimigo"):
		receber_dano()
		area.queue_free()

func _on_flip_1_body_entered(body: Node2D) -> void:
	print_debug("colidi")
	if contador_flip %2 != 0 and body.is_in_group("Minerios"):
		body.queue_free()
		quant_minerios_coletados += 1
		label_quant_minerio.text = str(quant_minerios_coletados)
		#coletou_minerio()
		pass
	elif body.is_in_group("Vento"):
		return
	elif body.is_in_group("projetilInimigo"):
		receber_dano()
		body.queue_free()

func _on_flip_1_area_entered(area: Area2D) -> void:
	print_debug("colidi")
	if contador_flip %2 != 0 and area.is_in_group("Minerios"):
		area.queue_free()
		quant_minerios_coletados += 1
		label_quant_minerio.text = str(quant_minerios_coletados)
		#coletou_minerio()
		pass
	elif area.is_in_group("Vento"):
		return
	elif area.is_in_group("projetilInimigo"):
		receber_dano()
		area.queue_free()
	pass # Replace with function body.


func _on_broca_area_entered(area: Area2D) -> void:
	print_debug("colidi")
	if area.is_in_group("asteroid"):
		area.queue_free()
	elif area.is_in_group("projetilInimigo"):
		receber_dano()
		area.queue_free()
