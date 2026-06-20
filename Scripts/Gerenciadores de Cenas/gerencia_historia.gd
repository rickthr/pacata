extends Node2D

var gerenciadorCenas: GerenciadorCenas
var anim: AnimationPlayer

func _ready() -> void:
	gerenciadorCenas = Global.GerenciadorCenas
	anim = $AnimationPlayer
	anim.play("subindo_texto")
	await anim.animation_finished
	gerenciadorCenas.passarCena.emit(gerenciadorCenas.Cenas.PlanetaGaragem)
