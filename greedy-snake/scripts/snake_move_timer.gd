extends Timer

#region public methods
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
            self.stop()
        Configs.GameState.PLAYING:
            self.start()
        Configs.GameState.SUCCESS:
            self.stop()
        Configs.GameState.FAILURE:
            self.stop()
        Configs.GameState.PAUSED:
            self.start()
        _:
            pass

#endregion
