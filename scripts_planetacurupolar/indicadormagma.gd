extends Node2D

var tempo_de_aviso: float = 0.8


func configurar(tempo: float):
	tempo_de_aviso = tempo
	iniciar()


func iniciar():
	modulate.a = 0.5
	await get_tree().create_timer(tempo_de_aviso).timeout
	queue_free()
