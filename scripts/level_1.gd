extends Node

const CURRENT_LEVEL = 1
const CURRENT_LEVEL_PATH = "res://scenes/levels/level_1.tscn"

var player
var enemy
var attack_button
var defend_button
var message_label
var player_healthbar
var enemy_healthbar
var player_strength
var player_strength_meter
var enemy_strength
var enemy_strength_meter

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
	player_strength_meter = $CanvasLayer/StrengthPlayer
	enemy_strength_meter = $CanvasLayer/StrengthEnemy
	set_strength("player")
	set_strength("enemy")
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
		var damage = player_strength
		playAnimation("player","attack")
		enemy.take_damage(damage)
		show_message("Dealt " + str(damage) + " damage!")
		player_turn = false
		call_deferred("enemy_turn")

func _on_defend_button_pressed():
	print("Defend button pressed")
	if player_turn:
		playAnimation("player","defend")
		player_defend = true
		show_message("You defend with " + str(player_strength) + " strength!")
		player_turn = false
		call_deferred("enemy_turn")

func enemy_turn():
	await get_tree().create_timer(1.0).timeout
	var damage = enemy_strength
	if player_defend:
		var newDamage = damage - player_strength
		if newDamage < 0:
			damage = 0
		else:
			damage = newDamage
		player_defend = false
	playAnimation("enemy","attack")
	player.take_damage(damage)
	show_message("Enemy hit you for " + str(damage) + " damage.")
	player_turn = true
	if player.health > 0 and enemy.health > 0:
		set_strength("player")
		set_strength("enemy")
		show_message("Player Turn")
	elif enemy.health < 1:
		show_message("Victory!")
		controls_visible(false)
		await get_tree().create_timer(5.0).timeout
		request_next_level()
	else:
		show_message("You died!")
		controls_visible(false)
		await get_tree().create_timer(5.0).timeout
		request_next_level()

func show_message(text):
	message_label.text = text

# set random strength 1-10 for player or enemy char
func set_strength(char):
	var randomStrength = randi_range(1,10)
	if char == "player":
		player_strength_meter.text = "Strength:"+str(randomStrength)
		player_strength = randomStrength
	else:
		enemy_strength_meter.text = "Strength:"+str(randomStrength)
		enemy_strength = randomStrength
	
# Toggles visibility of attack and defend button controls
func controls_visible(visible):
	attack_button = $CanvasLayer/AttackButton
	defend_button = $CanvasLayer/DefendButton
	player_strength_meter = $CanvasLayer/StrengthPlayer
	enemy_strength_meter = $CanvasLayer/StrengthEnemy
	if visible:
		attack_button.show()
		defend_button.show()
		player_strength_meter.show()
		enemy_strength_meter.show()
	else:
		attack_button.hide()
		defend_button.hide()
		player_strength_meter.hide()
		enemy_strength_meter.hide()

func request_next_level():
	var nextLevelPath = CURRENT_LEVEL_PATH.replace(str(CURRENT_LEVEL), str(CURRENT_LEVEL+1));
	print("Requesting next level: " + nextLevelPath)
	emit_signal("request_next_level", nextLevelPath)
	await get_tree().create_timer(2.0).timeout # man liekas dazreiz ir bug, ja parak leeni ieladejas nakamais

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
	player.playAnimation("idle")
	enemy.playAnimation("idle")
