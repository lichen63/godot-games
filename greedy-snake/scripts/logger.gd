extends Node

# Log levels
enum LogLevel { DEBUG, INFO, WARNING, ERROR }

# Core logging function
func log_with_level(message:String, level:LogLevel = LogLevel.INFO) -> void:
  var level_name = ["DEBUG", "INFO", "WARNING", "ERROR"][level]
  var log_message = "[%s] [%s] %s" % [get_formatted_datetime(), level_name, message]
  # Print to the console
  match level:
    LogLevel.DEBUG:
      print_debug(log_message)
    LogLevel.INFO:
      print(log_message)
    LogLevel.WARNING:
      push_warning(log_message)
    LogLevel.ERROR:
      push_error(log_message)
    _:
      push_warning("Unknown log level: " + str(level))

# Format the fields:
# * YYYY = Year
# * MM = Month
# * DD = Day
# * hh = Hour
# * mm = Minutes
# * ss = Seconds
# * SSS = Milliseconds
func get_formatted_datetime(format:String = "YYYY-MM-DD hh:mm:ss:SSS") -> String:
  var unix_time:float = Time.get_unix_time_from_system()
  var time_zone:Dictionary = Time.get_time_zone_from_system()
  unix_time += time_zone.bias * 60
  var datetime:Dictionary = Time.get_datetime_dict_from_unix_time(int(unix_time))
  datetime.millisecond = int(unix_time * 1000) % 1000
  var formatted_time: String = format
  formatted_time = formatted_time.replace("YYYY", "%04d" % [datetime.year])
  formatted_time = formatted_time.replace("MM", "%02d" % [datetime.month])
  formatted_time = formatted_time.replace("DD", "%02d" % [datetime.day])
  formatted_time = formatted_time.replace("hh", "%02d" % [datetime.hour])
  formatted_time = formatted_time.replace("mm", "%02d" % [datetime.minute])
  formatted_time = formatted_time.replace("ss", "%02d" % [datetime.second])
  formatted_time = formatted_time.replace("SSS", "%03d" % [datetime.millisecond])

  return formatted_time

# Shortcut log methods
func debug(message: String) -> void:
    log_with_level(message, LogLevel.DEBUG)

func info(message: String) -> void:
    log_with_level(message, LogLevel.INFO)

func warning(message: String) -> void:
    log_with_level(message, LogLevel.WARNING)

func error(message: String) -> void:
    log_with_level(message, LogLevel.ERROR)
