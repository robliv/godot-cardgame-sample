extends Control

var new_game_button
const CURRENT_LEVEL_PATH = "res://scenes/levels/level_0.tscn"
const CURRENT_LEVEL = 0

signal request_next_level

func _ready():
	print("main menu loaded")
	new_game_button = $CanvasLayer/NewGameButton
	new_game_button.pressed.connect(self._on_new_game_button_pressed)
	
func _on_new_game_button_pressed():
	var nextLevelPath = CURRENT_LEVEL_PATH.replace(str(CURRENT_LEVEL), str(CURRENT_LEVEL+1));
	print("Requesting next level: " + nextLevelPath)
	emit_signal("request_next_level", nextLevelPath)
