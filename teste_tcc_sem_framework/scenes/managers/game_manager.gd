extends Node


const _GodotLogoIntroScene: PackedScene = preload("res://scenes/logo_intros/godot_logo_intro.tscn")
const _FireDroidLogoIntroScene: PackedScene = preload("res://scenes/logo_intros/fire_droid_logo_intro.tscn")
const _TransitionScene: PackedScene = preload("res://scenes/transition/transition.tscn")
const _TelaPrincipalScene: PackedScene = preload("res://scenes/telas/tela_principal.tscn")
const _TelaVitoriaScene: PackedScene = preload("res://scenes/telas/tela_vitoria.tscn")
const _TelaDerrotaScene: PackedScene = preload("res://scenes/telas/tela_derrota.tscn")
const _Nivel1Scene: PackedScene = preload("res://scenes/niveis/nivel_1.tscn")
const _Nivel2Scene: PackedScene = preload("res://scenes/niveis/nivel_2.tscn")
const _Nivel3Scene: PackedScene = preload("res://scenes/niveis/nivel_3.tscn")

const MusicaNivel: AudioStream = preload("res://assets/audios/musics/level_music.ogg")
const MusicaMenu: AudioStream = preload("res://assets/audios/musics/menu_music.ogg")

var permanent_back_layer: Node = Node.new()
var temporary_layer: Node = Node.new()
var permanent_front_layer: Node = Node.new()
var transition_layer: Node = Node.new()

var music_player: AudioStreamPlayer = AudioStreamPlayer.new()

var current_scene: Node = null
var current_level: int = -1 # -1 significa que não está em um level, 0 é o nivel 1


func _ready() -> void:
	_setup_layers()

	await change_to_scene(_GodotLogoIntroScene)
	await current_scene.finished

	await change_to_scene(_FireDroidLogoIntroScene)
	await current_scene.finished

	await _change_screen_to_tela_principal()
	_setup_music_player()


func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	pass


func change_to_scene(scene: PackedScene) -> void:
	var transition = _TransitionScene.instantiate()
	transition_layer.add_child(transition)
	await transition.fade_out(current_scene != null)
	clear_children(temporary_layer)
	current_scene = scene.instantiate()
	print("Changing to scene ", current_scene.name)
	temporary_layer.add_child(current_scene)
	await transition.fade_in()
	transition.queue_free()


func clear_children(node: Node) -> void:
	for child in node.get_children():
		child.queue_free()


func _setup_layers() -> void:
	permanent_back_layer.name = "PermanentBackLayer"
	temporary_layer.name = "TemporaryLayer"
	permanent_front_layer.name = "PermanentFrontLayer"
	transition_layer.name = "TransitionLayer"
	add_child(permanent_back_layer)
	add_child(temporary_layer)
	add_child(permanent_front_layer)
	add_child(transition_layer)


func _setup_music_player() -> void:
	permanent_front_layer.add_child(music_player)
	music_player.set_stream(MusicaMenu)
	music_player.play()


#region TelaPrincipal
func _change_screen_to_tela_principal() -> void:
	await change_to_scene(_TelaPrincipalScene)
	current_scene.jogar.connect(_on_jogar_emitted)
	current_scene.sair.connect(_on_sair_emitted)
	current_level = -1


func _on_jogar_emitted() -> void:
	print("Jogar signal catch!")
	current_level = 0
	await _change_screen_to_nivel()


func _on_sair_emitted() -> void:
	print("Sair signal catch!")
	get_tree().quit()
#endregion

#region Nivel
func _change_screen_to_nivel() -> void:
	var nivel_scene: PackedScene = null
	if current_level == 0:
		nivel_scene = _Nivel1Scene
	elif current_level == 1:
		nivel_scene = _Nivel2Scene
	elif current_level == 2:
		nivel_scene = _Nivel3Scene
	else:
		await _change_screen_to_tela_fim_jogo(_TelaVitoriaScene)
		return
	await change_to_scene(nivel_scene)
	current_scene.derrota.connect(_on_signal_derrota_emitted)
	current_scene.vitoria.connect(_on_signal_vitoria_emitted)
	current_scene.reiniciar.connect(_on_reiniciar_emitted)
	current_scene.retornar.connect(_on_retornar_emitted)
	if current_level == 0:
		music_player.set_stream(MusicaNivel)
		music_player.play()


func _on_signal_derrota_emitted() -> void:
	await _change_screen_to_tela_fim_jogo(_TelaDerrotaScene)


func _on_signal_vitoria_emitted() -> void:
	current_level += 1
	_change_screen_to_nivel()
#endregion

#region TelaFimJogo
func _change_screen_to_tela_fim_jogo(cena: PackedScene) -> void:
	await change_to_scene(cena)
	current_scene.reiniciar.connect(_on_reiniciar_emitted)
	current_scene.retornar.connect(_on_retornar_emitted)
	current_scene.sair.connect(_on_sair_emitted)
	current_level = -1
	music_player.set_stream(MusicaMenu)
	music_player.play()


func _on_reiniciar_emitted() -> void:
	current_level = 0
	_change_screen_to_nivel()


func _on_retornar_emitted() -> void:
	await _change_screen_to_tela_principal()
	music_player.set_stream(MusicaMenu)
	music_player.play()
#endregion
