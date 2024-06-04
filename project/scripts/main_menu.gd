extends Control

var new_game_button
var current_level = 0

signal request_next_level

func _ready():
	print("main menu loaded")
	new_game_button = $CanvasLayer/NewGameButton
	new_game_button.pressed.connect(self._on_new_game_button_pressed)
	
func _on_new_game_button_pressed():
	var nextLevel = current_level+1
	print("Requesting level: " + str(nextLevel))
	emit_signal("request_next_level", nextLevel)
