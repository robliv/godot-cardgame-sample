extends Control

var new_game_button
var current_level = 0

var enemy_type_label
var generate_button
var seed_textbox

var continue_button
var save_file
var save_file_path = "user://save_game.dat"

signal request_map
signal request_next_level

func _ready():
	new_game_button = $CanvasLayer/NewGameButton
	new_game_button.pressed.connect(self._on_new_game_button_pressed)
	seed_textbox = $CanvasLayer/SeedTextbox
	continue_button = $CanvasLayer/ContinueButton
	
	save_file = FileAccess.open(save_file_path, FileAccess.READ)
	if save_file:
		continue_button.show()
		continue_button.pressed.connect(self._on_continue_button_pressed)
	else:
		continue_button.hide()
	print("main menu loaded")

func _on_new_game_button_pressed():
	RngManager.initialize_rng(seed_textbox.text)
	print("current_seed set to: " + seed_textbox.text)
	create_new_save()
	var nextLevel = current_level+1
	print("Requesting level: " + str(nextLevel))
	emit_signal("request_next_level", nextLevel)
	# TODO change this after map is done to go to map scene instead
	
func _on_continue_button_pressed():
	#load_game(save_file)
	print("Requesting map")
	emit_signal("request_map")
	
func create_new_save():
	var save_data = {
			"seed": RngManager.current_seed
			, "act": "0"
			, "level": ""
			, "path": ""
			, "currentHealth": "100"
			, "maxHealth": "100"
			, "itemsList": ""
			, "cardsList": "" }
	var file = FileAccess.open(save_file_path,FileAccess.WRITE)
	file.store_string(str(save_data))
	file.close()
	print('New game save created in %APPDATA%/Godot/app_userdata/CardGame/save_game.dat')
	
func load_game(save_file):
	var save_content = save_file.get_as_text()
	var json = JSON.new()
	var parse_result = json.parse(save_content)
	if not parse_result == OK:
		print("JSON Parse Error: ", json.get_error_message(), " in ", save_content, " at line ", json.get_error_line())
	var save_data = json.get_data()
	var current_seed = save_data["seed"]
	RngManager.initialize_rng(str(current_seed))
	print("current_seed set to: " + RngManager.current_seed)
	# TODO set globals act, level num, items etc.
	save_file.close()
	print("Game save was loaded")
