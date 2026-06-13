extends Node2D

enum Estados{
	AguardandoAcao,
	MostrandoDialogoPP,
	TutorialFinalizado
}

enum PassosTutorial{
	Navegar,
	Atirar,
	Flipar
}

var tutorial_atual: PassosTutorial = PassosTutorial.Navegar
var estado_atual: Estados = Estados.MostrandoDialogoPP

func muda_estado(novo_estado: Estados):
	estado_atual = novo_estado
	pass
	
func muda_tutorial(novo_tutorial: PassosTutorial):
	tutorial_atual = novo_tutorial
	pass
	
func gerencia_estados():
	match estado_atual:
		Estados.MostrandoDialogoPP:
			#espera alguns segundos
			#verificar se é o id do ultimo dialogo do dicionario pra essa cena
				#mostra o dialogo
				#espera ele acabar
				#dai passa pra muda_estado(Estados.Tutorial finalizado)
			#não deixa a nave se mexer ou atirar
			# se o dialogo ou pp desativou
			muda_estado(Estados.AguardandoAcao)
		Estados.AguardandoAcao:
			match  tutorial_atual:
				PassosTutorial.Navegar:
					# checa se o jogador apertou a tecla correta
					muda_tutorial(PassosTutorial.Atirar) 
					muda_estado(Estados.MostrandoDialogoPP)
				PassosTutorial.Atirar:
					# checa se o jogador apertou a tecla correta
					muda_tutorial(PassosTutorial.Flipar)
					muda_estado(Estados.MostrandoDialogoPP)
				PassosTutorial.Flipar:
					# checa se o jogador apertou a tecla correta
					muda_tutorial(PassosTutorial.Atirar)
					muda_estado(Estados.MostrandoDialogoPP)  
	pass
