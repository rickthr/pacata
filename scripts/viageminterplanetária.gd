extends Node2D

@onready var efeito_viagem: AnimatedSprite2D = $EfeitoViagem
@onready var label_status: Label = $UI/LabelStatus
@onready var timer_viagem: Timer = $TimerViagem


func _ready():
	configurar_cena()
	salvar_database_da_nave()
	iniciar_efeito_visual()
	iniciar_timer_de_viagem()


func configurar_cena():
	label_status.text = "Preparando viagem..."
	timer_viagem.wait_time = 3.0
	timer_viagem.one_shot = true
	timer_viagem.timeout.connect(_on_timer_viagem_timeout)


func salvar_database_da_nave():
	label_status.text = "Salvando dados da nave..."
	NaveDataBase.ultimo_planeta_visitado = NaveDataBase.planeta_atual
	NaveDataBase.planeta_atual = TravelManager.proximo_planeta
	NaveDataBase.salvar_database()


func iniciar_efeito_visual():
	label_status.text = "Viajando..."
	efeito_viagem.play("viagem")


func iniciar_timer_de_viagem():
	timer_viagem.start()


func _on_timer_viagem_timeout():
	carregar_proxima_cena()


func carregar_proxima_cena():
	if TravelManager.proxima_cena == "":
		get_tree().change_scene_to_file("res://scenes/HubInicial.tscn")
		return

	var cena_destino = TravelManager.proxima_cena
	TravelManager.limpar_viagem()

	get_tree().change_scene_to_file(cena_destino)
