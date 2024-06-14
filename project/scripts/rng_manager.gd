# Singleton autoload script: scripts/rng_manager.gd = RngManager
# example usage:
# var game_seed : String = "hi"
# RngManager.initialize_rng(game_seed)
# var RandomEnemyId = RngManager.GetInt(0,10)
# given same game_seed string will always return the same int
# if no seed provided, will generate random one

extends Node

var rng = RandomNumberGenerator.new()
var current_seed : String = ""

func generate_random_seed() -> String:
	return str(rng.randi_range(0, 99999999))

func initialize_rng(game_seed: String):
	if game_seed == "":
		game_seed = generate_random_seed()
	current_seed = game_seed
	rng.seed = hash_djb2(game_seed)

func hash_djb2(game_seed: String) -> int:
	# uses djb2 algo to turn string into a hash
	var game_hash = 5381
	for i in range(game_seed.length()):
		game_hash = ((game_hash << 5) + game_hash) + game_seed[i].to_int()
	return game_hash

func get_int(min_val: int, max_val: int) -> int:
	return rng.randi_range(min_val, max_val)

func shuffle_array(arr: Array):
	# Shuffle the array using the RNG
	for i in range(arr.size()):
		var swap_index = rng.randi_range(i, arr.size() - 1)
		# Manually swap elements
		var temp = arr[i]
		arr[i] = arr[swap_index]
		arr[swap_index] = temp
