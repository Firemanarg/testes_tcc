class_name FDProjectManager
extends Node
## A base class for a project manager of Fire-Droid Game Studios projects.
##
## This class works as a template, and all project managers compatible with FDCore
## must inherit from this.[br]There are two mandatory actions for a project
## manager creation:[br][br]
## 1. Set [member initial_scene]: this can be done by assigning a [PackedScene]
## to [member initial_scene] inside [method Object._init].[br][br][b]Example:[/b]
## [codeblock]
## func _init() -> void:
##     initial_scene = preload("res://scenes/main_screen.tscn")
## [/codeblock]
## 2. Override [method _on_action_triggered]: this method is the main handler for
## all triggered actions coming from FDCore. Override this to define interactions
## over the project.[br][br][b]Example:[/b]
## [codeblock]
## func _on_action_triggered(action: String, context: String = "") -> void:
##     match context:
##         "main_screen": _main_screen_handler(action)
##         "level": _level_handler(action)
##
## func _main_screen_handler(action: String) -> void:
##     match action:
##         "play": FDCore.change_screen("res://scenes/level.tscn")
##         "quit": get_tree().quit()
##
## func _level_handler(action: String) -> void:
##     match action:
##         "main_screen": FDCore.change_screen("res://scenes/main_screen.tscn")
##         "restart": FDCore.change_screen("res://scenes/level.tscn")
##         "quit": get_tree().quit()
## [/codeblock]


## This is the first scene that will be loaded after the logo intros animations.
## If this is [code]null[/code] at begin of execution, the program will be
## terminated with exit code 1. To prevent it, set the property value inside the
## built-in method [method _init].[br][br][b]Example:[/b]
## [codeblock]
## func _init():
##     initial_scene = preload("res://scenes/main_screen.tscn")
## [/codeblock]
var initial_scene: PackedScene = null


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	pass


## This method can handle actions triggered by FDCore or an ActionHUD.
## [param action] is the action received, [param context] is an optional
## argument that can be used to distinguish actions with same name.[br][br]
## To change how this function handles actions, override [method _on_action_triggered].
func on_action_triggered(action: String, context: String = "") -> void:
	_on_action_triggered(action, context)


## This is an overridable method.[br][br]
## This method can be used to handle actions triggered by FDCore or an ActionHUD.
## [param action] is the action received, [param context] is an optional
## argument that can be used to distinguish actions with same name.
## [codeblock]
## func _on_action_triggered(action: String, context: String = "") -> void:
##     match context:
##          "main_screen": _main_screen_handler(action)
##          "level": _level_handler(action)
##
## func _main_screen_handler(action: String) -> void:
##     match action:
##         "play": FDCore.change_scene_to("res://scenes/first_level.gd")
##         "load": SaveSystem.load_game()
##         "quit": get_tree().quit() # Same action, different context
##
## func _level_handler(action: String) -> void:
##     match action:
##         "pause": level.pause()
##         "unpause": level.unpause()
##         "quit": FDCore.change_scene_to("res://scenes/main_screen.gd") # Same action, different context
## [/codeblock]
func _on_action_triggered(action: String, context: String = "") -> void:
	pass
