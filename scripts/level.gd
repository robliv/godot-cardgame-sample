extends Node

# Get these from level_controller
@export var current_level : int

@export var handSize: int = 5

# For setting the game end result true if game was won
var game_result_win

var player
var enemy
var banner_label
var level_name_label
var player_healthbar
var enemy_healthbar
var enemy_strength
var enemy_strength_meter

var card_ui = load("res://scenes/card_ui/card_ui.tscn")

var hand_ui

var end_turn

var player_turn = true
var player_defend = false
var game_over = false
var new_game = true

signal signal_request_post_game_menu

func _ready():
	print("Level scene starting. Current level set to: " + str(current_level))
	player = $Player
	enemy = $Enemy
	banner_label = $CanvasLayer/BannerLabel
	level_name_label = $CanvasLayer/LevelNameLabel
	level_name_label.text = "LEVEL "+str(current_level)
	player_healthbar = $Player/HealthBar
	enemy_healthbar = $Enemy/HealthBar
	enemy_strength_meter = $CanvasLayer/StrengthEnemy
	end_turn = $CanvasLayer/EndTurn
	hand_ui = $CanvasLayer/Hand
	
	set_strength("enemy")
	# Connect signals
	if end_turn:
		end_turn.pressed.connect(self._on_end_turn_button_pressed)
	else:
		print("Error: Buttons are not correctly referenced")
	update_banner("Your turn!")
	call_deferred("player_turn_started")
	
func player_turn_started():
	print("Player turn started")
	# draw cards
	for n in handSize:
		var instance = card_ui.instantiate()
		hand_ui.add_child(instance)

func _on_end_turn_button_pressed():
	print("End turn button pressed")
	call_deferred("enemy_turn")

func enemy_turn():
	await get_tree().create_timer(1.0).timeout
	var damage = enemy_strength
	playAnimation("enemy","attack")
	player.take_damage(damage)
	update_banner("Enemy hit you for " + str(damage) + " damage.")
	player_turn = true
	if player.health > 0 and enemy.health > 0:
		set_strength("player")
		set_strength("enemy")
		update_banner("Player Turn")
	elif enemy.health < 1:
		game_result_win = true
		update_banner("Victory!")
		controls_visible(false)
		await get_tree().create_timer(5.0).timeout
		request_post_game_menu()
	else:
		game_result_win = false
		update_banner("You died!")
		controls_visible(false)
		await get_tree().create_timer(5.0).timeout
		request_post_game_menu()
	call_deferred("player_turn_started")

func update_banner(text):
	banner_label.text = text

# set random strength 1-10 for player or enemy char
func set_strength(char):
	var randomStrength = randi_range(20,30)
	enemy_strength_meter.text = "Strength:"+str(randomStrength)
	enemy_strength = randomStrength
	
# Toggles visibility of attack and defend button controls
func controls_visible(visible):
	enemy_strength_meter = $CanvasLayer/StrengthEnemy
	if visible:
		enemy_strength_meter.show()
	else:
		enemy_strength_meter.hide()

func request_post_game_menu():
	print("Requesting post game screen")
	emit_signal("signal_request_post_game_menu", current_level,game_result_win)

func playAnimation(character, animation):
	if character == "player":
		player.play_animation(animation)
		if animation == "attack":
			enemy.play_animation("hurt")
	else:
		enemy.play_animation("attack")
		player.play_animation("hurt")


