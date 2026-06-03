extends CanvasLayer

@onready var panel: Panel = $Panel
@onready var popup_text: Label = $Panel/PopupText

var popup_version: int = 0


func _ready() -> void:
	panel.visible = false
	
	DialogueManager.popup_requested.connect(_on_popup_requested)
	DialogueManager.popup_sequence_requested.connect(_on_popup_sequence_requested)


func _on_popup_requested(message: String, duration: float) -> void:
	popup_version += 1
	var local_version := popup_version
	
	_show_message(message)
	
	await get_tree().create_timer(duration).timeout
	
	if local_version == popup_version:
		_hide_popup()


func _on_popup_sequence_requested(messages: Array[String], duration_per_message: float) -> void:
	popup_version += 1
	var local_version := popup_version
	
	for message in messages:
		if local_version != popup_version:
			return
		
		_show_message(message)
		
		await get_tree().create_timer(duration_per_message).timeout
	
	if local_version == popup_version:
		_hide_popup()


func _show_message(message: String) -> void:
	print("Mostrando popup: ", message)
	
	popup_text.text = message
	panel.visible = true


func _hide_popup() -> void:
	panel.visible = false
	popup_text.text = ""
