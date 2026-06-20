extends Node

var combustivel: int = 100
var pecas: int = 0
var planeta_atual: String = "garagem"
var ultimo_planeta_visitado: String = ""


func salvar_database():
	var dados = {
		"combustivel": combustivel,
		"pecas": pecas,
		"planeta_atual": planeta_atual,
		"ultimo_planeta_visitado": ultimo_planeta_visitado
	}

	var arquivo = FileAccess.open("user://nave_database.save", FileAccess.WRITE)
	arquivo.store_var(dados)
	arquivo.close()


func carregar_database():
	if not FileAccess.file_exists("user://nave_database.save"):
		return

	var arquivo = FileAccess.open("user://nave_database.save", FileAccess.READ)
	var dados = arquivo.get_var()
	arquivo.close()

	combustivel = dados.get("combustivel", 100)
	pecas = dados.get("pecas", 0)
	planeta_atual = dados.get("planeta_atual", "garagem")
	ultimo_planeta_visitado = dados.get("ultimo_planeta_visitado", "")
