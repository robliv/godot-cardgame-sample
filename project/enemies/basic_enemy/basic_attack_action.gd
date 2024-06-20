extends EnemyAction

@export var damage := 4

func perform_action() -> void:
	if not enemy or not target:
		return
	
	var damage_effect := DamageEffect.new()
	var target_array: Array[Node] = [target]
	damage_effect.amount = damage
	
	damage_effect.execute(target_array)
	
	#Events.enemy_action_completed.emit(enemy)
