extends Node

# Action event names
const ACTION_SNAKE_LEFT: String = "snake_left"
const ACTION_SNAKE_RIGHT: String = "snake_right"
const ACTION_SNAKE_UP: String = "snake_up"
const ACTION_SNAKE_DOWN: String = "snake_down"

# Game end string text
const GAME_START_IDLE = "Start Game!"
const GAME_END_SUCCESS: String = "Success!"
const GAME_END_FAILURE: String = "Game Over!"

# Grid map size
const MAP_WIDTH: int = 1200
const MAP_HEIGHT: int = 600
const MAP_CELL_WIDTH: int = 30
const MAP_CELL_SIZE_X: int = 40 # MAP_WIDTH / MAP_CELL_WIDTH = 40
const MAP_CELL_SIZE_Y: int = 20 # MAP_HEIGHT / MAP_CELL_WIDTH = 20

# Wall width
const WALL_WIDTH: int = 30

# Size of every snake head and body
const SNAKE_NODE_WIDTH: int = 30
const SNAKE_NODE_HEIGHT: int = 30

# Length of snake body
const SNAKE_BODY_INIT_LENGTH: int = 3
const SNAKE_BODY_MAX_LENGTH: int = (MAP_CELL_SIZE_X - 1) * (MAP_CELL_SIZE_Y - 1) - 2
