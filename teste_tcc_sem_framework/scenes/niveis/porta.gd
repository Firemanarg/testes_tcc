extends Area2D


signal player_reached


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	pass


func _on_body_entered(_body: Node2D) -> void:
	player_reached.emit()
