extends CanvasLayer

@export var hover: Sprite2D
var efeitoStream: AudioStreamPlayer2D
var trilhaStream: AudioStreamPlayer2D

@export var gerenciadorCena: GerenciadorCenas
@export var barra_som: TextureProgressBar
@export var barra_musica: TextureProgressBar

var sons: Dictionary = {
	"selecionar": "res://Assets/Sons/Efeitos interface/Selecionar_ilovemp4.mp3",
	"confirmar": "res://Assets/Sons/Efeitos interface/Confirmar_ilovemp4.mp3",
	"voltar": "res://Assets/Sons/Efeitos interface/Voltar_ilovemp4.mp3",
}

# 0 = Som
# 1 = Música
# 2 = Discord
# 3 = GitHub
# 4 = Instagram
# 5 = Itch.io

var indice_atual: int = 0
var itens_selecao: Array = []

func _ready() -> void:
	await get_tree().process_frame
	efeitoStream = gerenciadorCena.efeitoStream
	trilhaStream = gerenciadorCena.trilhaStream
	itens_selecao = [
		$Som,
		$Musica,
		$Icones/Discord,
		$Icones/GitHub,
		$Icones/Instagram,
		$Icones/Itch_io
	]

	# Configuração das barras
	barra_som.min_value = 0
	barra_som.max_value = 10
	barra_som.step = 1
	barra_som.value = 10

	barra_musica.min_value = 0
	barra_musica.max_value = 10
	barra_musica.step = 1
	barra_musica.value = 10

	desenha_hover(indice_atual)
	
	definir_volume("Efeitos sonoros", 1.0)
	definir_volume("Música", 1.0)


func _process(_delta: float) -> void:
	escolhe_opcao()


func tocar_som(nome_do_som: String) -> void:

	if efeitoStream == null:
		return

	efeitoStream.stream = load(sons[nome_do_som])
	efeitoStream.play()


func escolhe_opcao() -> void:

	# CONTROLE DO VOLUME SOM
	if indice_atual == 0:

		if Input.is_action_just_pressed("ui_right"):
			barra_som.value = min(barra_som.value + 1, 10)

			definir_volume(
				"Efeitos sonoros",
				barra_som.value / 10.0
			)

		elif Input.is_action_just_pressed("ui_left"):
			barra_som.value = max(barra_som.value - 1, 0)

			definir_volume(
				"Efeitos sonoros",
				barra_som.value / 10.0
			)

	# CONTROLE DA MÚSICA
	elif indice_atual == 1:

		if Input.is_action_just_pressed("ui_right"):
			barra_musica.value = min(barra_musica.value + 1, 10)

			definir_volume(
				"Música",
				barra_musica.value / 10.0
			)

		elif Input.is_action_just_pressed("ui_left"):
			barra_musica.value = max(barra_musica.value - 1, 0)

			definir_volume(
				"Música",
				barra_musica.value / 10.0
			)

	# NAVEGAÇÃO VERTICAL
	if Input.is_action_just_pressed("ui_down"):

		tocar_som("selecionar")

		match indice_atual:
			0:
				indice_atual = 1
			1:
				indice_atual = 2

		desenha_hover(indice_atual)

	elif Input.is_action_just_pressed("ui_up"):

		tocar_som("selecionar")

		match indice_atual:
			1:
				indice_atual = 0
			2, 3, 4, 5:
				indice_atual = 1

		desenha_hover(indice_atual)

	# NAVEGAÇÃO DOS ÍCONES
	if indice_atual >= 2:

		if Input.is_action_just_pressed("ui_right"):

			if indice_atual < 5:

				tocar_som("selecionar")

				indice_atual += 1

				desenha_hover(indice_atual)

		elif Input.is_action_just_pressed("ui_left"):

			if indice_atual > 2:

				tocar_som("selecionar")

				indice_atual -= 1

				desenha_hover(indice_atual)

	# CONFIRMAR
	if Input.is_action_just_pressed("ui_accept"):
		seleciona_opcao()
	


func desenha_hover(idx: int) -> void:

	var alvo = itens_selecao[idx]

	hover.global_position = Vector2(
		alvo.global_position.x - 3,
		alvo.global_position.y
	)


func definir_volume(bus_nome: String, valor: float) -> void:

	var indice_bus = AudioServer.get_bus_index(bus_nome)

	if indice_bus == -1:
		return

	if valor <= 0:
		AudioServer.set_bus_volume_db(indice_bus, -80)
	else:
		AudioServer.set_bus_volume_db(
			indice_bus,
			linear_to_db(valor)
		)


func seleciona_opcao() -> void:

	tocar_som("confirmar")

	match indice_atual:

		0:
			print("Som")

		1:
			print("Música")

		2:
			OS.shell_open("Discord")

		3:
			OS.shell_open("github")

		4:
			OS.shell_open("instagram")

		5:
			OS.shell_open("https://www.youtube.com/watch?v=QmpXxMto50k")
