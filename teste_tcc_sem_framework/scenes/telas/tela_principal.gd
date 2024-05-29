extends CanvasLayer


signal jogar
signal sair


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	pass


func _on_button_jogar_pressed() -> void:
	print("Jogar signal emitted!")
	jogar.emit()


func _on_button_sair_pressed() -> void:
	print("Sair signal emitted!")
	sair.emit()
