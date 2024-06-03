class_name CardUI
extends Control

signal reparent_requested(which_card_ui: CardUI)

# @export var card: Card : set = _set_card

@onready var color: ColorRect = $Color
@onready var drop_point_detector: Area2D = $DropPointDetector
@onready var card_state_machine: CardStateMachine = $CardStateMachine
@onready var targets: Array[Node] = []
@onready var level_scene = get_parent().get_parent()
signal signal_trigger_damage

func _ready() -> void:
	card_state_machine.init(self)
	
func play() -> void:
	for target in targets:
		if not target:
			continue
		if target is Enemy:
			#target.take_damage(10)
			var damage : int = 10
			print("emitting card damage signal to level scene")
			emit_signal("signal_trigger_damage", damage)
	queue_free()
	
func _input(event: InputEvent) -> void:
	card_state_machine.on_input(event)
	
func _on_gui_input(event: InputEvent) -> void:
	card_state_machine.on_gui_input(event)

func _on_mouse_entered() -> void:
	card_state_machine.on_mouse_entered()

func _on_mouse_exited() -> void:
	card_state_machine.on_mouse_exited()


func _on_drop_point_detector_area_entered(area):
	if not targets.has(area):
		targets.append(area)


func _on_drop_point_detector_area_exited(area):
	targets.erase(area)
