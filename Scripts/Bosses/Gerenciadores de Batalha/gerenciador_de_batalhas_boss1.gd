extends GerenciadorBatalhas

@onready var caminho_v1 = $"../Path2DV1/PathFollow2D"
@onready var caminho_v2 = $"../Path2DV2/PathFollow2D"
@onready var caminho_h1 = $"../Path2DH1/PathFollow2D"
@onready var caminho_h2 = $"../Path2DH2/PathFollow2D"

func instanciaInimigoA(inimigoCena: PackedScene, inimigoDados: DatabaseInimigos) -> void:
	_spawnar(inimigoCena, inimigoDados, [caminho_h1, caminho_h2])

func instanciaInimigoB(inimigoCena: PackedScene, inimigoDados: DatabaseInimigos) -> void:
	_spawnar(inimigoCena, inimigoDados, [caminho_v1, caminho_v2])

func instanciaInimigoC(inimigoCena: PackedScene, inimigoDados: DatabaseInimigos) -> void:
	_spawnar(inimigoCena, inimigoDados, [caminho_v1, caminho_v2])

func _spawnar(inimigoCena: PackedScene, inimigoDados: DatabaseInimigos, caminhos: Array) -> void:
	for i in inimigoDados.valor_quant_spawn:
		var caminho = caminhos.pick_random()
		caminhos.erase(caminho)
		caminho.progress_ratio = randf()
		
		var inimigo = inimigoCena.instantiate()
		inimigo.dadosTipoInimigo = inimigoDados  # seta antes do add_child
		inimigo.sai_da_tela.connect(_on_inimigo_sai_da_tela)
		inimigo.morri.connect(_on_inimigo_morri)
		inimigo.global_position = caminho.global_position
		add_child(inimigo)
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
