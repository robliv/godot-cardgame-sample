extends Node

const MAIN_MENU_PATH = "res://scenes/levels/level_0.tscn"
@onready var current_child: Node = null

func _ready():
	load_initial_scene()
	
func load_initial_scene():
	current_child = load_scene(MAIN_MENU_PATH)
	print("literally doing nothing")
	
func load_scene(scene_path: String) -> Node:
	print("Loading scene: " + scene_path)
	var scene = load(scene_path)
	var scene_instance = scene.instantiate()
	add_child(scene_instance)
	# TODO vajag salabot, hz kapec reference scene_instance nestrada, pagaidam nakas hardcode '$level' un visos level scene to izmantot kaa root node lai stradatu
	$level.request_next_level.connect(_on_request_scene_change)
	return scene_instance

func _on_request_scene_change(new_scene_path: String):
	print("Received next level request: " + new_scene_path)
	if current_child != null:
		current_child.queue_free()
	current_child = load_scene(new_scene_path)
	
