extends CanvasLayer

@onready var panel: Panel = $Panel
@onready var box_background: TextureRect = $Panel/BoxBackground
@onready var name_background: TextureRect = $Panel/NameBackground
@onready var speaker_portrait: TextureRect = $Panel/SpeakerPortrait
@onready var name_label: Label = $Panel/NameLabel
@onready var dialogue_text: RichTextLabel = $Panel/DialogueText

@export var typing_speed: float = 0.03

@export_group("Caixa do nome")
@export var default_name_box: Texture2D

@export_group("Caixas de diálogo personagem")
@export var default_box: Texture2D
@export var diggy_box: Texture2D
@export var pai_box: Texture2D
@export var uai_box: Texture2D
@export var chefe_box: Texture2D
@export var capanga_1_box: Texture2D
@export var capanga_2_box: Texture2D

@export_group("icone por personagem")
@export var default_portrait: Texture2D
@export var diggy_portrait: Texture2D
@export var pai_portrait: Texture2D
@export var uai_portrait: Texture2D
@export var chefe_portrait: Texture2D
@export var capanga_1_portrait: Texture2D
@export var capanga_2_portrait: Texture2D

var full_text: String = ""
var current_text: String = ""
var current_char_index: int = 0
var is_typing: bool = false
var typewriter_version: int = 0


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


func _on_dialogue_started(_dialogue_id: String) -> void:
	panel.visible = true


func _on_dialogue_finished(_dialogue_id: String) -> void:
	typewriter_version += 1
	
	panel.visible = false
	
	name_label.text = ""
	dialogue_text.text = ""
	
	box_background.texture = null
	name_background.texture = null
	speaker_portrait.texture = null
	
	full_text = ""
	current_text = ""
	current_char_index = 0
	is_typing = false


func _on_dialogue_line_changed(line_data: Dictionary) -> void:
	typewriter_version += 1
	
	var local_version := typewriter_version
	
	var speaker: String = line_data.get("speaker", "")
	var text: String = line_data.get("text", "")
	
	name_label.text = speaker
	full_text = text
	
	_apply_visuals_by_speaker(speaker)
	
	dialogue_text.text = ""
	current_text = ""
	current_char_index = 0
	is_typing = false
	
	await _type_text(local_version)


func _type_text(local_version: int) -> void:
	is_typing = true
	
	while local_version == typewriter_version and current_char_index < full_text.length():
		current_text += full_text[current_char_index]
		dialogue_text.text = current_text
		current_char_index += 1
		
		await get_tree().create_timer(typing_speed).timeout
	
	if local_version == typewriter_version:
		is_typing = false


func _show_full_text() -> void:
	typewriter_version += 1
	
	dialogue_text.text = full_text
	current_text = full_text
	current_char_index = full_text.length()
	is_typing = false


func _apply_visuals_by_speaker(speaker: String) -> void:
	var selected_box: Texture2D = default_box
	var selected_portrait: Texture2D = default_portrait
	
	match speaker:
		"Diggy":
			if diggy_box != null:
				selected_box = diggy_box
			if diggy_portrait != null:
				selected_portrait = diggy_portrait
		
		"Pai":
			if pai_box != null:
				selected_box = pai_box
			if pai_portrait != null:
				selected_portrait = pai_portrait
		
		"UAI":
			if uai_box != null:
				selected_box = uai_box
			if uai_portrait != null:
				selected_portrait = uai_portrait
		
		"Chefe":
			if chefe_box != null:
				selected_box = chefe_box
			if chefe_portrait != null:
				selected_portrait = chefe_portrait
		
		"Capanga 1":
			if capanga_1_box != null:
				selected_box = capanga_1_box
			if capanga_1_portrait != null:
				selected_portrait = capanga_1_portrait
		
		"Capanga 2":
			if capanga_2_box != null:
				selected_box = capanga_2_box
			if capanga_2_portrait != null:
				selected_portrait = capanga_2_portrait
	
	box_background.texture = selected_box
	name_background.texture = default_name_box
	speaker_portrait.texture = selected_portrait
	
	box_background.visible = selected_box != null
	name_background.visible = default_name_box != null
	speaker_portrait.visible = selected_portrait != null
