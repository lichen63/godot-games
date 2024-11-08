extends Node2D

#region public methods
func exit_state(state: Configs.GameState) -> void:
    match state:
        Configs.GameState.IDLE:
            pass
        Configs.GameState.PLAYING:
            pass
        Configs.GameState.SUCCESS:
            self.refresh_position()
        Configs.GameState.FAILURE:
            self.refresh_position()
        Configs.GameState.PAUSED:
            pass
        _:
            pass

func enter_state(state: Configs.GameState) -> void:
    match state:
        Configs.GameState.IDLE:
            self.refresh_position()
            self.hide()
        Configs.GameState.PLAYING:
            self.show()
        Configs.GameState.SUCCESS:
            self.hide()
        Configs.GameState.FAILURE:
            self.hide()
        Configs.GameState.PAUSED:
            self.hide()
        _:
            pass

func refresh_position() -> void:
    # Get all the idle map cell
    var idle_cells: Array[Vector2i] = []
    for x in range(1, Configs.MAP_CELL_SIZE_X - 1):
        for y in range(1, Configs.MAP_CELL_SIZE_Y - 1):
            if MapController.check_coord_is_blank(Vector2i(x, y)):
                idle_cells.push_back(Vector2i(x, y))
    if idle_cells.size() == 0:
        return
    # Get a random coordinate from the idle cells
    var rand_index: int = randi_range(0, idle_cells.size() - 1)
    var next_coord: Vector2i = idle_cells[rand_index]
    var cur_coord: Vector2i = MapController.calc_coord_from_pos(self.position)
    self.position = MapController.calc_pos_from_coord(next_coord)
    MapController.update_coord_state(cur_coord, MapController.MapCellState.BLANK)
    MapController.update_coord_state(next_coord, MapController.MapCellState.FOOD)

#endregion

#region private methods

#endregion
