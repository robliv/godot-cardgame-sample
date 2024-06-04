extends CardState

var played: bool

func enter() -> void:
	card_ui.color.color = Color.DARK_VIOLET
	
	played = false
	if not card_ui.targets.is_empty():
		played = true
		card_ui.play()

func on_input(_event: InputEvent) -> void:
	if played:
		return
		
	
	transition_requested.emit(self, CardState.State.BASE)
