extends Node

# Get these from level_controller
@export var current_level : int

# For setting the game end result true if game was won
var game_result_win

var player
var enemy
var message_label
var player_healthbar
var enemy_healthbar
var enemy_strength
var enemy_strength_meter

var card = load("res://scenes/card.tscn")
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
	message_label = $CanvasLayer/MessageLabel
	player_healthbar = $Player/HealthBar
	enemy_healthbar = $Enemy/HealthBar
	enemy_strength_meter = $CanvasLayer/StrengthEnemy
	end_turn = $CanvasLayer/EndTurn
	
	set_strength("enemy")
	# Connect signals
	if end_turn:
		end_turn.pressed.connect(self._on_end_turn_button_pressed)
	else:
		print("Error: Buttons are not correctly referenced")
	show_message("Your turn!")
	
	# Generate cards in hand
	for n in 5:
		print(str("Times:",n))
		var scene_instance = card.instantiate()
		scene_instance.set_name(str("card_",n))
		add_child(scene_instance)
		scene_instance.position = Vector2(n+(n*15)-30, 0) 

func _on_end_turn_button_pressed():
	print("End turn button pressed")
	call_deferred("enemy_turn")
	
func _on_attack_button_pressed():
	print("Attack button pressed")
	#if player_turn:
		#var damage = player_strength
		#playAnimation("player","attack")
		#enemy.take_damage(damage)
		#show_message("Dealt " + str(damage) + " damage!")
		#player_turn = false
		#call_deferred("enemy_turn")

func _on_defend_button_pressed():
	print("Defend button pressed")
	#if player_turn:
		#playAnimation("player","defend")
		#player_defend = true
		#player_turn = false
		#call_deferred("enemy_turn")

func enemy_turn():
	await get_tree().create_timer(1.0).timeout
	var damage = enemy_strength
	playAnimation("enemy","attack")
	player.take_damage(damage)
	show_message("Enemy hit you for " + str(damage) + " damage.")
	player_turn = true
	if player.health > 0 and enemy.health > 0:
		set_strength("player")
		set_strength("enemy")
		show_message("Player Turn")
	elif enemy.health < 1:
		game_result_win = true
		show_message("Victory!")
		controls_visible(false)
		await get_tree().create_timer(5.0).timeout
		request_post_game_menu()
	else:
		game_result_win = false
		show_message("You died!")
		controls_visible(false)
		await get_tree().create_timer(5.0).timeout
		request_post_game_menu()

func show_message(text):
	message_label.text = text

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
	# TODO this code is shit , need to use signal to child node instead to trigger animations
	if character == "player":
		player.playAnimation(animation)
		if animation == "attack":
			enemy.playAnimation("hurt")
		await get_tree().create_timer(1.0).timeout
	else:
		enemy.playAnimation("attack")
		player.playAnimation("hurt")
		await get_tree().create_timer(1.0).timeout
	#if player:
		#player.playAnimation("idle")
	#if enemy:
		#enemy.playAnimation("idle")
