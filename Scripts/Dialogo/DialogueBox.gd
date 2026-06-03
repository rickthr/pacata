extends CanvasLayer

@onready var panel: Panel = $Panel
@onready var portrait: TextureRect = $Panel/Portrait
@onready var name_label: Label = $Panel/NameLabel
@onready var dialogue_text: RichTextLabel = $Panel/DialogueText

@export var typing_speed: float = 0.03

var full_text: String = ""
var current_text: String = ""
var current_char_index: int = 0
var is_typing: bool = false


func _ready() -> void:
	panel.visible = false
	
	DialogueManager.dialogue_started.connect(_on_dialogue_started)
	DialogueManager.dialogue_finished.connect(_on_dialogue_finished)
	DialogueManager.dialogue_line_changed.connect(_on_dialogue_line_changed)


func _input(event: InputEvent) -> void:
	if not DialogueManager.is_dialogue_active:
		return
	
	if event.is_action_pressed("dialogue_next"):
		if is_typing:
			_show_full_text()
		else:
			DialogueManager.advance_dialogue()


func _on_dialogue_started() -> void:
	panel.visible = true


func _on_dialogue_finished() -> void:
	panel.visible = false
	dialogue_text.text = ""
	name_label.text = ""
	full_text = ""
	current_text = ""
	current_char_index = 0
	is_typing = false


func _on_dialogue_line_changed(line_data: Dictionary) -> void:
	name_label.text = line_data.get("speaker", "")
	full_text = line_data.get("text", "")
	
	dialogue_text.text = ""
	current_text = ""
	current_char_index = 0
	
	await _type_text()


func _type_text() -> void:
	is_typing = true
	
	while current_char_index < full_text.length():
		current_text += full_text[current_char_index]
		dialogue_text.text = current_text
		current_char_index += 1
		
		await get_tree().create_timer(typing_speed).timeout
	
	is_typing = false


func _show_full_text() -> void:
	dialogue_text.text = full_text
	current_text = full_text
	current_char_index = full_text.length()
	is_typing = false
