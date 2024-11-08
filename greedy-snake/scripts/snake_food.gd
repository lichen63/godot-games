extends Node2D

#region public methods
func exit_state(state: Configs.GameState) -> void:
    match state:
        Configs.GameState.IDLE:
            pass
        Configs.GameState.PLAYING:
            pass
        Configs.GameState.SUCCESS:
            self._refresh_position()
        Configs.GameState.FAILURE:
            self._refresh_position()
        Configs.GameState.PAUSED:
            pass
        _:
            pass

func enter_state(state: Configs.GameState) -> void:
    match state:
        Configs.GameState.IDLE:
            self._refresh_position()
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

func _refresh_position() -> void:
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
    self.position = MapController.calc_pos_from_coord(next_coord)
    MapController.update_coord_state(next_coord, MapController.MapCellState.FOOD)

#endregion

#region private methods

#endregion

#region private singals

func _on_snake_nodes_on_snake_movd_to_coord(coord: Vector2i) -> void:
    var cur_coord = MapController.calc_coord_from_pos(self.position)
    if is_same(cur_coord, coord):
        self._refresh_position()

#endregion
