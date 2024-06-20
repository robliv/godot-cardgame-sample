extends Card

func apply_effects(targets: Array[Node]) -> void:
	var draw_effect := DrawEffect.new()
	draw_effect.amount = 2
	draw_effect.execute(targets)
