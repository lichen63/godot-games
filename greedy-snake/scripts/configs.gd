extends Node

# Group names
const GROUP_NAME_WALLS: String = "group_walls"
const GROUP_NAME_SNAKE: String = "group_snake"
const GROUP_NAME_FOODS: String = "group_foods"

# Action event names
const ACTION_SNAKE_LEFT: String = "snake_left"
const ACTION_SNAKE_RIGHT: String = "snake_right"
const ACTION_SNAKE_UP: String = "snake_up"
const ACTION_SNAKE_DOWN: String = "snake_down"

# Names of snake head and body
const NODE_NAME_SNAKE_HEAD: String = "snake_head"
const NODE_NAME_SNAKE_BODY_PREFIX: String = "snake_body_"

# Grid map size
const MAP_WIDTH: int = 1200
const MAP_HEIGHT: int = 600
const MAP_CELL_WIDTH: int = 30
const MAP_CELL_SIZE_X: int = 40  # MAP_WIDTH / MAP_CELL_WIDTH = 40
const MAP_CELL_SIZE_Y: int = 20 #  MAP_HEIGHT / MAP_CELL_WIDTH = 20

# Wall width
const WALL_WIDTH: int = 30

# Size of every snake head and body
const SNAKE_NODE_WIDTH: int = 30
const SNAKE_NODE_HEIGHT: int = 30

# Max length of snake body
const SNAKE_BODY_MAX_LENGTH: int = 100
