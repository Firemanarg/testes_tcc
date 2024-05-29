extends FDProjectManager


const MusicaNivel: AudioStream = preload("res://assets/audios/musics/level_music.ogg")
const MusicaMenu: AudioStream = preload("res://assets/audios/musics/menu_music.ogg")

var nivel_atual: int = 0


func _init() -> void:
	initial_scene = (
		preload("res://scenes/telas/tela_principal.tscn")
	)


func _ready() -> void:
	super._ready()
	var music_player: AudioStreamPlayer = AudioStreamPlayer.new()
	FDCore.add_permanent_node("music_player", music_player)


func _on_action_triggered(action: String, context: String = "") -> void:
	match context:
		"tela_principal":
			_handler_tela_principal(action)
		"nivel":
			_handler_nivel(action)
		"fim_jogo":
			_handler_fim_jogo(action)


func _handler_tela_principal(action: String) -> void:
	match action:
		"inicio":
			_play_musica_menu()
		"jogar":
			nivel_atual = 0
			_handler_nivel_atual()
		"sair":
			get_tree().quit()


func _handler_nivel(action: String) -> void:
	var menu_nivel = await FDCore.cscall("get_node", ["Menu"])
	match action:
		"sucesso":
			nivel_atual += 1
			_handler_nivel_atual()
		"derrota":
			nivel_atual = 0
			await FDCore.change_scene_to(
				preload("res://scenes/telas/tela_derrota.tscn").instantiate()
			)
			_play_musica_menu()
		"continuar":
			menu_nivel.play_animation()
		"reiniciar":
			menu_nivel.play_animation()
			nivel_atual = 0
			_handler_nivel_atual()
		"sair":
			menu_nivel.play_animation()
			await FDCore.change_scene_to(
				preload("res://scenes/telas/tela_principal.tscn").instantiate()
			)


func _handler_fim_jogo(action: String) -> void:
	match action:
		"reiniciar":
			nivel_atual = 0
			_handler_nivel_atual()
		"tela_principal":
			await FDCore.change_scene_to(
				preload("res://scenes/telas/tela_principal.tscn").instantiate()
			)
			_play_musica_menu()
		"sair":
			get_tree().quit()


func _handler_nivel_atual() -> void:
	const Niveis: Array[PackedScene] = [
		preload("res://scenes/niveis/nivel_1.tscn"),
		preload("res://scenes/niveis/nivel_2.tscn"),
		preload("res://scenes/niveis/nivel_3.tscn"),
	]
	if nivel_atual >= Niveis.size():
		_play_musica_menu()
		await FDCore.change_scene_to(
			preload("res://scenes/telas/tela_vitoria.tscn").instantiate()
		)
		return
	await FDCore.change_scene_to(Niveis[nivel_atual].instantiate())
	if nivel_atual == 0:
		_play_musica_nivel()


func _play_musica_menu() -> void:
	var music_player: AudioStreamPlayer = FDCore.get_permanent_node("music_player")
	music_player.set_stream(MusicaMenu)
	music_player.play()


func _play_musica_nivel() -> void:
	var music_player: AudioStreamPlayer = FDCore.get_permanent_node("music_player")
	music_player.set_stream(MusicaNivel)
	music_player.play()
