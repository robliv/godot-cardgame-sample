extends Node

# Get these from level_controller
@export var current_level : int

# Constant to adjust difficulty every level
const DIFFICULTY_CONSTANT = 5

# For setting the game end result true if game was won
var game_result_win

var player
var enemy
var banner_label
var level_name_label
var player_healthbar
var enemy_healthbar

var hand_ui

var mana_ui

var card_ui = load("res://scenes/card_ui.tscn")

var end_turn

var player_turn = true
var player_defend = false
var game_over = false
var new_game = true

var discard_pile
var draw_pile

var seed_label

signal signal_request_post_game_menu

func _ready():
	print("Level scene starting. Current level set to: " + str(current_level))
	player = $Player
	enemy = $Enemy
	banner_label = $CanvasLayer/BannerLabel
	level_name_label = $CanvasLayer/LevelNameLabel
	level_name_label.text = "LEVEL "+str(current_level)
	#player_healthbar = $Player/HealthBar
	#enemy_healthbar = $Enemy/HealthBar
	end_turn = $CanvasLayer/EndTurn
	hand_ui = $CanvasLayer/Hand
	mana_ui = $CanvasLayer/ManaUI
	discard_pile = $CanvasLayer/DiscardPile
	draw_pile = $CanvasLayer/DrawPile

	seed_label = $CanvasLayer/SeedLabel
	seed_label.text = "Seed: "+RngManager.current_seed
	set_enemy_damage()
	# Connect signals
	
	mana_ui._set_char_stats(player.stats)
	hand_ui.char_stats = player.stats
	
	if end_turn:
		end_turn.pressed.connect(self._on_end_turn_button_pressed)
	else:
		print("Error: Buttons are not correctly referenced")
	update_banner("Your turn!")
	player.stats.draw_pile = player.stats.deck.duplicate(true)
	player.stats.draw_pile.shuffle()
	
	discard_pile.set_card_pile(player.stats.discard)
	draw_pile.set_card_pile(player.stats.draw_pile)
	call_deferred("player_turn_started")
	
	
func player_turn_started():
	print("Player turn started")
	update_banner("Player Turn")
	player.stats.reset_mana()
	# draw cards
	for n in player.stats.cards_per_turn:
		if(player.stats.draw_pile.empty()):
			while not player.stats.discard.empty():
				player.stats.draw_pile.add_card(player.stats.discard.draw_card())
				player.stats.draw_pile.shuffle()
				
		var card_drawn = player.stats.draw_pile.draw_card()
		hand_ui.add_card(card_drawn)

func _on_signal_trigger_damage(damage):
	print("received signal to trigger "+ str(damage)+" damage to enemy")
	damage_enemy(damage)
	
func _on_end_turn_button_pressed():
	print("End turn button pressed")
	# discard all cards
	for card_ui: CardUI in hand_ui.get_children():
		player.stats.discard.add_card(card_ui.card)
		hand_ui.discard_card(card_ui)
	call_deferred("enemy_turn")	

func enemy_turn():
	await get_tree().create_timer(0.5).timeout # cinematic pause
	# damage_player(enemy_strength)
	player_turn = true
	set_enemy_damage()
	call_deferred("player_turn_started")

func damage_player(damage: int):
	enemy.play_animation("attack")
	# player.take_damage(enemy_strength)
	update_banner("Enemy hit you for " + str(damage) + " damage")
	# check if player still alive
	if player.stats.health < 0:
		# player is dead, end level
		game_result_win = false
		update_banner("You died!")
		# controls_visible(false)
		await get_tree().create_timer(4.0).timeout
		request_post_game_menu()
		
func damage_enemy(damage: int):
	player.play_animation("attack")
	enemy.take_damage(damage)
	# TODO use signal to check when animation is done instead of timer	
	await get_tree().create_timer(0.5).timeout 
	update_banner("You hit the enemy for " + str(damage) + " damage")
	# check if enemy still alive
	if enemy.stats.health < 1:
		# enemy is dead, end level
		game_result_win = true
		update_banner("Victory! You destroyed the enemy!")
		# controls_visible(false)
		await get_tree().create_timer(4.0).timeout
		request_post_game_menu()
	
func update_banner(text):
	banner_label.text = text

# set random strength for enemy attack
func set_enemy_damage():
	var base_damage = randi_range(15,30)
	var total_damage = base_damage + round(current_level * DIFFICULTY_CONSTANT)
	# enemy_strength_meter.text = "⚔ "+str(total_damage)
	# enemy_strength = total_damage

func request_post_game_menu():
	print("Requesting post game screen")
	emit_signal("signal_request_post_game_menu", current_level,game_result_win)
