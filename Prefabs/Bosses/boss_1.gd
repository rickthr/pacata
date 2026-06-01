extends BossBasico

@export var pos_instancia_tiro_maior: Array[Marker2D]
@export var pos_instancia_tiro_menor: Array[Marker2D]
@export var aviso_tiro_maior: PackedScene

var inimigos_desapareceram: int
	
func faseDano():
	timerTiroMaior.start()
	timerTiroMenor.start()
	comportamento_por_fase()
	"""
	fazer o tiro menor
	avisar do tiro maior
		tiro maior
	a depender da fase, 
		atirar mais rapido 
		instanciar inimigos
	"""
	pass
	
func avisa_tiro_maior():
	"""
	cria a linha de aviso e pisca ela tres vezes antes de atirar
	"""
	var aviso = aviso_tiro_maior.instantiate()
	get_tree().current_scene.add_child(aviso)
	
	for i in 3:
		aviso.visible = true
		await get_tree().create_timer(0.3).timeout
		aviso.visible = false
		await get_tree().create_timer(0.3).timeout
		
	aviso.queue_free()
	tiro_maior()
	pass

func tiro_maior():
	"""
	seleciona um dos instanciadores maiores
	atira
	retira o instanciador maior escolhido da lista
	"""
	var l_instanciador = pos_instancia_tiro_maior
	
	for i in range(len(l_instanciador)):
		var instanciador = l_instanciador.pick_random()
		var projetil = projetil_maior.instantiate()
		get_tree().current_scene.add_child(projetil)
		projetil.global_position = instanciador.global_position
		l_instanciador.erase(instanciador)
	pass
	
func tiro_menor():
	var l_instanciador = pos_instancia_tiro_menor
	for instanciador in l_instanciador:
		var projetil = projetil_menor.instantiate()
		get_tree().current_scene.add_child(projetil)
		projetil.global_position = instanciador.global_position
		l_instanciador.erase(instanciador)
		projetil.direcao = Vector2.DOWN

func comportamento_por_fase():
	var inimigos: Array
	match  faseAtual:
		1:
			for inimigo in get_tree().get_nodes_in_group("inimigo"):
				inimigo.multiplicadorPFase = 1
				inimigos.append(inimigo) 
				inimigos[inimigo].desapareci.connect(_on_inimigo_desapareceu.bind(inimigo))
			pass
		2:
			for inimigo in get_tree().get_nodes_in_group("inimigo"):
				inimigo.multiplicadorPFase = 1.5
				timerTiroMenor.wait_time /= 2
				emit_signal("chamar_instanciar")
			pass
		3:
			for inimigo in get_tree().get_nodes_in_group("inimigo"):
				inimigo.multiplicadorPFase = 2
				timerTiroMenor.wait_time /= 3
				emit_signal("chamar_instanciar")
			pass
	"""
	diminuir o timer por tiro
	a partir de certa fase, instanciar inimigos
	"""
	pass
	
func _on_inimigo_desapareceu(inimigo: Node2D) -> void:
	inimigos_desapareceram += 1
	inimigo.queue_free()
	if inimigos_desapareceram >=3: 
		emit_signal("fechar_instanciar")
		inimigos_desapareceram = 0

func _on_timer_atirar_timeout() -> void:
	tiro_menor()
	pass # Replace with function body.

func _on_tiro_maior_timeout() -> void:
	avisa_tiro_maior()
	pass # Replace with function body.
