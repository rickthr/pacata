extends Node

@export_enum("INTRO1", "DPai1", "DUAI1", "DUAI2", "DMRC1", "DMRC2", "DPAI2")
var dialogue_id: String = "DPai1"

@export var play_on_ready: bool = false
@export var delay_before_playing: float = 0.0


func _ready() -> void:
	if play_on_ready:
		if delay_before_playing > 0.0:
			await get_tree().create_timer(delay_before_playing).timeout
		
		play_dialogue()


func play_dialogue() -> void:
	if DialogueManager.is_dialogue_active:
		return
	
	DialogueManager.start_dialogue_id(dialogue_id)
