extends CanvasLayer


signal reiniciar
signal sair

enum _State { IN, OUT }

var _state: _State = _State.IN


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	pass


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		var is_just_pressed: bool = event.is_pressed() and not event.echo
		if event.keycode == KEY_ESCAPE and is_just_pressed:
			if _state == _State.IN:
				play_in()
				_state = _State.OUT
			elif _state == _State.OUT:
				play_out()
				_state = _State.IN


func play_in() -> void:
	var tween: Tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_SPRING)
	tween.tween_property(self, "offset", Vector2(0, 0), 0.8)
	tween.play()


func play_out() -> void:
	var tween: Tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "offset", Vector2(-1280, 0), 0.8)
	tween.play()


func _on_button_continuar_pressed() -> void:
	play_out()


func _on_button_reiniciar_pressed() -> void:
	reiniciar.emit()
	play_out()


func _on_button_sair_pressed() -> void:
	sair.emit()
	play_out()
