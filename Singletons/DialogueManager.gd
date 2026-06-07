extends Node

const DialogueDatabase := preload("res://Scripts/Dialogo/DialogueDatabase.gd")

signal dialogue_started(dialogue_id: String)
signal dialogue_finished(dialogue_id: String)
signal dialogue_line_changed(line_data: Dictionary)

signal popup_sequence_requested(messages: Array[String], duration_per_message: float)
signal popup_requested(message: String, duration: float)

var dialogue_lines: Array[Dictionary] = []
var current_line_index: int = 0
var current_dialogue_id: String = ""
var is_dialogue_active: bool = false


func start_dialogue_id(dialogue_id: String) -> void:
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
	
	dialogue_started.emit(current_dialogue_id)
	_emit_current_line()


func advance_dialogue() -> void:
	if not is_dialogue_active:
		return
	
	current_line_index += 1
	
	if current_line_index >= dialogue_lines.size():
		end_dialogue()
		return
	
	_emit_current_line()


func end_dialogue() -> void:
	if not is_dialogue_active:
		return
	
	var finished_dialogue_id := current_dialogue_id
	
	dialogue_lines.clear()
	current_line_index = 0
	current_dialogue_id = ""
	is_dialogue_active = false
	
	dialogue_finished.emit(finished_dialogue_id)


func show_popup_id(popup_id: String, duration_per_message: float = 3.0) -> void:
	var messages := DialogueDatabase.get_popup_sequence(popup_id)
	
	if messages.is_empty():
		return
	
	popup_sequence_requested.emit(messages, duration_per_message)


func show_popup_text(message: String, duration: float = 3.0) -> void:
	if message.strip_edges().is_empty():
		return
	
	popup_requested.emit(message, duration)


func _emit_current_line() -> void:
	if current_line_index < 0 or current_line_index >= dialogue_lines.size():
		end_dialogue()
		return
	
	var current_line: Dictionary = dialogue_lines[current_line_index]
	dialogue_line_changed.emit(current_line)
