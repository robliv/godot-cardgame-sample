class_name CardPileUI
extends Node

var card_pile: CardPile

@onready var size: Label = $Label

func set_card_pile(value: CardPile) -> void:
	if not is_node_ready():
		await ready

	card_pile = value
	size.text = str(card_pile.cards.size())
	_connect_card_pile_signals()
	
func _ready():
	if card_pile:
		_connect_card_pile_signals()
		
func _connect_card_pile_signals():
	if card_pile:
		if card_pile.is_connected("card_pile_size_changed", Callable(self, "_on_card_pile_size_changed")):
			card_pile.disconnect("card_pile_size_changed", Callable(self, "_on_card_pile_size_changed"))
		card_pile.connect("card_pile_size_changed", Callable(self, "_on_card_pile_size_changed"))
		
func _on_card_pile_size_changed(cards_amount: int) -> void:
	size.text = str(cards_amount)

