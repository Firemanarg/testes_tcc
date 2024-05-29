extends Control


signal finished

var _was_skipped: bool = false


func _ready() -> void:
	$AnimationPlayer.animation_finished.connect(
		func (_nm):
			if not _was_skipped:
				finished.emit()
	)
	play()


func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	pass


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		var is_just_pressed: bool = event.is_pressed() and not event.echo
		if event.keycode == KEY_ESCAPE and is_just_pressed:
			finished.emit()
			_was_skipped = true


func play() -> void:
	$AnimationPlayer.play("default")
	$AudioStreamPlayer.play()

