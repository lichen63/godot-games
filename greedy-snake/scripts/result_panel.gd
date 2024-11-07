extends ColorRect


func exit_state(state: Configs.GameState) -> void:
    match state:
        Configs.GameState.IDLE:
            pass
        Configs.GameState.PLAYING:
            pass
        Configs.GameState.SUCCESS:
            pass
        Configs.GameState.FAILURE:
            pass
        Configs.GameState.PAUSED:
            pass
        _:
            pass

func enter_state(state: Configs.GameState) -> void:
    match state:
        Configs.GameState.IDLE:
            self.find_child("ResultText").text = Configs.GAME_START_IDLE
            self.show()
        Configs.GameState.PLAYING:
            self.hide()
        Configs.GameState.SUCCESS:
            self.find_child("ResultText").text = Configs.GAME_END_SUCCESS
            self.show()
        Configs.GameState.FAILURE:
            self.find_child("ResultText").text = Configs.GAME_END_FAILURE
            self.show()
        Configs.GameState.PAUSED:
            self.find_child("ResultText").text = Configs.GAME_PAUSED
            self.show()
        _:
            pass

func _on_start_button_button_down() -> void:
    self.get_parent().update_game_state(Configs.GameState.PLAYING)
