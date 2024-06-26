class_name Card
extends Resource

enum Type {ATTACK, SKILL, POWER}
enum Target {SELF, SINGLE_ENEMY, ALL_ENEMIES, EVERYONE}

@export_group("Card Attributes")
@export var id: String
@export var type: Type
@export var target: Target
@export var cost: int

@export_group("Card Visuals")
@export var icon: Texture
@export_multiline var tooltip_text: String
@export var sound: AudioStream


func is_single_targeted() -> bool:
	return target == Target.SINGLE_ENEMY


func _get_targets(targets: Array[Node]) -> Array[Node]:
	if not targets:
		return []
		
	var tree := targets[0].get_tree()
	
	match target:
		Target.SELF:
			return tree.get_nodes_in_group("player")
		Target.ALL_ENEMIES:
			return tree.get_nodes_in_group("enemies")
		Target.EVERYONE:
			return tree.get_nodes_in_group("player") + tree.get_nodes_in_group("enemies")
		_:
			return []


func play(targets: Array[Node], char_stats: CharacterStats) -> void:
	Events.card_played.emit(self)
	Events.tooltip_hide_requested.emit()
	char_stats.mana -= cost
	var obj_targets = _get_targets(targets)
	for target in obj_targets:
			target.unset_target()
	if is_single_targeted():
		for target in targets:
			target.unset_target()
		apply_effects(targets)
	else:
		apply_effects(_get_targets(targets))
	char_stats.discard.add_card(self)


func apply_effects(_targets: Array[Node]) -> void:
	pass
	
