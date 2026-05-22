extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var shoot_l: Marker2D = $shoot_l
@onready var shoot_r: Marker2D = $shoot_r

var contador_flip :=0
var shoot = preload("res://shoot.tscn")
var vida := 5

func receber_dano():
	vida -= 1
	var tween = get_tree().create_tween()
	tween.tween_property(self,"modulate", Color.RED,0.5)
	tween.tween_property(self,"modulate", Color.WHITE,0.5)
	await get_tree().create_timer(2.0).timeout
	if vida == 0:
		queue_free()
	
func _ready() -> void:
	add_to_group("jogador")
func _physics_process(delta: float) -> void:
	
	var direction_x := Input.get_axis("ui_left", "ui_right")
	var direction_y := Input.get_axis("ui_up", "ui_down")
	
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
		print(contador_flip)
	
	if Input.is_action_just_pressed("atack"):
		var new_shoot =  shoot.instantiate()
		if contador_flip % 2 == 0:
			new_shoot.global_position = shoot_r.global_position
		else:
			new_shoot.global_position = shoot_l.global_position
		get_tree().root.add_child(new_shoot)
	move_and_slide()


func _on_broca_body_entered(body: Node2D) -> void:
	#sinal emite morte do objeto q entrou na area
	queue_free()
