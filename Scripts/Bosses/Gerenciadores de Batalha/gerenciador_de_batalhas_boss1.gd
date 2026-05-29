extends GerenciadorBatalhas

func instanciaInimigoA(inimigoCena: PackedScene, inimigoDados: DatabaseInimigos) -> void:
	_spawnar(inimigoCena, inimigoDados)

func instanciaInimigoB(inimigoCena: PackedScene, inimigoDados: DatabaseInimigos) -> void:
	_spawnar(inimigoCena, inimigoDados)

func instanciaInimigoC(inimigoCena: PackedScene, inimigoDados: DatabaseInimigos) -> void:
	_spawnar(inimigoCena, inimigoDados)

func _spawnar(inimigoCena: PackedScene, inimigoDados: DatabaseInimigos) -> void:
	posInstanciar = $SpawnPointInimigo	
	var cenaInimigo = inimigoCena.instantiate()
	add_child(cenaInimigo)
	
	var inimigos = cenaInimigo.find_children("*", "CharacterBody2D", true, false)
	print_debug(inimigos)
	for inimigo in inimigos:
		print_debug("tem sai_da_tela: ", inimigo.has_signal("sai_da_tela"))
		print_debug("tem morri: ", inimigo.has_signal("morri"))
		if inimigo.has_signal("sai_da_tela"):
			inimigo.sai_da_tela.connect(_on_inimigo_sai_da_tela)
			if inimigo.has_signal("morri"):
				inimigo.morri.connect(_on_inimigo_morri)
		quantInimigosInstanciados += 1
		
#func _spawnar(inimigoCena: PackedScene, inimigoDados: DatabaseInimigos, caminhos: Array) -> void:
	#for i in inimigoDados.valor_quant_spawn:
		#var caminho = caminhos.pick_random()
		#caminhos.erase(caminho)
		#caminho.progress_ratio = randf()  # 1. define posição no path
		#
		#var inimigo = inimigoCena.instantiate()
		#inimigo.sai_da_tela.connect(_on_inimigo_sai_da_tela)
		#inimigo.morri.connect(_on_inimigo_morri)
		#get_parent().add_child(inimigo)  # 2. adiciona na cena
		#inimigo.global_position = caminho.global_position  # 3. lê posição depois
		#quantInimigosInstanciados += 1
