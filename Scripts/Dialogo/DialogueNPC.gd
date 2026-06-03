extends Node

@export var dialogue_id: String = "DPai1"
@export_multiline var dialogue_text: String = ""


func play_dialogue() -> void:
	var lines := get_dialogue_lines()
	
	if lines.is_empty():
		push_warning("DialogueNPC: diálogo vazio em " + dialogue_id)
		return
	
	DialogueManager.start_dialogue(lines)


func get_dialogue_lines() -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	
	for raw_line in dialogue_text.split("\n", false):
		var line := raw_line.strip_edges()
		
		if line.is_empty():
			continue
		
		var parts := line.split("|", false, 1)
		
		if parts.size() == 2:
			result.append({
				"speaker": parts[0].strip_edges(),
				"text": parts[1].strip_edges()
			})
		else:
			result.append({
				"speaker": "",
				"text": line
			})
	
	return result
