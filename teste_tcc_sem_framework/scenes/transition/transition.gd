extends CanvasLayer


func _ready() -> void:
	await fade_out()
	await fade_in()


func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	pass


func fade_out(animated: bool = true) -> void:
	if not animated:
		_set_fade_opacity(1.0)
		return
	var tween: Tween = get_tree().create_tween()
	tween.tween_method(_set_fade_opacity, 0.0, 1.0, 1.2)
	tween.play()
	await tween.finished


func fade_in(animated: bool = true) -> void:
	if not animated:
		_set_fade_opacity(0.0)
		return
	var tween: Tween = get_tree().create_tween()
	tween.tween_method(_set_fade_opacity, 1.0, 0.0, 1.2)
	tween.play()
	await tween.finished


func _set_fade_opacity(opacity: float) -> void:
	var material: ShaderMaterial = $ColorRect.get_material()
	material.set_shader_parameter("thereshold", opacity)

