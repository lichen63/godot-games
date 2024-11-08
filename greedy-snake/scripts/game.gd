extends Node

#region export vars
@export var snake_move_timer_: Timer = null
@export var snake_nodes_: Node2D = null
@export var result_panel_: Node = null
@export var snake_food_: Node2D = null
#endregion

#region private vars
var game_state_: Configs.GameState = Configs.GameState.IDLE
#endregion

#region public methods
# Update the game state
func update_game_state(state: Configs.GameState) -> void:
    if self.game_state_ == state and state != Configs.GameState.IDLE:
      return
  
    self.result_panel_.exit_state(self.game_state_)
    self.snake_move_timer_.exit_state(self.game_state_)
    self.snake_nodes_.exit_state(self.game_state_)
    self.snake_food_.exit_state(self.game_state_)
    self.exit_state(self.game_state_)

    self.game_state_ = state

    self.enter_state(state)
    self.snake_food_.enter_state(state)
    self.snake_nodes_.enter_state(state)
    self.snake_move_timer_.enter_state(state)
    self.result_panel_.enter_state(state)

func exit_state(state: Configs.GameState) -> void:
    match state:
        Configs.GameState.IDLE:
            pass
        Configs.GameState.PLAYING:
            pass
        Configs.GameState.SUCCESS:
            MapController.reset_map_cell_state()
        Configs.GameState.FAILURE:
            MapController.reset_map_cell_state()
        Configs.GameState.PAUSED:
            pass
        _:
            pass

func enter_state(state: Configs.GameState) -> void:
  match state:
        Configs.GameState.IDLE:
            MapController.reset_map_cell_state()
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

#endregion

#region private methods

#endregion

#region private signals
# Called when the node enters the scene tree for the first time
func _ready() -> void:
    self.update_game_state(Configs.GameState.IDLE)

# Called during the physics processing step of the main loop
func _physics_process(_delta: float) -> void:
    if Input.get_action_strength(Configs.ACTION_GAME_PAUSE):
        self.update_game_state(Configs.GameState.PAUSED)

func _on_snake_nodes_on_snake_moving_to_coord(coord: Vector2i) -> void:
    if not MapController.check_coord_is_available(coord):
        self.update_game_state(Configs.GameState.FAILURE)

#endregion
