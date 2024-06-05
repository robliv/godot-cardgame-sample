class_name Player
extends CharacterBody2D

@onready var anim_player = $AnimatedSprite2D
var is_attacking = false
var is_hurting = false

@export var stats: CharacterStats : set = set_character_stats
@onready var stats_ui: StatsUI = $StatsUI

func _ready():
	anim_player.play("idle")
	
func set_character_stats(value: CharacterStats) -> void:
	stats = value
	
	if not stats.stats_changed.is_connected(update_stats):
		stats.stats_changed.connect(update_stats)

	update_player()


func update_player() -> void:
	if not stats is CharacterStats: 
		return
	if not is_inside_tree(): 
		await ready
	update_stats()


func update_stats() -> void:
	print(str("health", stats.health))
	print(str("max_health", stats.max_health))
	stats_ui.update_stats(stats)
	
func play_animation(animation):
	if animation == "attack" and not is_attacking:
		trigger_attack()
	if animation == "hurt" and not is_hurting:
		trigger_hurt()

func trigger_attack():
	# Set the flag to when attack is in progress
	is_attacking = true
	anim_player.play("attack")
	await get_tree().create_timer(1.0).timeout
	is_attacking = false
	anim_player.play("idle")

func trigger_hurt():
	# Set the flag to when hurt is in progress
	is_hurting = true
	anim_player.play("hurt")
	await get_tree().create_timer(0.6).timeout
	is_hurting = false
	anim_player.play("idle")

func take_damage(damage: int) -> void:
	if stats.health <= 0:
		return
	stats.take_damage(damage)
	if stats.health <= 0:
		die()
	
func die():
	anim_player.play("death")
	await get_tree().create_timer(1.0).timeout
	anim_player.pause()
	

