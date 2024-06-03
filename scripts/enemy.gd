class_name Enemy
extends Area2D

var health = 100

@onready var anim_player = $AnimatedSprite2D
var is_attacking = false
var is_hurting = false

func _ready():
	$HealthBar.value = health
	anim_player.play("idle")
	
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
	health -= amount
	$HealthBar.value = health
	play_animation("hurt")
	if health <= 0:
		die()
	
func die():
	# TODO fix this
	anim_player.play("death")
	await get_tree().create_timer(2.0).timeout
	queue_free()
