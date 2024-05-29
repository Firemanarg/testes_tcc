class_name Transition
extends Control
## A simple configurable transition node with various styles.
##
## This class simplifies the transitions, implementing various predefined
## styles, allowing to configure animation duration, tween settings and fill
## of transition.[br][br][b]Example:[/b]
## [codeblock]
## func transition_to_level(level_settings: Dictionary) -> void:
##     var transition: Transition = Transition.new()
##     add_child(transition)
##     await transition.play()
##     _setup_level(level_settings)
##     await transition.play()
##     transition.queue_free()
## [/codeblock]


## Emitted when any transition animation ([code]IN[/code] or [code]OUT[/code]) has started.
signal started
## Emitted when any transition animation ([code]IN[/code] or [code]OUT[/code]) has finished.
signal finished

enum Status {
	IN, ## On next animation, transition will appear.
	OUT, ## On next animation, transition will disappear.
}
enum FillType {
	COLOR, ## Transition will be filled with solid color.
	TEXTURE, ## Transition will be filled with texture.
}
enum TransitionStyle {
	FADE, ## Fill will smoothly appear and disappear, interpolating it's opacity. Requires only one fill color or texture.
	#SLIDE_LEFT,
	#SLIDE_RIGHT,
	#SLIDE_UP,
	#SLIDE_DOWN,
	#CIRCLE,
	#DIAMONDS,
	#STRIPPED_LINES,
	#ROUND_SQUARES,
	#SCREENTONE,
	#SAW_LEFT,
	#SAW_RIGHT,
	#SAW_UP,
	#SAW_DOWN,
	#PIXEL_SORTING,
	#BURN,
	#SPIRAL,
	#PIXEL_DISSOLVE,
	#CROSSFADE_CIRCLE,
}

const _Shaders: Dictionary = {
	TransitionStyle.FADE: preload("res://addons/fire_droid_core/shaders/transition_shaders/fade.gdshader"),
}

@export_group("Transition In")
## Style of transition when appearing. See [enum TransitionStyle].
@export var style_in: TransitionStyle = TransitionStyle.FADE
## Trans type of tween when appearing. See [enum Tween.TransitionType].
@export var trans_type_in: Tween.TransitionType = Tween.TRANS_LINEAR
## Ease type of tween when appearing. See [enum Tween.EaseType].
@export var ease_type_in: Tween.EaseType = Tween.EASE_IN
## Duration of transition when appearing.
@export_range(0.0, 5.0, 0.01, "or_greater") var duration_in: float = 1.2

@export_group("Transition Out")
## Style of transition when disappearing. See [enum TransitionStyle].
@export var style_out: TransitionStyle = TransitionStyle.FADE
## Trans type of tween when disappearing. See [enum Tween.TransitionType].
@export var trans_type_out: Tween.TransitionType = Tween.TRANS_LINEAR
## Ease type of tween when disappearing. See [enum Tween.EaseType].
@export var ease_type_out: Tween.EaseType = Tween.EASE_IN
## Duration of transition when disappearing.
@export_range(0.0, 5.0, 0.01, "or_greater") var duration_out: float = 1.2

@export_group("Fill")
## The type of fill for this transition.[br][br]If value is [code]COLOR[/code],
## transition is filled with solid colors provided by [member color_1] and
## [member color_2]. Else if value is [code]TEXTURE[/code], transition is filled
## with textures provided by [member texture_1] and [member texture_2].[br][br]
## Not all transition styles uses two fill types.[br][br]See [enum TransitionStyle].
@export var fill_type: FillType = FillType.COLOR
@export_subgroup("Color")
## If [member fill_type] is [code]COLOR[/code] this color will be used as
## primary color of the transition.[br][br]Not all transition styles uses two colors.
@export var color_1: Color = Color.BLACK
## If [member fill_type] is [code]COLOR[/code] this color will be used as
## secondary color of the transition.[br][br]Not all transition styles uses two colors.
@export var color_2: Color = Color.WHITE
@export_subgroup("Texture")
## If [member fill_type] is [code]TEXTURE[/code] this texture will be used as
## primary texture of the transition.[br][br]Not all transition styles uses two textures.
@export var texture_1: CompressedTexture2D = null
## If [member fill_type] is [code]TEXTURE[/code] this texture will be used as
## secondary texture of the transition.[br][br]Not all transition styles uses two textures.
@export var texture_2: CompressedTexture2D = null

