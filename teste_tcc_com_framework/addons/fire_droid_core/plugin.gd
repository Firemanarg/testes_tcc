@tool
extends EditorPlugin


func _enter_tree() -> void:
	_update_custom_settings()
	add_autoload_singleton("FDCore", "res://addons/fire_droid_core/scenes/fd_core.gd")


func _exit_tree() -> void:
	remove_autoload_singleton("FDCore")


func _update_custom_settings() -> void:
	# Format -> "setting_name": "default_value"
	const custom_settings: Array[Dictionary] = [
		{
			"name": "fd_core/project_manager",
			"type": TYPE_STRING,
			"hint": PROPERTY_HINT_FILE,
			"hint_string": "*.gd",
			"initial_value": "",
		},
		{
			"name": "fd_core/enable_debug_mode",
			"type": TYPE_BOOL,
			"initial_value": false,
		}
	]
	for setting in custom_settings:
		var setting_name: String = setting.get("name")
		var initial_value = setting.get("initial_value")
		if not ProjectSettings.has_setting(setting_name):
			ProjectSettings.set_setting(setting_name, initial_value)
		ProjectSettings.add_property_info(setting)
		ProjectSettings.set_initial_value(setting_name, initial_value)
		print("Added custom setting: ", setting)
		print("Value: ", ProjectSettings.get_setting("fd_core/project_manager", "<undefined>"))
