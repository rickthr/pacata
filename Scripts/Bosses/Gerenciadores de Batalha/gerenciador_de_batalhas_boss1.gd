extends GerenciadorBatalhas

func instanciaInimigoA(inimigoCena: PackedScene, inimigoDados: DatabaseInimigos) -> void:
	_spawnar(inimigoCena, inimigoDados)

func instanciaInimigoB(inimigoCena: PackedScene, inimigoDados: DatabaseInimigos) -> void:
	_spawnar(inimigoCena, inimigoDados)

func instanciaInimigoC(inimigoCena: PackedScene, inimigoDados: DatabaseInimigos) -> void:
	_spawnar(inimigoCena, inimigoDados)
	
func _on_instanciar(): #instanciar somente para fases em que o boss instancia fora da fase de instanciamento
	pare_instanciar_PF = false
	randomizaInimigos()
	pass
	
func _on_encerra_instanciar():# para o intanciar somente para fases em que o boss instancia fora da fase de instanciamento
	pare_instanciar_PF = true
	pass
	
@warning_ignore("unused_parameter")
func _spawnar(inimigoCena: PackedScene, inimigoDados: DatabaseInimigos) -> void:
	
	if quantHordasNaTela >= maxQuantHordasNaTela:
		return
	
	await get_tree().create_timer(1).timeout
	
	if boss.estado_atual == BossBasico.Estados.FaseDano and pare_instanciar_PF:
		return
		
	await get_tree().create_timer(1).timeout
	
	var cenaInimigo = inimigoCena.instantiate()
	add_child(cenaInimigo)
	
	var inimigos = cenaInimigo.find_children("*", "CharacterBody2D", true, false)
	if inimigos.size() > 0:
		inimigos[0].desapareci.connect(_on_inimigo_desapareceu.bind(cenaInimigo))
		quantHordasNaTela += 1
	quantInimigosAInstanciar -= 1