var _status: Status = Status.IN
var _tween: Tween = null
var _thereshold: float = 0.0
var _has_transition_in_progress: bool = false

@onready var _color_rect = get_node("ColorRect")


func _ready() -> void:
	update_values()


func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	pass


## Used to manually update transition values after changing a value in code.
## [br][br][b]Example:[/b][codeblock]
## transition.color_1 = Color.BLUE
## transition.update_values() # Update visual transition after setted color_1 to blue
## [/codeblock]
## If values are set before adding the transition to scene, the values will be
## automatically updated and there is no need to call this function.
func update_values() -> void:
	_color_rect.material = ShaderMaterial.new()
	_update_shader_style()
	var use_texture: bool = (fill_type == FillType.TEXTURE)
	_color_rect.material.set_shader_parameter("color_1", color_1)
	_color_rect.material.set_shader_parameter("color_2", color_2)
	_color_rect.material.set_shader_parameter("use_texture", use_texture)
	_color_rect.material.set_shader_parameter("texture_1", texture_1)
	_color_rect.material.set_shader_parameter("texture_2", texture_2)


## Play the transition with current setting values.
func play() -> void:
	match _status:
		Status.IN:
			await _play_transition(
				ease_type_in, trans_type_in,
				duration_in, _thereshold, 1.0
			)
			finished.emit()
		Status.OUT:
			await _play_transition(
				ease_type_out, trans_type_out,
				duration_out, _thereshold, 0.0
			)
			finished.emit()


## Force a transition to begin with status [code]IN[/code] and play appearing
## animation. Once finished, emit [signal finished] signal.[br][br]See [enum Status].
func play_in() -> void:
	_status = Status.IN
	await _play_transition(
		ease_type_in, trans_type_in,
		duration_in, 0.0, 1.0
	)
	finished.emit()


## Force a transition to begin with status [code]OUT[/code] and play disappearing
## animation. Once finished, emit [signal finished] signal.[br][br]See [enum Status].
func play_out() -> void:
	_status = Status.OUT
	await _play_transition(
		ease_type_out, trans_type_out,
		duration_out, 1.0, 0.0
	)
	finished.emit()


## Forces a new status, updating thereshold to maximum (if [param status] is
## [code]OUT[/code]) or minimum (if [param status] is [code]IN[/code])
## value.[br][br][b]Example:[/b]
## [codeblock]
##     # Set transition to fully disappear, so it can begin appear animation
## transition.set_forced_status(Transition.Status.IN)
##
##     # Set transition to fully appear, so it can begin disappear animation
## transition.set_forced_status(Transition.Status.OUT)
## [/codeblock]
## See [enum Status].
func set_forced_status(status: Status) -> void:
	_status = status
	match status:
		Status.IN:
			_set_transition_thereshold(0.0)
		Status.OUT:
			_set_transition_thereshold(1.0)
	_has_transition_in_progress = false


## Return [code]true[/code] if there is a transition in progress, or [code]false[/code]
## if no transition is in progress.
func is_in_progress() -> bool:
	return _has_transition_in_progress


func _play_transition(
	ease: Tween.EaseType,
	trans: Tween.TransitionType,
	duration: float,
	initial_value: float,
	final_value: float
):
	if _tween:
		_tween.kill()
	_tween = get_tree().create_tween()
	_tween.set_ease(ease)
	_tween.set_trans(trans)
	_tween.tween_method(_set_transition_thereshold, initial_value, final_value, duration)
	_tween.play()
	started.emit()
	_has_transition_in_progress = true
	await _tween.finished
	_has_transition_in_progress = false
	match _status:
		Status.IN:
			_status = Status.OUT
		Status.OUT:
			_status = Status.IN


func _update_shader_style() -> void:
	var style: TransitionStyle = style_in
	var trans_type: Tween.TransitionType = trans_type_in
	var ease_type: Tween.EaseType = ease_type_in
	if _status == Status.OUT:
		style = style_out
		trans_type = trans_type_out
		ease_type = ease_type_out
	var shader: Shader = _Shaders[style].duplicate()
	_color_rect.material.shader = shader


func _set_transition_thereshold(thereshold: float) -> void:
	_thereshold = thereshold
	_color_rect.material.set_shader_parameter("thereshold", _thereshold)

