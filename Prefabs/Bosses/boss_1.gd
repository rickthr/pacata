extends BossBasico

@export var pos_instancia_tiro_maior: Marker2D
@export var pos_instancia_tiro_menor_s: Array[Marker2D]
@export var pos_instancia_tiro_menor_r: Array[Marker2D]
@export var pos_instancia_tiro_medio: Array[Marker2D]
@export var aviso_tiro_maior: PackedScene

@export var efeitoStream: AudioStreamPlayer2D 

@onready var timer_tiro_maior = $TiroTiroMaior
@onready var timer_tiro_medio = $TimerTiroMedio
@onready var timer_tiro_menor_s = $TimerTiroMenorS
@onready var timer_tiro_menor_r = $TimerTiroMenorR

var inimigos_desapareceram: int

# Armazena os tempos originais para não dividi-los infinitamente
var wait_time_menor_s_base: float
var wait_time_menor_r_base: float
var wait_time_medio_base: float

var pode_atirar_medio := true

@onready var gerenciador: GerenciadorBatalhas 

var sons: Dictionary={
	"tiro": "res://Assets/Sons/tiro inimigoh.mp3",
	"laser_menor": "",
	"laser_maior": "res://Assets/Sons/laser boladao.mp3"
}

func _ready() -> void:
	super._ready() # Garante que o _ready do BossBasico seja executado primeiro
	# Guarda os valores originais configurados no Inspector
	wait_time_menor_s_base = timer_tiro_menor_s.wait_time
	wait_time_menor_r_base = timer_tiro_menor_r.wait_time
	wait_time_medio_base = timer_tiro_medio.wait_time
	inimigos_desapareceram = 0
	anim = $anim
	anim_colisao = $animColisao
	gerenciador = $".."
	gerenciador.pausarBoss.connect(_on_pausar_boss)
	Global.BossAtual = self

func tocar_som(nome_do_som: String):
	# load() carrega o arquivo de áudio a partir do caminho na string
	efeitoStream.stream = load(sons[nome_do_som])
	efeitoStream.play()
	
func faseDano():
	inicializa_atiradores()
	comportamento_por_fase()
	pass
	
func inicializa_atiradores():	
	timer_tiro_maior.start()
	timer_tiro_medio.start()
	timer_tiro_menor_r.start()
	timer_tiro_menor_s.start()

func avisa_tiro_maior():
	"""
	cria a linha de aviso e pisca ela tres vezes antes de atirar
	"""
	var aviso = aviso_tiro_maior.instantiate()
	get_tree().current_scene.add_child(aviso)
	aviso.global_position = pos_instancia_tiro_maior.global_position
	
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
	tocar_som("laser_maior")
	var projetil = projetil_maior.instantiate()
	get_tree().current_scene.add_child(projetil)
	projetil.global_position = pos_instancia_tiro_maior.global_position
	
	#espera a animação do tiro acabar para destruilo
	await get_tree().create_timer(2).timeout#simula
	if is_instance_valid(projetil):
		projetil.queue_free()
	pass
	
func tiro_menor(l_instanciadores: Array[Marker2D], t_projetil: PackedScene):
	
	for instanciador in l_instanciadores:
		var projetil = t_projetil.instantiate()
		get_tree().current_scene.add_child(projetil)
		projetil.global_position = instanciador.global_position

func tiro_medio(): #chek
	pode_atirar_medio = false
	var l_instanciadores = pos_instancia_tiro_medio.duplicate()
	randomize()
	var projetil
	
	while l_instanciadores.size() > 0:
		if estado_atual != Estados.FaseDano:
			break
			
		var indice = randi() % len(l_instanciadores)
		
		projetil = projetil_medio.instantiate()
		get_tree().current_scene.add_child(projetil)
		projetil.global_position = l_instanciadores[indice].global_position
			
		l_instanciadores.erase(l_instanciadores[indice])
		#espera a animação do projetil acabar
			
		await get_tree().create_timer(1).timeout	
		if is_instance_valid(projetil):
			projetil.queue_free()
	
	pode_atirar_medio = true

func comportamento_por_fase():
	var inimigos: Array
	
	# Reseta os timers para o padrão antes de aplicar os buffs da fase atual
	timer_tiro_menor_s.wait_time = wait_time_menor_s_base
	timer_tiro_menor_r.wait_time = wait_time_menor_r_base
	timer_tiro_medio.wait_time = wait_time_medio_base
	
	match  faseAtual:
		1:
			for inimigo in get_tree().get_nodes_in_group("inimigo"):
				inimigo.multiplicadorPFase = 1
				inimigos.append(inimigo) 
				if not inimigo.desapareci.is_connected(_on_inimigo_desapareceu):
					inimigo.desapareci.connect(_on_inimigo_desapareceu.bind(inimigo))
			pass
		2:
			timer_tiro_menor_s.wait_time = wait_time_menor_s_base/2
			timer_tiro_menor_r.wait_time = wait_time_menor_r_base/2
			timer_tiro_medio.wait_time = wait_time_medio_base/2
			pass
		3:
			for inimigo in get_tree().get_nodes_in_group("inimigo"):
				inimigo.multiplicadorPFase = 1.5
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

func _on_timer_tiro_menor_s_timeout() -> void:
	tiro_menor(pos_instancia_tiro_menor_s, projetil_menor_s)
	pass # Replace with function body.


func _on_timer_tiro_menor_r_timeout() -> void:
	tiro_menor(pos_instancia_tiro_menor_r, projetil_menor_r)
	pass # Replace with function body.


func _on_timer_tiro_medio_timeout() -> void:
	if pode_atirar_medio:
		tiro_medio()
	pass # Replace with function body.


func _on_tiro_tiro_maior_timeout() -> void:
	avisa_tiro_maior()
	pass # Replace with function body.

func _on_janela_vulnerabilidade_timeout() -> void:
	super._on_janela_vulnerabilidade_timeout()
	timer_tiro_maior.stop()
	timer_tiro_medio.stop()
	timer_tiro_menor_r.stop()
	timer_tiro_menor_s.stop()
