extends Node


#region FlagNames
const RegularFlagNames: PackedStringArray = [
	"fps", "idle_process", "physics_process", "objects",
	"resources", "nodes", "orphan_nodes", "memory_usage"
]
const SpecialFlagNames: PackedStringArray = [
	"memory_usage_percent"
]
const FlagNames: PackedStringArray = RegularFlagNames + SpecialFileNames
#endregion
#region FileNames
const RegularFileNames: PackedStringArray = [
	"fps", "idlproc", "phyproc", "objs",
	"res", "nodes", "orphnds", "mem",
]
const SpecialFileNames: PackedStringArray = [
	"memprc",
]
const FileNames: PackedStringArray = RegularFileNames + SpecialFileNames
#endregion
#region Methods
const Monitors: Array[Performance.Monitor] = [
	Performance.Monitor.TIME_FPS,
	Performance.Monitor.TIME_PROCESS,
	Performance.Monitor.TIME_PHYSICS_PROCESS,
	Performance.Monitor.OBJECT_COUNT,
	Performance.Monitor.OBJECT_RESOURCE_COUNT,
	Performance.Monitor.OBJECT_NODE_COUNT,
	Performance.Monitor.OBJECT_ORPHAN_NODE_COUNT,
	Performance.Monitor.MEMORY_STATIC,
]

var special_methods: Array[Callable] = [
	_get_memory_usage_percent,
]
#endregion

var _flags: Array[bool] = []
var _files: Array[FileAccess] = []

var _total_memory: int = 0


func _ready() -> void:
	_init_all()
	_total_memory = OS.get_memory_info().get("physical")


func _process(delta: float) -> void:
	append_report_values()


func append_report_values() -> void:
	for i in FlagNames.size():
		if _files[i] == null:
			continue
		if i < RegularFlagNames.size(): # Regular flags
			_append_report_value(_files[i], Performance.get_monitor(Monitors[i]))
		else: # Special flags
			_append_report_value(
				_files[i],
				special_methods[i - RegularFlagNames.size()].call()
			)


func _append_report_value(report_file: FileAccess, value) -> void:
	report_file.store_string(str(value) + ",")


func _init_all() -> void:
	_flags.resize(FlagNames.size())
	_files.resize(FlagNames.size())
	var output_path: String = _get_output_path()
	DirAccess.make_dir_absolute(output_path)
	#var dir: DirAccess = DirAccess.open(output_path)
	for i in FlagNames.size():
		_flags[i] = _get_flag_value(FlagNames[i])
		if not _flags[i]:
			_files[i] = null
			continue
		var file_name: String = output_path + "/" + FileNames[i] + ".txt"
		_files[i] = FileAccess.open(file_name, FileAccess.WRITE)
		_files[i].seek(0)
		_files[i].store_string("")


func _get_flag_value(flag_name: String) -> bool:
	return ProjectSettings.get_setting(flag_name, true)


func _get_output_path() -> String:
	return ProjectSettings.get_setting(
		"debug/settings/debug_report/report_output_path",
		"res://debug_report"
	)


func _get_memory_usage_percent() -> float:
	var memory_usage: int = Performance.get_monitor(Performance.MEMORY_STATIC)
	if is_zero_approx(_total_memory):
		print("Error retrieving total memory")
		return 0.0
	var usage_percent: float = memory_usage * 100.0 / _total_memory
	return usage_percent

