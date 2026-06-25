extends Node2D

var animInimigos: AnimationPlayer
var anim: AnimatedSprite2D
var boss: BossBasico
var nave: Nave
var gerenciador_cenas: GerenciadorCenas

var lista_dialogos:= ["DMRC1"]
var lista_dialogos_finais:= ["DMRC2"]

func _ready() -> void:
	await get_tree().process_frame
	
	nave = $Nave
	boss = Global.BossAtual
	anim = boss.anim
	animInimigos = $animInimigos
	gerenciador_cenas = $GerenciadorCena
	
	if boss:
		boss.boss_morreu.connect(_on_boss_morreu)
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
	
func _on_boss_morreu() -> void:
	if is_instance_valid(nave):
		nave.pode_mexer = false
	
	await get_tree().create_timer(1.5).timeout
	
	DialogueManager.start_dialogue_id(lista_dialogos_finais[0])
	await DialogueManager.dialogue_finished
