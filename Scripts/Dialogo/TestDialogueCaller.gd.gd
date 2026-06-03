extends Node

var test_dialogue: Array[Dictionary] = [
	{
		"speaker": "Pai",
		"text": "Onde você pensa que vai?"
	},
	{
		"speaker": "Diggy",
		"text": "Huh… Ia dar uma zolhada na nave."
	},
	{
		"speaker": "Pai",
		"text": "Sabe que não pode mexer nela."
	},
	{
		"speaker": "Diggy",
		"text": "E ela vai ficar aqui, pegando poeira? Ela ainda funciona, pai, eu posso pilotá-lá, como você fazia."
	},
	{
		"speaker": "Pai",
		"text": "Filho… você sabe que esse é um trabalho ingrato, ainda mais em nossas condições–"
	},
	{
		"speaker": "Diggy",
		"text": "Não ligo pra isso, quero ser um Driller, além do mais, estamos precisando do dinheiro."
	},
	{
		"speaker": "Pai",
		"text": "..."
	},
	{
		"speaker": "Diggy",
		"text": "Me deixa fazer isso, pai, me deixa provar que posso ser diferente dos outros."
	},
	{
		"speaker": "Pai",
		"text": "Diferente vc já é, todo errado dos olho aí."
	},
	{
		"speaker": "Pai",
		"text": "Mas, temo que não posso impedi-lo."
	},
	{
		"speaker": "Diggy",
		"text": "Valeu, paizão."
	},
	{
		"speaker": "Pai",
		"text": "Cuidado, filho."
	}
]


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		DialogueManager.start_dialogue(test_dialogue)
