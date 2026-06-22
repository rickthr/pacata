extends Node

const DialogueDatabase := preload("res://Scripts/Dialogo/DialogueDatabase.gd")

signal dialogue_started(dialogue_id: String)
signal dialogue_finished(dialogue_id: String)
signal dialogue_line_changed(line_data: Dictionary)

signal popup_sequence_requested(messages: Array[String], duration_per_message: float)
signal popup_requested(message: String, duration: float)

const DEFAULT_POPUP_DURATION_PER_MESSAGE: float = 3.0
const POPUP_CHAIN_INTERVAL: float = 1.0

var dialogue_lines: Array[Dictionary] = []
var current_line_index: int = 0
var current_dialogue_id: String = ""
var is_dialogue_active: bool = false
var is_transition_locked: bool = false
var dialogo_acabou:bool = false


func start_dialogue_id(dialogue_id: String) -> void:
	dialogo_acabou = false
	var lines := DialogueDatabase.get_dialogue(dialogue_id)
	start_dialogue(lines, dialogue_id)


func start_dialogue(lines: Array[Dictionary], dialogue_id: String = "") -> void:
	if lines.is_empty():
		push_warning("DialogueManager: tentativa de iniciar diálogo vazio: " + dialogue_id)
		return
	
	if is_dialogue_active:
		push_warning("DialogueManager: já existe um diálogo ativo.")
		return
	
	dialogue_lines = []
	
	for line in lines:
		dialogue_lines.append(line.duplicate())
	
	current_line_index = 0
	current_dialogue_id = dialogue_id
	is_dialogue_active = true
	is_transition_locked = false
	
	dialogue_started.emit(current_dialogue_id)
	_emit_current_line()


func advance_dialogue() -> void:
	if not is_dialogue_active:
		return
	
	if is_transition_locked:
		return
	
	is_transition_locked = true
	
	if _should_play_popup_after_current_line(current_dialogue_id, current_line_index):
		await _play_popup_id_and_wait("PPAP", DEFAULT_POPUP_DURATION_PER_MESSAGE)
	
	current_line_index += 1
	
	if current_line_index >= dialogue_lines.size():
		is_transition_locked = false
		end_dialogue()
		return
	
	is_transition_locked = false
	_emit_current_line()


func end_dialogue() -> void:
	if not is_dialogue_active:
		return
	
	var finished_dialogue_id := current_dialogue_id
	
	dialogue_lines.clear()
	current_line_index = 0
	current_dialogue_id = ""
	is_dialogue_active = false
	is_transition_locked = false
	
	dialogue_finished.emit(finished_dialogue_id)
	
	await _process_dialogue_finished_triggers(finished_dialogue_id)
	dialogo_acabou = true


func show_popup_id(popup_id: String, duration_per_message: float = DEFAULT_POPUP_DURATION_PER_MESSAGE) -> void:
	var messages := DialogueDatabase.get_popup_sequence(popup_id)
	
	if messages.is_empty():
		return
	
	popup_sequence_requested.emit(messages, duration_per_message)


func show_popup_text(message: String, duration: float = DEFAULT_POPUP_DURATION_PER_MESSAGE) -> void:
	if message.strip_edges().is_empty():
		return
	
	popup_requested.emit(message, duration)


func _emit_current_line() -> void:
	if current_line_index < 0 or current_line_index >= dialogue_lines.size():
		end_dialogue()
		return
	
	var current_line: Dictionary = dialogue_lines[current_line_index]
	dialogue_line_changed.emit(current_line)


func _should_play_popup_after_current_line(dialogue_id: String, line_index: int) -> bool:
	# DPai1:
	# linha 0 = Pai: "Onde você pensa que vai?"
	# Quando essa primeira fala for avançada, PPAP aparece antes da próxima fala.
	return dialogue_id == "DPai1" and line_index == 0


func _process_dialogue_finished_triggers(dialogue_id: String) -> void:
	match dialogue_id:
		"DUAI2":
			await _play_popup_id_and_wait("PPRP1", DEFAULT_POPUP_DURATION_PER_MESSAGE)
		
		"DMRC2":
			await _play_popup_id_and_wait("PPMRC1", DEFAULT_POPUP_DURATION_PER_MESSAGE)
			await get_tree().create_timer(POPUP_CHAIN_INTERVAL).timeout
			await _play_popup_id_and_wait("PPMRC2", DEFAULT_POPUP_DURATION_PER_MESSAGE)

func _play_popup_id_and_wait(popup_id: String, duration_per_message: float) -> void:
	var messages := DialogueDatabase.get_popup_sequence(popup_id)
	
	if messages.is_empty():
		return
	
	popup_sequence_requested.emit(messages, duration_per_message)
	
	var total_duration := float(messages.size()) * duration_per_message
	
	if total_duration > 0.0:
		await get_tree().create_timer(total_duration).timeout
