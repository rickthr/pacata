extends Node

@export var dialogue_source: NodePath

@onready var dialogue_npc: Node = get_node(dialogue_source)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if dialogue_npc.has_method("play_dialogue"):
			dialogue_npc.play_dialogue()
