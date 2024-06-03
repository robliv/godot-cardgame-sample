extends Control

# Get these from level_controller
var game_result_win
var current_level

# Calculated next scene id
var next_level

# UI
var next_level_button
var stats_label
var game_result_label

# Signals
signal request_next_level

func _ready():
	print("post game menu loaded")
	print("game was won: " + str(game_result_win))
	next_level_button = $CanvasLayer/NextLevelButton
	game_result_label = $CanvasLayer/GameResultLabel

	# TODO update stats label ,put some game stats here or current gold/xp .. ? or let player add stat points or get new cards
	stats_label = $CanvasLayer/StatsLabel
		
	# Update button and title label based on game result
	if game_result_win:
		game_result_label.text = "VICTORY! Level " + str(current_level) + "completed!"
		next_level = current_level + 1
		next_level_button.text = "Continue to level " + str(next_level)
	else:
		game_result_label.text = "YOU LOST ON LEVEL " + str(current_level) + "!"
		next_level = 0
		next_level_button.text = "GO TO MAIN MENU"
	next_level_button.pressed.connect(self._on_next_level_button_pressed)

func _on_next_level_button_pressed():
	print("Requesting level: " + str(next_level))
	emit_signal("request_next_level", next_level)

