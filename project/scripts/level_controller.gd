extends Node

const MAIN_MENU_PATH = "res://scenes/levels/main_menu.tscn"
const POST_GAME_MENU_PATH = "res://scenes/levels/post_game_screen.tscn"
const LEVEL_SCENE_PATH = "res://scenes/levels/level.tscn"

func _ready():
	# Game starts here, loads main menu scene
	load_main_menu()
	# TODO this is temp stuff
	#var mapscene = load("res://scenes/levels/testMapGen.tscn")
	#var mapscene_instance = mapscene.instantiate()
	#add_child(mapscene_instance)
	
func load_main_menu():
	print("Loading main menu: " + MAIN_MENU_PATH)
	remove_child_nodes()
	var scene = load(MAIN_MENU_PATH)
	var scene_instance = scene.instantiate()
	scene_instance.current_level = 0
	add_child(scene_instance)
	$main_menu.request_next_level.connect(_on_request_load_level)
	$main_menu.request_map.connect(_on_request_map)
	
func load_level(next_level_id):
	print("Loading level scene: " + LEVEL_SCENE_PATH)
	print("Will load Level ID: " + str(next_level_id))
	remove_child_nodes()
	var scene = load(LEVEL_SCENE_PATH)
	var scene_instance = scene.instantiate()
	scene_instance.current_level = next_level_id
	add_child(scene_instance)
	$level.signal_request_post_game_menu.connect(_on_request_load_post_game)
	
func load_post_game(current_level_id,game_result_win):
	print("Loading post game scene: " + POST_GAME_MENU_PATH)
	print("Current Level ID: " + str(current_level_id))
	remove_child_nodes()
	var scene = load(POST_GAME_MENU_PATH)
	var scene_instance = scene.instantiate()
	scene_instance.current_level = current_level_id
	scene_instance.game_result_win = game_result_win
	add_child(scene_instance)
	$post_game_screen.request_next_level.connect(_on_request_load_level)
	
func remove_child_nodes():
	if get_node_or_null("main_menu"):
		print("Removing child node: main_menu")
		get_node("main_menu").queue_free()
	if get_node_or_null("level"):
		print("Removing child node: level")
		get_node("level").queue_free()
	if get_node_or_null("post_game_screen"):
		print("Removing child node: post_game_screen")
		get_node("post_game_screen").queue_free()
	
func _on_request_load_post_game(current_level_id: int, game_result_win: bool):
	print("Received post game screen request. Level: " + str(current_level_id))
	load_post_game(current_level_id,game_result_win)

func _on_request_load_level(next_level_id: int):
	print("Received next level request: " + str(next_level_id))
	if next_level_id != 0:
		load_level(next_level_id)
	else:
		load_main_menu()

func _on_request_map():
	print("Received map request")
	remove_child_nodes()
	var scene = load("res://scenes/map.tscn")
	var scene_instance = scene.instantiate()
	add_child(scene_instance)

