class_name Enemy
extends Area2D

@onready var anim_player = $AnimatedSprite2D
var is_attacking = false
var is_hurting = false

@export var stats: Stats : set = set_enemy_stats
@onready var stats_ui: StatsUI = $StatsUI
@onready var attack_indicator: Node2D = $AttackIndicator

func _ready():
	anim_player.play("idle")
	attack_indicator.visible = false
	
func set_enemy_stats(value: Stats) -> void:
	stats = value.create_instance()
	
	if not stats.stats_changed.is_connected(update_stats):
		stats.stats_changed.connect(update_stats)
	
	update_enemy()
	
func update_enemy() -> void:
	if not stats is Stats: 
		return
	if not is_inside_tree(): 
		await ready
	
	update_stats()
	
func set_target() -> void:
	attack_indicator.visible = true
	
func unset_target() -> void:
	attack_indicator.visible = false
	
func update_stats() -> void:
	stats_ui.update_stats(stats)
	
func play_animation(animation):
	if animation == "attack" and not is_attacking:
		trigger_attack_anim()
	if animation == "hurt" and not is_hurting:
		trigger_hurt_anim()

func trigger_attack_anim():
	# Set the flag to true when attack is in progress
	is_attacking = true
	anim_player.play("attack")
	await get_tree().create_timer(1.0).timeout
	is_attacking = false
	anim_player.play("idle")

func trigger_hurt_anim():
	# Set the flag to true when hurt is in progress
	is_hurting = true
	anim_player.play("hurt")
	await get_tree().create_timer(0.6).timeout
	is_hurting = false
	anim_player.play("idle")

func take_damage(amount):
	if stats.health <= 0:
		return
	play_animation("hurt")
	stats.take_damage(amount)
	if stats.health <= 0:
		die()
	
func die():
	# TODO fix this
	anim_player.play("death")
	await get_tree().create_timer(2.0).timeout
	queue_free()
