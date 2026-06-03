extends Node

@export var dialogue_id: String = "DPai1"
extends Node

const DialogueDatabase := preload("res://Scripts/Dialogo/DialogueDatabase.gd")

@export_enum("DPai1", "DUAI1", "DUAI2", "DMRC1", "DMRC2", "DPAI2")
var dialogue_id: String = "DPai1"


func play_dialogue() -> void:
	if DialogueManager.is_dialogue_active:
		return
	
	var dialogue_lines := DialogueDatabase.get_dialogue(dialogue_id)
	DialogueManager.start_dialogue(dialogue_lines)
