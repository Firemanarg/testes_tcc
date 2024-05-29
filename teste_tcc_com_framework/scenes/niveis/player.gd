extends CharacterBody2D


enum State { IDLE, RUN, ON_AIR }

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const STATE_NAMES: Dictionary = {
	State.IDLE: "idle",
	State.RUN: "run",
	State.ON_AIR: "jump",
}
const LOWER_HEIGHT_MARGIN: float = 800

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

var _is_alive: bool = true
var _state: State = State.IDLE


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		_state = State.ON_AIR

	if _is_alive:
		# Handle jump.
		var pressed_jump: bool = (
			Input.is_action_just_pressed("ui_accept")
			or Input.is_action_just_pressed("ui_up")
		)
		if pressed_jump and is_on_floor():
			velocity.y = JUMP_VELOCITY
			$AudioPlayer.play()


		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction := Input.get_axis("ui_left", "ui_right")
		if direction:
			velocity.x = direction * SPEED
			_state = State.RUN
			$Sprite2D.position.x = abs($Sprite2D.position.x) * -direction
			$Sprite2D.scale.x = abs($Sprite2D.scale.x) * direction
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			_state = State.IDLE

		var state_machine = $AnimationTree.get("parameters/playback")
		state_machine.travel(STATE_NAMES[_state])

		var is_dead: bool = position.y > LOWER_HEIGHT_MARGIN
		if is_dead:
			FDCore.trigger_action("derrota", "nivel")
			_is_alive = false

	move_and_slide()


