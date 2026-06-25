extends Node2D

var lista_dialogos := ["DUAI1", "DUAI2"]
var lista_pp := ["PPUAIT1", "PPUAIT2", "PPUAIT3"]
var popup_duration_per_message := 4.0
var nave: Nave
var gerenciador_cenas: GerenciadorCenas
var pode_avancar:= true

enum Estados {
AguardandoAcao,
MostrandoDialogoPP,
TutorialFinalizado
}

enum PassosTutorial {
Navegar,
Atirar,
Flipar
}

var tutorial_atual: PassosTutorial = PassosTutorial.Navegar
var estado_atual: Estados = Estados.MostrandoDialogoPP
var indice_dialogo: int = 0
var indice_pp: int = 0


func _ready() -> void:
	await get_tree().process_frame
	nave = Global.Jogador
	nave.pode_mexer = false
	gerenciador_cenas = $GerenciadorCena
	await get_tree().create_timer(3.5).timeout
	muda_estado(Estados.MostrandoDialogoPP)


func muda_estado(novo_estado: Estados) -> void:
	estado_atual = novo_estado
	gerencia_estados()

func muda_tutorial(novo_tutorial: PassosTutorial) -> void:
	tutorial_atual = novo_tutorial
	print_debug(tutorial_atual)

func gerencia_estados() -> void:
	match estado_atual:
		Estados.MostrandoDialogoPP:
			await mostrar_dialogo_e_popup()
			muda_estado(Estados.AguardandoAcao)
	
		Estados.AguardandoAcao:
			nave.pode_mexer = true
		
		Estados.TutorialFinalizado:
			DialogueManager.start_dialogue_id(lista_dialogos[1])
			await DialogueManager.dialogue_finished
			gerenciador_cenas.passarCena.emit(gerenciador_cenas.Cenas.PlanetaCurupolar)
			pass


func mostrar_dialogo_e_popup() -> void:
	nave.pode_mexer = false

	if indice_dialogo < lista_dialogos.size() - 1 : #-1 para que ele rode apenas o primeiro dialogo, sendo o proximo dialogo a rodar só no final
		DialogueManager.start_dialogue_id(lista_dialogos[indice_dialogo])
		await DialogueManager.dialogue_finished
		indice_dialogo += 1

	if indice_pp < lista_pp.size():
		DialogueManager.show_popup_id(lista_pp[indice_pp], popup_duration_per_message)
		await get_tree().create_timer(popup_duration_per_message).timeout
		indice_pp += 1


func _process(delta: float) -> void:
	if estado_atual != Estados.AguardandoAcao or not pode_avancar:
		return

	match tutorial_atual:
		PassosTutorial.Navegar:
			if Input.get_axis("ui_left", "ui_right") != 0 or Input.get_axis("ui_up", "ui_down") != 0:
				avancar_passo()
		PassosTutorial.Atirar:
			if Input.is_action_just_pressed("atack"):
				print_debug("atirando")
				avancar_passo()
		PassosTutorial.Flipar:
			if Input.is_action_just_pressed("flip"):
				print_debug("flipando")
				avancar_passo()

func avancar_passo() -> void:
	pode_avancar = false
	
	await get_tree().create_timer(2).timeout
	match tutorial_atual:
		PassosTutorial.Navegar:
			muda_tutorial(PassosTutorial.Atirar)
		PassosTutorial.Atirar:
			muda_tutorial(PassosTutorial.Flipar)
		PassosTutorial.Flipar:
			muda_estado(Estados.TutorialFinalizado)
			return

	muda_estado(Estados.MostrandoDialogoPP)
	pode_avancar = true
