extends RefCounted

const DIALOGUES: Dictionary = {
	"DPai1": [
		{"speaker": "Pai", "text": "Onde você pensa que vai?"},
		{"speaker": "Diggy", "text": "Huh… Ia dar uma zolhada na nave."},
		{"speaker": "Pai", "text": "Sabe que não pode mexer nela."},
		{"speaker": "Diggy", "text": "E ela vai ficar aqui, pegando poeira? Ela ainda funciona, pai, eu posso pilotá-lá, como você fazia."},
		{"speaker": "Pai", "text": "Filho… você sabe que esse é um trabalho ingrato, ainda mais em nossas condições–"},
		{"speaker": "Diggy", "text": "Não ligo pra isso, quero ser um Driller, além do mais, estamos precisando do dinheiro."},
		{"speaker": "Pai", "text": "..."},
		{"speaker": "Diggy", "text": "Me deixa fazer isso, pai, me deixa provar que posso ser diferente dos outros."},
		{"speaker": "Pai", "text": "Diferente vc já é, todo errado dos olho aí."},
		{"speaker": "Pai", "text": "Mas, temo que não posso impedi-lo."},
		{"speaker": "Diggy", "text": "Valeu, paizão."},
		{"speaker": "Pai", "text": "Cuidado, filho."}
	],

	"DUAI1": [
		{"speaker": "UAI", "text": "Calculando rota…"},
		{"speaker": "Diggy", "text": "AH!! …Mas que susto!"},
		{"speaker": "UAI", "text": "Você está a duas horas do planeta Curupolar."},
		{"speaker": "UAI", "text": "Deseja que eu faça o relatório planetário, senhor… Você não é o <>."},
		{"speaker": "Diggy", "text": "Esse é o meu pai, eu sou o Diggy, e quem é tú?"},
		{"speaker": "UAI", "text": "Meu código de reconhecimento é UAI, Unidade Ativa de Inteligência, e você está a bordo da DRILLEIRA01, por que você está pilotando?"},
		{"speaker": "Diggy", "text": "Meu pai deu permissão, e eu acho que peguei o jeito HAHA."},
		{"speaker": "UAI", "text": "..."},
		{"speaker": "UAI", "text": "Você está no piloto automático."},
		{"speaker": "Diggy", "text": "Come qu’é?"},
		{"speaker": "UAI", "text": "Deseja que eu desative o piloto automático?"},
		{"speaker": "Diggy", "text": "Ora se não, manda ver."},
		{"speaker": "UAI", "text": "Desligando piloto automático."}
	],

	"DUAI2": [
		{"speaker": "UAI", "text": "Vejo que você aprendeu a navegar."},
		{"speaker": "Diggy", "text": "Hehe, ai sim."},
		{"speaker": "UAI", "text": "Deseja o relatório planetário?"},
		{"speaker": "Diggy", "text": "Djabo é isso?"},
		{"speaker": "UAI", "text": "O relatório planetário trata-se de um resumo das diversas características que o planeta alvo apresenta."},
		{"speaker": "Diggy", "text": "Ah… Joga na mesa."}
	],

	"DMRC1": [
		{"speaker": "Chefe", "text": "É UTREN."},
		{"speaker": "Capanga 1", "text": "Vamo passar o pente fino."},
		{"speaker": "Diggy", "text": "Quem são esses?"},
		{"speaker": "UAI", "text": "Mercenários."},
		{"speaker": "Diggy", "text": "Ah."},
		{"speaker": "Chefe", "text": "Ora, ora, o que temos aqui?"},
		{"speaker": "Capanga 2", "text": "Um driller, chefe."},
		{"speaker": "Chefe", "text": "Foi uma pergunta retórica, idiota."},
		{"speaker": "Capanga 1", "text": "Se liga moleque, UTREN tá atropelando e você vai passar os minérios que ‘cê tem aí, valeu."},
		{"speaker": "Chefe", "text": "Kikikik – é UTREN."},
		{"speaker": "Diggy", "text": "Ai, vou entregar nada não, valeu falou."},
		{"speaker": "Chefe", "text": "Certo, certo, beleza, na melhor é nós."},
		{"speaker": "Chefe", "text": "PEGUEM ELE!"}
	],

	"DMRC2": [
		{"speaker": "UAI", "text": "Pelo visto a Drill foi desacoplada."},
		{"speaker": "Diggy", "text": "EH, EU VI… mas que droga."},
		{"speaker": "UAI", "text": "Rastreando parte da nave…"},
		{"speaker": "Diggy", "text": "Isso é possível?"},
		{"speaker": "UAI", "text": "Ela está indo na direção de um planeta distante, chamado <>."},
		{"speaker": "Diggy", "text": "É possível irmos até lá?"},
		{"speaker": "UAI", "text": "Calculando…"},
		{"speaker": "UAI", "text": "Não, no momento, peças mais resistentes são necessárias."},
		{"speaker": "Diggy", "text": "Droga, eu já perdi a Drill e os minérios que consegui mal conseguem pagar uma nova."},
		{"speaker": "UAI", "text": "Chegando em… Planeta Garagem."}
	],

	"DPAI2": [
		{"speaker": "Pai", "text": "Olha só quem voltou, eae filhão, como foi?"},
		{"speaker": "Diggy", "text": "Pai… eu –"},
		{"speaker": "UAI", "text": "A Drill foi perdida."},
		{"speaker": "Pai", "text": "Vejo que conheceu a UAI… Peraí, CÊ DISSE O QUE?!"},
		{"speaker": "Diggy", "text": "Mercenários apareceram, nos atacaram e a Drill foi desacoplada."},
		{"speaker": "Diggy", "text": "Mas eu vou recuperar ela, a UAI tem a localização, eu só preciso de mais minérios."},
		{"speaker": "Pai", "text": "Estou feliz que ainda tenha coragem pra se aventurar mesmo sem a Drill… bom, acho que tenho algo que possa te ajudar."},
		{"speaker": "Pai", "text": "Usei isso na guerra, tem acumulado poeira desde então."},
		{"speaker": "UAI", "text": "UAUU…"},
		{"speaker": "UAI", "text": "É uma <>, uma arma de combate."},
		{"speaker": "Pai", "text": "Mas também pode ser usada pra destruir minérios."},
		{"speaker": "Diggy", "text": "Valeuzão, Pai."},
		{"speaker": "Pai", "text": "Boa sorte, filho, estarei aqui se precisar arrumar a nave e caso não encontre o que precise aqui, dê uma olhada nos pontos comerciais, tenho certeza que vai encontrar o que precisa."}
	]
}


static func get_dialogue(dialogue_id: String) -> Array[Dictionary]:
	if not DIALOGUES.has(dialogue_id):
		push_warning("DialogueDatabase: diálogo não encontrado: " + dialogue_id)
		return []
	
	var result: Array[Dictionary] = []
	
	for line in DIALOGUES[dialogue_id]:
		result.append(line.duplicate())
	
	return result
