extends Label

const SCORE_LABEL_TEXT_PREFIX: String = "Score: "

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
            self.hide()
        Configs.GameState.PLAYING:
            self.show()
        Configs.GameState.SUCCESS:
            self.show()
        Configs.GameState.FAILURE:
            self.show()
        Configs.GameState.PAUSED:
            self.show()
        _:
            pass

func update_score(score: int) -> void:
    self.text = SCORE_LABEL_TEXT_PREFIX + str(score)

#endregion

#region private signal methods
func _on_snake_nodes_on_snake_body_length_changed(length: int) -> void:
    update_score(length)

#endregion
