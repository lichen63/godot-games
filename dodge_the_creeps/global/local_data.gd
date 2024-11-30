extends Node

const LOCAL_DATA_PATH: String = "user://local_data.dat"
const MAX_SCORE_KEY: String = "max_score"

var file_handle_: FileAccess = null
var data_content_: Dictionary = {}

func _ready() -> void:
    file_handle_ = FileAccess.open(LOCAL_DATA_PATH, FileAccess.READ_WRITE)
    if file_handle_ == null:
        print("Local data file loading failed, error: %d", FileAccess.get_open_error())
        return
    var file_content: String = file_handle_.get_as_text()
    var json = JSON.new()
    if json.parse(file_content) != OK:
        print("JSON parse error from local data file: ", json.get_error_message(), " in ", file_content, " at line ", json.get_error_line())
        return
    data_content_ = json.data
    if not typeof(data_content_) == TYPE_DICTIONARY:
        print("Unexpected data from local data file")

func read_from_local_data(key: String) -> Variant:
    if data_content_.is_empty() or not data_content_.has(key):
        return null
    return data_content_[key]

func save_to_local_data(key: String, value: Variant) -> void:
    data_content_[key] = value
    if file_handle_ != null:
        var data_string: String = JSON.stringify(data_content_)
        file_handle_.store_string(data_string)