extends GerenciaBotoes

#GERENCIA DIALOGO

var dialogue_id: String = "DPai1"
var popup_id: String = "PPAP"
var popup_duration_per_message:= 4.0

var pode_acessar={ 
	"garagem": true,
	"vendedor": false,
	"geologo": false,
	"loja": false
}

@export var texto_notificacao: Label
	
func desenha_hover(idx_botao_atual: int):
	var botao_alvo = lista_botoes[idx_botao_atual]
	
	var pos_botao = botao_alvo.global_position
	hover.global_position = Vector2(pos_botao.x + 65, pos_botao.y + 25)
	altera_notificacao(idx_botao_atual)

func seleciona_botao(idx_botao: int): # OVERRIDE
	match idx_botao:
		0:#garagem
			tocar_som("confirmar")
			pode_mexer = false
			DialogueManager.start_dialogue_id(dialogue_id)
			
			await get_tree().create_timer(2).timeout
			DialogueManager.show_popup_id(popup_id, popup_duration_per_message)
			#faz com que o jogador não possa mais mexer nas coisas
			await DialogueManager.dialogue_finished
			while not DialogueManager.dialogo_acabou:
				await get_tree().process_frame
			gerenciadorCenas.passarCena.emit(GerenciadorCenas.Cenas.Tutorial)
			DialogueManager.dialogo_acabou = false
			pass
		1:#vendedor
			#enquanto estiver bloqueado
			tocar_som("voltar")
			pass
		2:#geologo
			#enquanto estiver bloqueado
			tocar_som("voltar")
			pass
		3:#loja
			#enquanto estiver bloqueado
			tocar_som("voltar")
			pass
	pass
	
func altera_notificacao(idx_selecionado:int):
	match idx_selecionado:
		0:
			if pode_acessar["garagem"] == true:
				texto_notificacao.text = "Acesso Liberado!"
			else:
				texto_notificacao.text = "Acesso Bloqueado!"
			pass
		1:
			if pode_acessar["vendedor"] == true:
				texto_notificacao.text = "Acesso Liberado!"
			else:
				texto_notificacao.text = "Acesso Bloqueado!"
			pass
		2:
			if pode_acessar["geologo"] == true:
				texto_notificacao.text = "Acesso Liberado!"
			else:
				texto_notificacao.text = "Acesso Bloqueado!"
			pass
		3:
			if pode_acessar["loja"] == true:
				texto_notificacao.text = "Acesso Liberado!"
			else:
				texto_notificacao.text = "Acesso Bloqueado!"
			pass
	pass
