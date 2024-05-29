@tool
extends EditorPlugin


func _enter_tree() -> void:
	add_autoload_singleton(
		"DebuggerReport",
		"res://addons/debugger_report/debugger_report.gd"
	)
	_update_custom_settings()
	pass


func _exit_tree() -> void:
	remove_autoload_singleton("DebuggerReport")


func _update_custom_settings() -> void:
	# Format -> "setting_name": "default_value"
	for flag_name in DebuggerReport.FlagNames:
		_add_custom_setting_flag("debug/settings/debug_report/" + flag_name)
	_add_setting_output_path()
	_add_setting_autostart_output()


func _add_custom_setting_flag(flag_name: String) -> void:
	var setting_info: Dictionary = {
		"name": flag_name,
		"type": TYPE_BOOL,
	}
	if not ProjectSettings.has_setting(flag_name):
		ProjectSettings.set_setting(flag_name, true)
	ProjectSettings.add_property_info(setting_info)
	ProjectSettings.set_initial_value(flag_name, true)


func _add_setting_output_path() -> void:
	const ReportOutputPath: String = "debug/settings/debug_report/report_output_path"
	const ReportOutputSetting: Dictionary = {
		"name": ReportOutputPath,
		"type": TYPE_STRING,
		"hint": PROPERTY_HINT_DIR,
	}
	if not ProjectSettings.has_setting(ReportOutputPath):
		ProjectSettings.set_setting(ReportOutputPath, "res://debug_report")
	ProjectSettings.add_property_info(ReportOutputSetting)
	ProjectSettings.set_initial_value(ReportOutputPath, "res://debug_report")


func _add_setting_autostart_output() -> void:
	const AutostartOutputPath: String = "debug/settings/debug_report/autostart_output"
	const AutostartOutputSetting: Dictionary = {
		"name": AutostartOutputPath,
		"type": TYPE_BOOL,
	}
	if not ProjectSettings.has_setting(AutostartOutputPath):
		ProjectSettings.set_setting(AutostartOutputPath, true)
	ProjectSettings.add_property_info(AutostartOutputSetting)
	ProjectSettings.set_initial_value(AutostartOutputPath, true)
