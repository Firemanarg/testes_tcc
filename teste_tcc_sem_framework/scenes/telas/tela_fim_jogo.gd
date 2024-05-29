extends CanvasLayer


signal reiniciar
signal retornar
signal sair

@onready var button_jogar_novamente = get_node("CenterContainer/VBoxContainer/ButtonJogarNovamente")
@onready var button_tela_principal = get_node("CenterContainer/VBoxContainer/ButtonTelaPrincipal")
@onready var button_sair = get_node("CenterContainer/VBoxContainer/ButtonSair")


func _ready() -> void:
	button_jogar_novamente.pressed.connect(_on_button_jogar_novamente_pressed)
	button_tela_principal.pressed.connect(_on_button_tela_principal_pressed)
	button_sair.pressed.connect(_on_button_sair_pressed)


func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	pass



func _on_button_jogar_novamente_pressed() -> void:
	reiniciar.emit()


func _on_button_tela_principal_pressed() -> void:
	retornar.emit()


func _on_button_sair_pressed() -> void:
	sair.emit()
