extends Node

var player
var enemy
var attack_button
var defend_button
var message_label
var player_healthbar
var enemy_healthbar

var card

var player_turn = true
var player_defend = false
var game_over = false
var new_game = true

func _ready():
	print("func: _ready")
	player = $Player
	enemy = $Enemy
	attack_button = $CanvasLayer/AttackButton
	defend_button = $CanvasLayer/DefendButton
	message_label = $CanvasLayer/MessageLabel
	player_healthbar = $Player/HealthBar
	enemy_healthbar = $Enemy/HealthBar
	card = $Card
	
	# Connect signals
	if attack_button and defend_button:
		attack_button.pressed.connect(self._on_attack_button_pressed)
		defend_button.pressed.connect(self._on_defend_button_pressed)
	else:
		print("Error: Buttons are not correctly referenced")
	show_message("Your turn!")
	
	
func _on_attack_button_pressed():
	print("Attack button pressed")
	if player_turn:
		var damage = randi() % 10 + 1
		enemy.take_damage(damage)
		show_message("Dealt " + str(damage) + " damage!")
		player_turn = false
		call_deferred("enemy_turn")

func _on_defend_button_pressed():
	print("Defend button pressed")
	if player_turn:
		player_defend = true
		show_message("Player defends! +5 def")
		player_turn = false
		call_deferred("enemy_turn")

func enemy_turn():
	await get_tree().create_timer(1.0).timeout
	var damage = randi() % 10 + 1
	if player_defend:
		damage -= 5
		player_defend = false
	player.take_damage(damage)
	show_message("Enemy hit you for " + str(damage) + " damage.")
	player_turn = true
	if player.health > 0 and enemy.health > 0:
		show_message("Player Turn")
	elif enemy.health > 0:
		show_message("Victory!")
		controls_visible(false)
		await get_tree().create_timer(5.0).timeout
		queue_free()
	else:
		show_message("You died!")
		controls_visible(false)
		await get_tree().create_timer(5.0).timeout
		queue_free()

func show_message(text):
	message_label.text = text

# Toggles visibility of attack and defend button controls
func controls_visible(visible):
	attack_button = $CanvasLayer/AttackButton
	defend_button = $CanvasLayer/DefendButton
	if visible:
		attack_button.show()
		defend_button.show()
	else:
		attack_button.hide()
		defend_button.hide()
