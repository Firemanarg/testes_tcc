extends Node


signal derrota
signal vitoria
signal reiniciar
signal retornar

const LOWER_HEIGHT_MARGIN: float = 800

var _already_emitted_player_death: bool = false


func _ready() -> void:
	$Porta.player_reached.connect(_on_player_reached_porta)
	$Menu.reiniciar.connect(_on_menu_reiniciar_emitted)
	$Menu.sair.connect(_on_menu_sair_emitted)


func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	var is_player_dead: bool = $Player.position.y > LOWER_HEIGHT_MARGIN
	if is_player_dead and not _already_emitted_player_death:
		derrota.emit()
		_already_emitted_player_death = true


func _on_player_reached_porta() -> void:
	vitoria.emit()


func _on_menu_reiniciar_emitted() -> void:
	reiniciar.emit()


func _on_menu_sair_emitted() -> void:
	retornar.emit()
