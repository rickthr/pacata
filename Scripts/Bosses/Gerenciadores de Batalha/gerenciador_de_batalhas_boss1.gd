extends GerenciadorBatalhas

func instanciaInimigoA(inimigoCena: PackedScene, inimigoDados: DatabaseInimigos): 
	print_debug(inimigoCena, inimigoDados)
	randomize()
	var inimigo1 = inimigoCena.instantiate()
	inimigo1.sai_da_tela.connect(_on_inimigo_sai_da_tela)
	inimigo1.morri.connect(_on_inimigo_morri)
	add_child(inimigo1)
	var caminhos = [inimigoDados.caminho1, inimigoDados.caminho2]
	var caminhoEscolhido = caminhos.pick_random()
	caminhos.erase(caminhoEscolhido)
			
	caminhoEscolhido.progress_ratio = randf()
	inimigo1.global_position = caminhoEscolhido.global_position
