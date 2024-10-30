extends Node

# Log levels
enum LogLevel { DEBUG, INFO, WARNING, ERROR }

# Core logging function
func log_with_level(message:String, level:LogLevel = LogLevel.INFO) -> void:
    var level_name = ["DEBUG", "INFO", "WARNING", "ERROR"][level]
    var log_message = "[%s] [%s] %s" % [get_formatted_datetime, level_name, message]
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
func get_formatted_datetime(format:String = "YYYY.MM.DD hh.mm.ss.SSS") -> String:
  var unix_time:float = Time.get_unix_time_from_system()
  var time_zone:Dictionary = Time.get_time_zone_from_system()
  unix_time += time_zone.bias * 60
  var datetime:Dictionary = Time.get_datetime_dict_from_unix_time(int(unix_time))
  datetime.millisecond = int(unix_time * 1000) % 1000
  var formatted_time = format % [
      datetime.year, datetime.month, datetime.day,
      datetime.hour, datetime.minute, datetime.second, datetime.millisecond
  ]
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
