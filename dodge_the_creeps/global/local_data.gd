extends Node

const LOCAL_DATA_PATH: String = "user://local_data.dat"

var data_content_: Dictionary = {}

func _ready() -> void:
    data_content_ = JSON.parse_string(read_data_from_file(LOCAL_DATA_PATH))

func read_data_from_file(file_path: String) -> String:
    var file_handle: FileAccess = FileAccess.open(file_path, FileAccess.READ)
    if file_handle == null:
        return ""
    var file_content: String = file_handle.get_as_text()
    file_handle.close()
    return file_content

func write_data_to_file(file_path: String, data: String) -> void:
    var file_handle: FileAccess = FileAccess.open(file_path, FileAccess.WRITE)
    if file_handle != null:
        file_handle.store_string(data)
        file_handle.close()

func read_from_local_data(key: String) -> Variant:
    if data_content_.is_empty() or not data_content_.has(key):
        return null
    return data_content_[key]

func write_to_local_data(key: String, value: Variant) -> void:
    data_content_[key] = value
    write_data_to_file(LOCAL_DATA_PATH, JSON.stringify(data_content_))
