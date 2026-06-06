extends Node

var proxima_cena: String = ""
var proximo_planeta: String = ""


func iniciar_viagem(caminho_da_cena: String, nome_do_planeta: String):
	proxima_cena = caminho_da_cena
	proximo_planeta = nome_do_planeta

	get_tree().change_scene_to_file("res://scenes/ViagemInterplanetaria.tscn")


func limpar_viagem():
	proxima_cena = ""
	proximo_planeta = ""
