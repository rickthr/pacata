extends Node

signal dialogue_started
signal dialogue_finished
signal dialogue_line_changed(line_data: Dictionary)

var dialogue_lines: Array[Dictionary] = []
var current_line_index: int = 0
var is_dialogue_active: bool = false


func start_dialogue(lines: Array[Dictionary]) -> void:
	if lines.is_empty():
		push_warning("DialogueManager: tentativa de iniciar diálogo sem falas.")
		return
	
	if is_dialogue_active:
		return
	
	dialogue_lines = lines
	current_line_index = 0
	is_dialogue_active = true
	
	dialogue_started.emit()
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
	
	dialogue_lines.clear()
	current_line_index = 0
	is_dialogue_active = false
	
	dialogue_finished.emit()


func _emit_current_line() -> void:
	if current_line_index < 0 or current_line_index >= dialogue_lines.size():
		end_dialogue()
		return
	
	var current_line: Dictionary = dialogue_lines[current_line_index]
	dialogue_line_changed.emit(current_line)
