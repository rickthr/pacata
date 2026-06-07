extends Node

@export_enum("INTRO1", "DPai1", "DUAI1", "DUAI2", "DMRC1", "DMRC2", "DPAI2")
var test_dialogue_id: String = "DPai1"

@export_enum("PPAP", "PPRP1", "PPMRC1", "PPMRC2")
var test_popup_id: String = "PPAP"

@export var popup_duration_per_message: float = 3.0


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		if not DialogueManager.is_dialogue_active:
			print("Testando diálogo: ", test_dialogue_id)
			DialogueManager.start_dialogue_id(test_dialogue_id)
	
	if Input.is_action_just_pressed("popup_test"):
		print("Testando popup: ", test_popup_id)
		DialogueManager.show_popup_id(test_popup_id, popup_duration_per_message)
