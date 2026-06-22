extends Node2D

var animInimigos: AnimationPlayer
var anim: AnimatedSprite2D
var boss: BossBasico
var nave: Nave
var gerenciador_cenas: GerenciadorCenas

var lista_dialogos:= ["DMRC1"]

func _ready() -> void:
	await get_tree().process_frame
	
	nave = $Nave
	boss = Global.BossAtual
	anim = boss.anim
	animInimigos = $animInimigos
	gerenciador_cenas = $GerenciadorCena
	
	nave.pode_mexer = false
	
	await get_tree().create_timer(2).timeout
	
	animInimigos.play("inimigos_passam")
	await animInimigos.animation_finished
	
	anim.play("descendo")
	await anim.animation_finished
	
	DialogueManager.start_dialogue_id(lista_dialogos[0])
	await DialogueManager.dialogue_finished
	
	anim.play("subindo")
	await anim.animation_finished
	
	boss.mudar_estado(boss.Estados.CutScene)
	
	nave.pode_mexer = true
