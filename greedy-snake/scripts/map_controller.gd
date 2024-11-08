extends Node

enum MapCellState {BLANK, WALL, SNAKE, FOOD}

var cell_data_: Array = []

#region public methods
# Calculate the position from coordinate
func calc_pos_from_coord(coord: Vector2i) -> Vector2:
    var pos_x: float = Configs.MAP_CELL_WIDTH * coord.x
    var pos_y: float = Configs.MAP_CELL_WIDTH * coord.y
    return Vector2(pos_x, pos_y)

# Calculate the coordinate from position
func calc_coord_from_pos(pos: Vector2) -> Vector2i:
    var coord_x: int = int(pos.x / Configs.WALL_WIDTH)
    var coord_y: int = int(pos.y / Configs.WALL_WIDTH)
    return Vector2i(coord_x, coord_y)

# Reset the state of map cells
func reset_map_cell_state() -> void:
    cell_data_.clear()
    for x in range(0, Configs.MAP_CELL_SIZE_X):
        var column_data: Array = []
        column_data.push_back(MapCellState.WALL)
        for y in range(1, Configs.MAP_CELL_SIZE_Y - 1):
            if x == 0 or x == Configs.MAP_CELL_SIZE_X - 1:
                column_data.push_back(MapCellState.WALL)
            else:
                column_data.push_back(MapCellState.BLANK)
        column_data.push_back(MapCellState.WALL)
        cell_data_.push_back(column_data)

func check_coord_is_blank(coord: Vector2i) -> bool:
    if not check_coord_in_range(coord):
        return false
    return cell_data_[coord.x][coord.y] == MapCellState.BLANK

func check_coord_is_available(coord: Vector2i) -> bool:
    if not check_coord_in_range(coord):
        return false
    if cell_data_[coord.x][coord.y] == MapCellState.WALL:
        return false
    if cell_data_[coord.x][coord.y] == MapCellState.SNAKE:
        return false
    return true

func check_coord_in_range(coord: Vector2i) -> bool:
    if coord.x < 0 or coord.x >= Configs.MAP_CELL_SIZE_X:
        return false
    if coord.y < 0 or coord.y >= Configs.MAP_CELL_SIZE_Y:
        return false
    return true

func check_coord_has_wall(coord: Vector2i) -> bool:
    return cell_data_[coord.x][coord.y] == MapCellState.WALL

func check_coord_has_snake(coord: Vector2i) -> bool:
    return cell_data_[coord.x][coord.y] == MapCellState.SNAKE

func check_coord_has_food(coord: Vector2i) -> bool:
    return cell_data_[coord.x][coord.y] == MapCellState.FOOD

func update_coord_state(coord: Vector2i, state: MapCellState) -> void:
    if not check_coord_in_range(coord):
        return
    cell_data_[coord.x][coord.y] = state

#endregion
