extends CharacterBody2D

var health = 100

func _ready():
	$HealthBar.value = health

func take_damage(amount):
	health -= amount
	$HealthBar.value = health
	if health <= 0:
		die()

func playAnimation(animation):
	$AnimatedSprite2D.play(animation)
	
func die():
	queue_free()
	get_tree().call_group("UI", "show_message", "Enemy Died! You Win!")
