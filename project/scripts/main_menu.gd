extends Control

var new_game_button
var current_level = 0

var enemy_type_label
var generate_button
var seed_textbox

signal request_next_level

func _ready():
	print("main menu loaded")
	new_game_button = $CanvasLayer/NewGameButton
	new_game_button.pressed.connect(self._on_new_game_button_pressed)
	seed_textbox = $CanvasLayer/Seed

	
func _on_new_game_button_pressed():
	RngManager.initialize_rng(seed_textbox.text)
	print("current_seed set to: " + seed_textbox.text)
	var nextLevel = current_level+1
	print("Requesting level: " + str(nextLevel))
	emit_signal("request_next_level", nextLevel)
